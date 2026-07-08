import { JoinRequestStatus } from '@prisma/client';
import prisma from '../../infra/database/client';

export class CoreHrRepo {
  private async _logAction(tx: any, uid: string, action: string, title: string, description: string, meta: any, ref_link: string = '') {
    if (!uid) return;
    await tx.userLog.create({
      data: {
        uid,
        action,
        type: 'MUTATION',
        module: 'CORE_HR',
        title,
        description,
        meta,
        ref_link,
      }
    });
  }

  async findOrCreateUser(
    firebaseUid: string,
    name: string,
    phone: string,
    email: string | null,
    avatar: string | null,
  ) {
    let existing = await prisma.user.findUnique({ where: { id: firebaseUid } });
    if (existing) return existing;

    if (phone) {
      existing = await prisma.user.findUnique({ where: { phone } });
      if (existing) return existing;
    }

    if (email) {
      existing = await prisma.user.findUnique({ where: { email } });
      if (existing) return existing;
    }

    return prisma.$transaction(async (tx) => {
      const user = await tx.user.create({
        data: {
          id: firebaseUid,
          name,
          phone,
          email: email ?? undefined,
          avatar: avatar ?? undefined,
        },
      });
      await this._logAction(tx, user.id, 'CREATE_USER', 'User Signup', `Created user account for ${phone}`, { user_id: user.id }, `/user/${user.id}`);
      return user;
    });
  }

  async findUserByPhone(phone: string) {
    return prisma.user.findUnique({ where: { phone } });
  }

  async findUserById(id: string) {
    return prisma.user.findUnique({ where: { id } });
  }

  async findEmployeeByUid(uid: string) {
    return prisma.employee.findUnique({
      where: { uid },
      include: {
        branch: true,
        role_rel: true,
        department_rel: true,
        post_rel: true,
        shift_rel: true,
      },
    });
  }

  async createBranch(actorUid: string, data: { name: string; is_hq: boolean; addresses?: any[]; bank_details?: any[] }) {
    return prisma.$transaction(async (tx) => {
      const branch = await tx.branch.create({
        data: {
          name: data.name,
          is_hq: data.is_hq,
          created_by: actorUid,
          updated_by: actorUid,
        } as any
      });

      if (data.addresses && data.addresses.length > 0) {
        const addressesToCreate = data.addresses.map((addr: any) => ({
          ...addr,
          entity_type: 'BRANCH',
          entity_id: branch.id,
        }));
        await tx.address.createMany({ data: addressesToCreate });
      }

      if (data.bank_details && data.bank_details.length > 0) {
        const banksToCreate = data.bank_details.map((bank: any) => ({
          ...bank,
          entity_type: 'BRANCH',
          entity_id: branch.id,
        }));
        await tx.bankDetail.createMany({ data: banksToCreate });
      }

      await this._logAction(tx, actorUid, 'CREATE_BRANCH', 'Branch Created', `Created branch ${data.name}`, { branch_id: branch.id }, `/branch/${branch.id}`);
      return branch;
    }, {
      maxWait: 15000,
      timeout: 20000,
    });
  }

  async findBranchById(id: string) {
    return prisma.branch.findUnique({ where: { id } });
  }

  async searchBranches(query: string) {
    const branches = await prisma.branch.findMany({
      where: {
        OR: [
          { name: { contains: query, mode: 'insensitive' } },
          { code: { contains: query, mode: 'insensitive' } },
        ],
        is_deleted: false,
      },
      include: {
        _count: {
          select: { employees: true }
        }
      }
    });

    if (branches.length === 0) return [];

    const branchIds = branches.map(b => b.id);
    const addresses = await prisma.address.findMany({
      where: {
        entity_type: 'BRANCH',
        entity_id: { in: branchIds },
      }
    });

    const userIds = branches.map(b => b.created_by).filter(id => id) as string[];
    const users = await prisma.user.findMany({
      where: { id: { in: userIds } },
      select: { id: true, name: true, phone: true }
    });

    return branches.map(branch => {
      const owner = users.find(u => u.id === branch.created_by);
      return {
        ...branch,
        addresses: addresses.filter(a => a.entity_id === branch.id),
        employee_count: branch._count.employees,
        owner: owner ? { name: owner.name, phone: owner.phone } : null
      };
    });
  }

  async createRole(actorUid: string, branchId: string, name: string, permissions: string[]) {
    return prisma.$transaction(async (tx) => {
      const role = await tx.role.create({
        data: { branch_id: branchId, name, permissions },
      });
      await this._logAction(tx, actorUid, 'CREATE_ROLE', 'Role Created', `Created role ${name}`, { role_id: role.id }, `/role/${role.id}`);
      return role;
    });
  }

  async findRolesByBranch(branchId: string) {
    return prisma.role.findMany({
      where: { branch_id: branchId, is_deleted: false },
    });
  }

  async findRoleById(id: string) {
    return prisma.role.findUnique({ where: { id } });
  }

  async createEmployee(actorUid: string, branchId: string, uid: string, roleId: string) {
    return prisma.$transaction(async (tx) => {
      const emp = await tx.employee.create({
        data: { branch_id: branchId, uid, role: roleId },
      });
      await this._logAction(tx, actorUid, 'CREATE_EMPLOYEE', 'Employee Joined', `Employee added to branch`, { employee_id: emp.id }, `/employee/${emp.id}`);
      return emp;
    });
  }

  async findEmployeesByBranch(branchId: string) {
    return prisma.employee.findMany({
      where: { branch_id: branchId, is_deleted: false },
      include: {
        user: true,
        role_rel: true,
        department_rel: true,
        post_rel: true,
        shift_rel: true,
      },
    });
  }

  async findEmployeeById(id: string) {
    return prisma.employee.findUnique({
      where: { id },
      include: {
        user: true,
        role_rel: true,
        department_rel: true,
        post_rel: true,
        shift_rel: true,
      },
    });
  }

  async updateEmployee(actorUid: string, id: string, data: any) {
    return prisma.$transaction(async (tx) => {
      const emp = await tx.employee.update({ where: { id }, data });
      await this._logAction(tx, actorUid, 'UPDATE_EMPLOYEE', 'Employee Updated', `Employee profile updated`, { employee_id: emp.id, changes: data }, `/employee/${emp.id}`);
      return emp;
    });
  }

  async deleteEmployee(actorUid: string, id: string) {
    return prisma.$transaction(async (tx) => {
      const emp = await tx.employee.update({
        where: { id },
        data: { is_deleted: true },
      });
      await this._logAction(tx, actorUid, 'DELETE_EMPLOYEE', 'Employee Deleted', `Employee removed from branch`, { employee_id: emp.id }, `/employee/${emp.id}`);
      return emp;
    });
  }

  async createJoinRequest(actorUid: string, uid: string, branchId: string, message: string | undefined) {
    return prisma.$transaction(async (tx) => {
      const req = await tx.joinRequest.create({
        data: { uid, branch_id: branchId, message },
      });
      await this._logAction(tx, actorUid, 'CREATE_JOIN_REQUEST', 'Join Request Submitted', `Requested to join branch`, { request_id: req.id }, `/join-request/${req.id}`);
      return req;
    });
  }

  async findPendingJoinRequest(uid: string, branchId: string) {
    return prisma.joinRequest.findFirst({
      where: { uid, branch_id: branchId, status: 'PENDING' },
    });
  }

  async findPendingJoinRequestAnywhere(uid: string) {
    return prisma.joinRequest.findFirst({
      where: { uid, status: 'PENDING' },
    });
  }

  async deleteJoinRequest(actorUid: string, id: string) {
    return prisma.$transaction(async (tx) => {
      const req = await tx.joinRequest.delete({
        where: { id },
      });
      await this._logAction(tx, actorUid, 'WITHDRAW_JOIN_REQUEST', 'Join Request Withdrawn', `Withdrew join request to branch`, { request_id: id }, ``);
      return req;
    });
  }

  async findJoinRequestsByBranch(branchId: string) {
    const requests = await prisma.joinRequest.findMany({
      where: { branch_id: branchId, status: 'PENDING' },
      orderBy: { created_at: 'desc' },
    });
    
    if (requests.length === 0) return [];
    
    const uids = requests.map(r => r.uid);
    const users = await prisma.user.findMany({
      where: { id: { in: uids } },
      select: { id: true, name: true, phone: true }
    });
    
    return requests.map(req => {
      const user = users.find(u => u.id === req.uid);
      return {
        ...req,
        user: user ? { name: user.name, phone: user.phone } : null
      };
    });
  }

  async findJoinRequestById(id: string) {
    return prisma.joinRequest.findUnique({ where: { id } });
  }

  async updateJoinRequestStatus(actorUid: string, id: string, status: JoinRequestStatus, reviewedBy: string) {
    return prisma.$transaction(async (tx) => {
      const req = await tx.joinRequest.update({
        where: { id },
        data: { status, reviewed_by: reviewedBy },
      });
      await this._logAction(tx, actorUid, 'UPDATE_JOIN_REQUEST', `Join Request ${status}`, `Request was ${status.toLowerCase()}`, { request_id: req.id }, `/join-request/${req.id}`);
      return req;
    });
  }

  async createDepartment(actorUid: string, branchId: string, name: string, description: string | undefined) {
    return prisma.$transaction(async (tx) => {
      const dep = await tx.department.create({
        data: { branch_id: branchId, name, description },
      });
      await this._logAction(tx, actorUid, 'CREATE_DEPARTMENT', 'Department Created', `Created department ${name}`, { department_id: dep.id }, `/department/${dep.id}`);
      return dep;
    });
  }

  async findDepartmentsByBranch(branchId: string) {
    return prisma.department.findMany({
      where: { branch_id: branchId, is_deleted: false },
    });
  }

  async findDepartmentById(id: string) {
    return prisma.department.findUnique({ where: { id } });
  }

  async createPost(actorUid: string, branchId: string, departmentId: string, name: string, description: string | undefined) {
    return prisma.$transaction(async (tx) => {
      const post = await tx.post.create({
        data: { branch_id: branchId, department_id: departmentId, name, description },
      });
      await this._logAction(tx, actorUid, 'CREATE_POST', 'Post Created', `Created post ${name}`, { post_id: post.id }, `/post/${post.id}`);
      return post;
    });
  }

  async findPostsByBranch(branchId: string) {
    return prisma.post.findMany({
      where: { branch_id: branchId, is_deleted: false },
      include: { department: true },
    });
  }

  async createShift(actorUid: string, branchId: string, name: string, startTime: string, endTime: string) {
    return prisma.$transaction(async (tx) => {
      const shift = await tx.shift.create({
        data: { branch_id: branchId, name, start_time: startTime, end_time: endTime },
      });
      await this._logAction(tx, actorUid, 'CREATE_SHIFT', 'Shift Created', `Created shift ${name}`, { shift_id: shift.id }, `/shift/${shift.id}`);
      return shift;
    });
  }

  async findShiftsByBranch(branchId: string) {
    return prisma.shift.findMany({
      where: { branch_id: branchId, is_deleted: false },
    });
  }

  async createAddress(data: { entity_type: any; entity_id: string; area: string; locality?: string; city?: string; state?: string; pin_code?: string; country?: string }) {
    return prisma.address.create({ data });
  }

  async createTimeLog(actorUid: string, branchId: string, employeeId: string, clockIn: Date) {
    return prisma.$transaction(async (tx) => {
      const log = await tx.timeLog.create({
        data: { branch_id: branchId, employee_id: employeeId, clock_in: clockIn },
      });
      await this._logAction(tx, actorUid, 'CREATE_TIMELOG', 'Clock In', `Employee clocked in`, { timelog_id: log.id }, `/timelog/${log.id}`);
      return log;
    });
  }

  async findOpenTimeLog(employeeId: string) {
    return prisma.timeLog.findFirst({
      where: { employee_id: employeeId, clock_out: null },
    });
  }

  async closeTimeLog(actorUid: string, id: string, clockOut: Date, totalHours: number) {
    return prisma.$transaction(async (tx) => {
      const log = await tx.timeLog.update({
        where: { id },
        data: { clock_out: clockOut, total_hours: totalHours },
      });
      await this._logAction(tx, actorUid, 'CLOSE_TIMELOG', 'Clock Out', `Employee clocked out`, { timelog_id: log.id, hours: totalHours }, `/timelog/${log.id}`);
      return log;
    });
  }

  async findTimeLogById(id: string) {
    return prisma.timeLog.findUnique({ where: { id } });
  }

  async findTimeLogsByBranch(branchId: string) {
    return prisma.timeLog.findMany({
      where: { branch_id: branchId },
      orderBy: { clock_in: 'desc' },
      include: { employee: true },
    });
  }

  async createCashRegister(actorUid: string, branchId: string, registerName: string, macAddress: string | undefined) {
    return prisma.$transaction(async (tx) => {
      const reg = await tx.cashRegister.create({
        data: { branch_id: branchId, register_name: registerName, mac_address: macAddress },
      });
      await this._logAction(tx, actorUid, 'CREATE_CASH_REGISTER', 'Register Created', `Created cash register ${registerName}`, { register_id: reg.id }, `/cash-register/${reg.id}`);
      return reg;
    });
  }

  async findCashRegistersByBranch(branchId: string) {
    return prisma.cashRegister.findMany({
      where: { branch_id: branchId },
    });
  }

  async findCashRegisterById(id: string) {
    return prisma.cashRegister.findUnique({ where: { id } });
  }

  async openCashRegister(actorUid: string, id: string, expectedCash: number, openedBy: string) {
    return prisma.$transaction(async (tx) => {
      const reg = await tx.cashRegister.update({
        where: { id },
        data: { expected_cash: expectedCash, opened_by: openedBy, status: 'OPEN' },
      });
      await this._logAction(tx, actorUid, 'OPEN_REGISTER', 'Register Opened', `Register was opened`, { register_id: reg.id, cash: expectedCash }, `/cash-register/${reg.id}`);
      return reg;
    });
  }

  async closeCashRegister(actorUid: string, id: string, actualCash: number, closedBy: string) {
    return prisma.$transaction(async (tx) => {
      const reg = await tx.cashRegister.update({
        where: { id },
        data: { actual_cash: actualCash, closed_by: closedBy, status: 'CLOSED' },
      });
      await this._logAction(tx, actorUid, 'CLOSE_REGISTER', 'Register Closed', `Register was closed`, { register_id: reg.id, cash: actualCash }, `/cash-register/${reg.id}`);
      return reg;
    });
  }

  async findUserLogsByUid(uid: string) {
    return prisma.userLog.findMany({
      where: { uid },
      orderBy: { created_at: 'desc' },
    });
  }

  async createUserLog(data: any) {
    if (!data.ref_link) data.ref_link = `/user/${data.uid || ''}`;
    return prisma.userLog.create({ data });
  }

  // --- OTP Methods ---
  async createOtp(actorUid: string, data: { actor: string; otp: string; type: any; valid_till: Date }) {
    return prisma.$transaction(async (tx) => {
      const otp = await tx.userOtp.create({ data });
      await this._logAction(tx, actorUid, 'CREATE_OTP', 'OTP Generated', `Generated new OTP`, { type: data.type }, `/otp/${otp.id}`);
      return otp;
    });
  }

  async findValidOtp(actor: string, otp: string, type: any) {
    return prisma.userOtp.findFirst({
      where: {
        actor,
        otp,
        type,
        valid_till: { gt: new Date() },
      },
    });
  }

  async findLatestOtpByActor(actor: string, type: any) {
    return prisma.userOtp.findFirst({
      where: { actor, type },
      orderBy: { created_at: 'desc' },
    });
  }

  async deleteOtpsByActor(actorUid: string, actor: string, type: any) {
    return prisma.$transaction(async (tx) => {
      const del = await tx.userOtp.deleteMany({ where: { actor, type } });
      await this._logAction(tx, actorUid, 'DELETE_OTPS', 'OTPs Cleared', `Cleared previous OTPs`, { type }, `/user/${actorUid}`);
      return del;
    });
  }

  // --- Session Methods ---
  async createSession(actorUid: string, data: any) {
    return prisma.$transaction(async (tx) => {
      const session = await tx.userSession.create({ data });
      await this._logAction(tx, actorUid, 'CREATE_SESSION', 'Login Session Created', `User logged in`, { session_id: session.id }, `/session/${session.id}`);
      return session;
    });
  }

  async findSessionsByUserId(uid: string) {
    return prisma.userSession.findMany({
      where: { uid },
      orderBy: { created_at: 'desc' },
    });
  }

  async findSessionByRefreshToken(refreshToken: string) {
    return prisma.userSession.findUnique({
      where: { refresh_token: refreshToken },
      include: { user: true },
    });
  }

  async deleteSession(actorUid: string, id: string) {
    return prisma.$transaction(async (tx) => {
      const del = await tx.userSession.delete({ where: { id } });
      await this._logAction(tx, actorUid, 'DELETE_SESSION', 'Session Terminated', `User logged out`, { session_id: id }, `/session/${id}`);
      return del;
    });
  }
}

export const coreHrRepo = new CoreHrRepo();
