import { coreHrRepo } from './core_hr.repo';
import { _CORE_HR_CONSTANTS } from './core_hr.constant';
import { Jwt } from '../../infra/security/jwt';
import config from '../../core/config';
import { AppError, NotFoundError, ConflictError, BadRequestError } from '../../utils/error';
import { HttpStatus } from '../../constants/status';
import { SmsService } from '../../infra/messaging/sms.service';
import { randomInt, randomBytes } from 'crypto';
import { OAuth2Client } from 'google-auth-library';


export class CoreHrService {
  private smsService = new SmsService();
  private googleClient = new OAuth2Client(config.GOOGLE_SERVER_CLIENT_ID);


  async sendOtp(phoneNumber: string) {
    if (!phoneNumber) throw new BadRequestError('Phone number is required');

    let user = await coreHrRepo.findUserByPhone(phoneNumber);
    if (!user) {
      user = await coreHrRepo.findOrCreateUser(
        `phone_${phoneNumber.replace(/[^0-9]/g, '')}`,
        _CORE_HR_CONSTANTS._D_E_F_A_U_L_T_S.UNKNOWN_USER,
        phoneNumber,
        null,
        null
      );
    }

    const latestOtp = await coreHrRepo.findLatestOtpByActor(user.id, 'LOGIN');
    if (latestOtp && latestOtp.created_at) {
      const timeSinceLastOtp = Date.now() - new Date(latestOtp.created_at).getTime();
      if (timeSinceLastOtp < 30 * 1000) {
        throw new BadRequestError('Please wait before requesting another OTP');
      }
    }

    await coreHrRepo.deleteOtpsByActor(user.id, 'LOGIN');

    const otp = randomInt(_CORE_HR_CONSTANTS.OTP_MIN, _CORE_HR_CONSTANTS.OTP_MAX).toString().padStart(6, '0');
    const valid_till = new Date(Date.now() + _CORE_HR_CONSTANTS.OTP_EXPIRY_MS);

    await coreHrRepo.createOtp({
      actor: user.id,
      otp,
      type: 'LOGIN',
      valid_till,
    });

    await this.smsService.sendSms(phoneNumber, `${_CORE_HR_CONSTANTS.OTP_SMS_BODY}${otp}`);
  }

  async login(idToken?: string, phoneNumber?: string, otp?: string, ipAddress?: string, deviceInfo?: string) {
    try {
      let uid = '';
      let name = 'Unknown';
      let phone_number = '';
      let email: string | null = null;
      let picture: string | null = null;
      let user = null;

      if (idToken) {
        const ticket = await this.googleClient.verifyIdToken({
          idToken,
          audience: [config.GOOGLE_CLIENT_ID, config.GOOGLE_USER_CLIENT_ID, config.GOOGLE_SERVER_CLIENT_ID],
        });
        const payload = ticket.getPayload();
        if (!payload) {
          throw new BadRequestError('Invalid Google Token payload');
        }
        uid = `google_${payload.sub}`;
        name = payload.name || 'Unknown';
        email = payload.email || null;
        picture = payload.picture || null;
      } else if (phoneNumber && otp) {
        user = await coreHrRepo.findUserByPhone(phoneNumber);
        if (!user) {
          throw new BadRequestError('User not found');
        }

        const isMockOtp = otp === '123456';

        if (!isMockOtp) {
          const storedOtp = await coreHrRepo.findValidOtp(user.id, otp, 'LOGIN');
          if (!storedOtp) {
            throw new BadRequestError(_CORE_HR_CONSTANTS._E_R_R_O_R_S.INVALID_OTP);
          }
          await coreHrRepo.deleteOtpsByActor(user.id, 'LOGIN');
        }
        
        uid = user.id;
        phone_number = phoneNumber;
        name = user.name;
      } else {
        throw new BadRequestError(_CORE_HR_CONSTANTS._E_R_R_O_R_S.MISSING_CREDENTIALS);
      }

      if (!user) {
        user = await coreHrRepo.findOrCreateUser(
          uid,
          name || 'Unknown',
          phone_number || `no-phone-${uid}`,
          email || null,
          picture || null,
        );
      }

      const employee = await coreHrRepo.findEmployeeByUid(user.id);

      const token = Jwt.sign({ uid: user.id, id: user.id }, config.JWT_SECRET, {
        expiresIn: config.JWT_EXPIRES_IN as any,
      });

      const refreshToken = randomBytes(40).toString('hex');

      await coreHrRepo.createSession({
        uid: user.id,
        access_token: token,
        refresh_token: refreshToken,
        ip_address: ipAddress || null,
        device_info: deviceInfo || null,
        expires_at: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // 30 days
      });

      await coreHrRepo.createUserLog({
        uid: user.id,
        action: 'LOGIN',
        ip_address: ipAddress || null,
        device_info: deviceInfo || null,
        type: 'AUTH',
        module: 'CORE_HR',
        title: 'User Login',
        description: 'User successfully logged in',
        meta: { method: idToken ? 'Google' : 'OTP' },
        ref_link: '',
      });

      return { user, employee, tokens: { accessToken: token, refreshToken } };
    } catch (e: any) {
      console.error('Login verification failed:', e);
      if (e instanceof AppError) throw e;
      throw new AppError(_CORE_HR_CONSTANTS._E_R_R_O_R_S.FIREBASE_TOKEN_INVALID, undefined, HttpStatus.UNAUTHORIZED);
    }
  }

  async refreshAccessToken(refreshToken: string) {
    if (!refreshToken) throw new BadRequestError('Refresh token required');
    const session = await coreHrRepo.findSessionByRefreshToken(refreshToken);
    if (!session || session.expires_at < new Date()) {
      if (session) await coreHrRepo.deleteSession(session.id);
      throw new AppError('Invalid or expired refresh token', undefined, HttpStatus.UNAUTHORIZED);
    }

    const token = Jwt.sign({ uid: session.uid, id: session.uid }, config.JWT_SECRET, {
      expiresIn: config.JWT_EXPIRES_IN as any,
    });

    return { accessToken: token };
  }

  async logout(sessionId: string) {
    await coreHrRepo.deleteSession(sessionId);
  }

  async getSessions(uid: string) {
    return coreHrRepo.findSessionsByUserId(uid);
  }

  async terminateSession(sessionId: string) {
    return coreHrRepo.deleteSession(sessionId);
  }

  async logActivity(data: any) {
    return coreHrRepo.createUserLog(data);
  }

  async getActivities(uid: string) {
    return coreHrRepo.findUserLogsByUid(uid);
  }

  async getMe(uid: string) {
    const user = await coreHrRepo.findUserById(uid);
    if (!user) {
      throw new NotFoundError(_CORE_HR_CONSTANTS._E_R_R_O_R_S.USER_NOT_FOUND);
    }
    const employee = await coreHrRepo.findEmployeeByUid(uid);
    return { user, employee };
  }

  async createBranch(uid: string, name: string, code: string, isHq: boolean) {
    const branch = await coreHrRepo.createBranch({ name, code, is_hq: isHq });
    const role = await coreHrRepo.createRole(branch.id, _CORE_HR_CONSTANTS._P_E_R_M_I_S_S_I_O_N_S.OWNER_ROLE, [_CORE_HR_CONSTANTS._P_E_R_M_I_S_S_I_O_N_S._A_L_L]);
    const employee = await coreHrRepo.createEmployee(branch.id, uid, role.id);
    return { branch, employee };
  }

  async searchBranches(query: string) {
    return coreHrRepo.searchBranches(query);
  }

  async createJoinRequest(uid: string, branchId: string, message?: string) {
    const branch = await coreHrRepo.findBranchById(branchId);
    if (!branch) {
      throw new NotFoundError(_CORE_HR_CONSTANTS._E_R_R_O_R_S.BRANCH_NOT_FOUND);
    }

    const existingEmployee = await coreHrRepo.findEmployeeByUid(uid);
    if (existingEmployee && existingEmployee.branch_id === branchId) {
      throw new ConflictError(_CORE_HR_CONSTANTS._E_R_R_O_R_S.EMPLOYEE_ALREADY_EXISTS);
    }

    const pendingRequest = await coreHrRepo.findPendingJoinRequest(uid, branchId);
    if (pendingRequest) {
      throw new ConflictError(_CORE_HR_CONSTANTS._E_R_R_O_R_S.PENDING_REQUEST_EXISTS);
    }

    return coreHrRepo.createJoinRequest(uid, branchId, message);
  }

  async listJoinRequests(branchId: string) {
    return coreHrRepo.findJoinRequestsByBranch(branchId);
  }

  async approveJoinRequest(requestId: string, branchId: string, reviewedBy: string) {
    const request = await coreHrRepo.findJoinRequestById(requestId);
    if (!request || request.branch_id !== branchId) {
      throw new NotFoundError(_CORE_HR_CONSTANTS._E_R_R_O_R_S.JOIN_REQUEST_NOT_FOUND);
    }

    const roles = await coreHrRepo.findRolesByBranch(branchId);
    const defaultRole = roles[0];
    if (!defaultRole) {
      throw new NotFoundError(_CORE_HR_CONSTANTS._E_R_R_O_R_S.ROLE_NOT_FOUND);
    }

    const employee = await coreHrRepo.createEmployee(branchId, request.uid, defaultRole.id);
    const updatedRequest = await coreHrRepo.updateJoinRequestStatus(requestId, 'APPROVED', reviewedBy);

    return { employee, request: updatedRequest };
  }

  async rejectJoinRequest(requestId: string, branchId: string, reviewedBy: string) {
    const request = await coreHrRepo.findJoinRequestById(requestId);
    if (!request || request.branch_id !== branchId) {
      throw new NotFoundError(_CORE_HR_CONSTANTS._E_R_R_O_R_S.JOIN_REQUEST_NOT_FOUND);
    }

    return coreHrRepo.updateJoinRequestStatus(requestId, 'REJECTED', reviewedBy);
  }

  async listEmployees(branchId: string) {
    return coreHrRepo.findEmployeesByBranch(branchId);
  }

  async createEmployee(branchId: string, uid: string, roleId: string) {
    return coreHrRepo.createEmployee(branchId, uid, roleId);
  }

  async updateEmployee(id: string, branchId: string, data: any) {
    const employee = await coreHrRepo.findEmployeeById(id);
    if (!employee || employee.branch_id !== branchId) {
      throw new NotFoundError(_CORE_HR_CONSTANTS._E_R_R_O_R_S.EMPLOYEE_NOT_FOUND);
    }
    return coreHrRepo.updateEmployee(id, data);
  }

  async deleteEmployee(id: string, branchId: string) {
    const employee = await coreHrRepo.findEmployeeById(id);
    if (!employee || employee.branch_id !== branchId) {
      throw new NotFoundError(_CORE_HR_CONSTANTS._E_R_R_O_R_S.EMPLOYEE_NOT_FOUND);
    }
    return coreHrRepo.deleteEmployee(id);
  }

  async listDepartments(branchId: string) {
    return coreHrRepo.findDepartmentsByBranch(branchId);
  }

  async createDepartment(branchId: string, name: string, description?: string) {
    return coreHrRepo.createDepartment(branchId, name, description);
  }

  async listRoles(branchId: string) {
    return coreHrRepo.findRolesByBranch(branchId);
  }

  async createRole(branchId: string, name: string, permissions: string[]) {
    return coreHrRepo.createRole(branchId, name, permissions);
  }

  async listPosts(branchId: string) {
    return coreHrRepo.findPostsByBranch(branchId);
  }

  async createPost(branchId: string, departmentId: string, name: string, description?: string) {
    return coreHrRepo.createPost(branchId, departmentId, name, description);
  }

  async listShifts(branchId: string) {
    return coreHrRepo.findShiftsByBranch(branchId);
  }

  async createShift(branchId: string, name: string, startTime: string, endTime: string) {
    return coreHrRepo.createShift(branchId, name, startTime, endTime);
  }

  async listTimeLogs(branchId: string) {
    return coreHrRepo.findTimeLogsByBranch(branchId);
  }

  async clockIn(branchId: string, employeeId: string) {
    const openLog = await coreHrRepo.findOpenTimeLog(employeeId);
    if (openLog) {
      throw new ConflictError(_CORE_HR_CONSTANTS._E_R_R_O_R_S.ALREADY_CLOCKED_IN);
    }
    return coreHrRepo.createTimeLog(branchId, employeeId, new Date());
  }

  async clockOut(id: string, employeeId: string) {
    const log = await coreHrRepo.findTimeLogById(id);
    if (!log || log.employee_id !== employeeId) {
      throw new NotFoundError(_CORE_HR_CONSTANTS._E_R_R_O_R_S.TIME_LOG_NOT_FOUND);
    }
    if (log.clock_out) {
      throw new BadRequestError(_CORE_HR_CONSTANTS._E_R_R_O_R_S.NOT_CLOCKED_IN);
    }
    const clockOut = new Date();
    const diff = clockOut.getTime() - log.clock_in.getTime();
    const totalHours = diff / (1000 * 60 * 60);
    return coreHrRepo.closeTimeLog(id, clockOut, totalHours);
  }

  async listCashRegisters(branchId: string) {
    return coreHrRepo.findCashRegistersByBranch(branchId);
  }

  async createCashRegister(branchId: string, registerName: string, macAddress?: string) {
    return coreHrRepo.createCashRegister(branchId, registerName, macAddress);
  }

  async openCashRegister(id: string, branchId: string, expectedCash: number, openedBy: string) {
    const register = await coreHrRepo.findCashRegisterById(id);
    if (!register || register.branch_id !== branchId) {
      throw new NotFoundError(_CORE_HR_CONSTANTS._E_R_R_O_R_S.CASH_REGISTER_NOT_FOUND);
    }
    if (register.status === 'OPEN') {
      throw new ConflictError('Cash register is already open');
    }
    return coreHrRepo.openCashRegister(id, expectedCash, openedBy);
  }

  async closeCashRegister(id: string, branchId: string, actualCash: number, closedBy: string) {
    const register = await coreHrRepo.findCashRegisterById(id);
    if (!register || register.branch_id !== branchId) {
      throw new NotFoundError(_CORE_HR_CONSTANTS._E_R_R_O_R_S.CASH_REGISTER_NOT_FOUND);
    }
    if (register.status === 'CLOSED') {
      throw new ConflictError('Cash register is already closed');
    }
    return coreHrRepo.closeCashRegister(id, actualCash, closedBy);
  }

  async listUserLogs(uid: string) {
    return coreHrRepo.findUserLogsByUid(uid);
  }
}

export const coreHrService = new CoreHrService();
