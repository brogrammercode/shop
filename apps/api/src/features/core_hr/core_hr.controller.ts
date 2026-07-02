import { Request, Response } from 'express';
import { asyncHandler } from '../../utils/async';
import { sendSuccess } from '../../utils/error';
import { HttpStatus } from '../../constants/status';
import { coreHrService } from './core_hr.service';
import { _CORE_HR_CONSTANTS } from './core_hr.constant';

export const sendOtp = asyncHandler(async (req: Request, res: Response) => {
  const { phone_number } = req.body;
  await coreHrService.sendOtp(phone_number);
  return sendSuccess(res, null, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.OTP_SENT, HttpStatus.OK);
});

export const login = asyncHandler(async (req: Request, res: Response) => {
  const { idToken, phone_number, otp } = req.body;
  const ipAddress = req.ip || req.connection.remoteAddress;
  const deviceInfo = req.headers['user-agent'];
  const result = await coreHrService.login(idToken, phone_number, otp, ipAddress, deviceInfo);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.LOGIN_SUCCESS, HttpStatus.OK);
});

export const refresh = asyncHandler(async (req: Request, res: Response) => {
  const { refreshToken } = req.body;
  const result = await coreHrService.refreshAccessToken(refreshToken);
  return sendSuccess(res, result, 'Token refreshed successfully', HttpStatus.OK);
});

export const logout = asyncHandler(async (req: Request, res: Response) => {
  const { sessionId } = req.body;
  if (sessionId) {
    await coreHrService.logout(sessionId);
  }
  return sendSuccess(res, null, 'Logged out successfully', HttpStatus.OK);
});

export const getSessions = asyncHandler(async (req: Request, res: Response) => {
  const result = await coreHrService.getSessions(req.user!.uid);
  return sendSuccess(res, result, 'Sessions fetched successfully', HttpStatus.OK);
});

export const terminateSession = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await coreHrService.terminateSession(id);
  return sendSuccess(res, result, 'Session terminated successfully', HttpStatus.OK);
});

export const logActivity = asyncHandler(async (req: Request, res: Response) => {
  const uid = req.user!.uid;
  const result = await coreHrService.logActivity({
    ...req.body,
    uid,
  });
  return sendSuccess(res, result, 'Activity logged successfully', HttpStatus.CREATED);
});

export const getActivities = asyncHandler(async (req: Request, res: Response) => {
  const result = await coreHrService.getActivities(req.user!.uid);
  return sendSuccess(res, result, 'Activities fetched successfully', HttpStatus.OK);
});

export const getMe = asyncHandler(async (req: Request, res: Response) => {
  const uid = req.user!.uid;
  const result = await coreHrService.getMe(uid);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.GET_ME_SUCCESS, HttpStatus.OK);
});

export const createBranch = asyncHandler(async (req: Request, res: Response) => {
  const { name, code, is_hq } = req.body;
  const result = await coreHrService.createBranch(req.user!.uid, name, code, is_hq);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.BRANCH_CREATED, HttpStatus.CREATED);
});

export const searchBranches = asyncHandler(async (req: Request, res: Response) => {
  const query = req.query.q as string || '';
  const result = await coreHrService.searchBranches(query);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.BRANCHES_FOUND, HttpStatus.OK);
});

export const createJoinRequest = asyncHandler(async (req: Request, res: Response) => {
  const { branch_id, message } = req.body;
  const result = await coreHrService.createJoinRequest(req.user!.uid, branch_id, message);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.JOIN_REQUEST_CREATED, HttpStatus.CREATED);
});

export const listJoinRequests = asyncHandler(async (req: Request, res: Response) => {
  const result = await coreHrService.listJoinRequests(req.employee.branch_id);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.JOIN_REQUESTS_LISTED, HttpStatus.OK);
});

export const approveJoinRequest = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await coreHrService.approveJoinRequest(id, req.employee.branch_id, req.user!.uid);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.JOIN_REQUEST_APPROVED, HttpStatus.OK);
});

export const rejectJoinRequest = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await coreHrService.rejectJoinRequest(id, req.employee.branch_id, req.user!.uid);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.JOIN_REQUEST_REJECTED, HttpStatus.OK);
});

export const listEmployees = asyncHandler(async (req: Request, res: Response) => {
  const result = await coreHrService.listEmployees(req.employee.branch_id);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.EMPLOYEES_LISTED, HttpStatus.OK);
});

export const createEmployee = asyncHandler(async (req: Request, res: Response) => {
  const { uid, role_id } = req.body;
  const result = await coreHrService.createEmployee(req.employee.branch_id, uid, role_id);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.EMPLOYEE_CREATED, HttpStatus.CREATED);
});

export const updateEmployee = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await coreHrService.updateEmployee(id, req.employee.branch_id, req.body);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.EMPLOYEE_UPDATED, HttpStatus.OK);
});

export const deleteEmployee = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await coreHrService.deleteEmployee(id, req.employee.branch_id);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.EMPLOYEE_DELETED, HttpStatus.OK);
});

export const listDepartments = asyncHandler(async (req: Request, res: Response) => {
  const result = await coreHrService.listDepartments(req.employee.branch_id);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.DEPARTMENTS_LISTED, HttpStatus.OK);
});

export const createDepartment = asyncHandler(async (req: Request, res: Response) => {
  const { name, description } = req.body;
  const result = await coreHrService.createDepartment(req.employee.branch_id, name, description);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.DEPARTMENT_CREATED, HttpStatus.CREATED);
});

export const listRoles = asyncHandler(async (req: Request, res: Response) => {
  const result = await coreHrService.listRoles(req.employee.branch_id);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.ROLES_LISTED, HttpStatus.OK);
});

export const createRole = asyncHandler(async (req: Request, res: Response) => {
  const { name, permissions } = req.body;
  const result = await coreHrService.createRole(req.employee.branch_id, name, permissions);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.ROLE_CREATED, HttpStatus.CREATED);
});

export const listPosts = asyncHandler(async (req: Request, res: Response) => {
  const result = await coreHrService.listPosts(req.employee.branch_id);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.POSTS_LISTED, HttpStatus.OK);
});

export const createPost = asyncHandler(async (req: Request, res: Response) => {
  const { department_id, name, description } = req.body;
  const result = await coreHrService.createPost(req.employee.branch_id, department_id, name, description);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.POST_CREATED, HttpStatus.CREATED);
});

export const listShifts = asyncHandler(async (req: Request, res: Response) => {
  const result = await coreHrService.listShifts(req.employee.branch_id);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.SHIFTS_LISTED, HttpStatus.OK);
});

export const createShift = asyncHandler(async (req: Request, res: Response) => {
  const { name, start_time, end_time } = req.body;
  const result = await coreHrService.createShift(req.employee.branch_id, name, start_time, end_time);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.SHIFT_CREATED, HttpStatus.CREATED);
});

export const listTimeLogs = asyncHandler(async (req: Request, res: Response) => {
  const result = await coreHrService.listTimeLogs(req.employee.branch_id);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.TIME_LOGS_LISTED, HttpStatus.OK);
});

export const clockIn = asyncHandler(async (req: Request, res: Response) => {
  const result = await coreHrService.clockIn(req.employee.branch_id, req.employee.id);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.CLOCKED_IN, HttpStatus.CREATED);
});

export const clockOut = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await coreHrService.clockOut(id, req.employee.id);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.CLOCKED_OUT, HttpStatus.OK);
});

export const listCashRegisters = asyncHandler(async (req: Request, res: Response) => {
  const result = await coreHrService.listCashRegisters(req.employee.branch_id);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.CASH_REGISTERS_LISTED, HttpStatus.OK);
});

export const createCashRegister = asyncHandler(async (req: Request, res: Response) => {
  const { register_name, mac_address } = req.body;
  const result = await coreHrService.createCashRegister(req.employee.branch_id, register_name, mac_address);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.CASH_REGISTER_CREATED, HttpStatus.CREATED);
});

export const openCashRegister = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const { expected_cash } = req.body;
  const result = await coreHrService.openCashRegister(id, req.employee.branch_id, expected_cash, req.employee.id);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.CASH_REGISTER_OPENED, HttpStatus.OK);
});

export const closeCashRegister = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const { actual_cash } = req.body;
  const result = await coreHrService.closeCashRegister(id, req.employee.branch_id, actual_cash, req.employee.id);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.CASH_REGISTER_CLOSED, HttpStatus.OK);
});

export const listUserLogs = asyncHandler(async (req: Request, res: Response) => {
  const result = await coreHrService.listUserLogs(req.user!.uid);
  return sendSuccess(res, result, _CORE_HR_CONSTANTS._M_E_S_S_A_G_E_S.USER_LOGS_LISTED, HttpStatus.OK);
});
