import { Router } from "express";
import { _CORE_HR_CONSTANTS } from "./core_hr.constant";
import * as coreHrController from "./core_hr.controller";

const router = Router();

// Public routes
router.post(_CORE_HR_CONSTANTS._R_O_U_T_E_S.SEND_OTP, coreHrController.sendOtp);
router.post(_CORE_HR_CONSTANTS._R_O_U_T_E_S._L_O_G_I_N, coreHrController.login);
router.post("/auth/refresh", coreHrController.refresh);

router.post("/auth/logout", coreHrController.logout);
router.get("/auth/sessions", coreHrController.getSessions);
router.delete("/auth/sessions/:id", coreHrController.terminateSession);
router.post("/auth/activity", coreHrController.logActivity);
router.get("/auth/activity", coreHrController.getActivities);

router.get(_CORE_HR_CONSTANTS._R_O_U_T_E_S._M_E, coreHrController.getMe);
router.post(
  _CORE_HR_CONSTANTS._R_O_U_T_E_S._B_R_A_N_C_H,
  coreHrController.createBranch,
);
router.get(
  _CORE_HR_CONSTANTS._R_O_U_T_E_S.BRANCH_SEARCH,
  coreHrController.searchBranches,
);
router.post(
  _CORE_HR_CONSTANTS._R_O_U_T_E_S.BRANCH_JOIN_REQUEST,
  coreHrController.createJoinRequest,
);
router.delete(
  `${_CORE_HR_CONSTANTS._R_O_U_T_E_S.BRANCH_JOIN_REQUEST}/:branch_id`,
  coreHrController.withdrawJoinRequest,
);

router.get(
  _CORE_HR_CONSTANTS._R_O_U_T_E_S.USER_LOGS,
  coreHrController.listUserLogs,
);

// Employee routes
// router.use(requireBranchEmployee);

router.get(
  _CORE_HR_CONSTANTS._R_O_U_T_E_S.BRANCH_JOIN_REQUESTS,
  coreHrController.listJoinRequests,
);
router.post(
  _CORE_HR_CONSTANTS._R_O_U_T_E_S.BRANCH_JOIN_REQUEST_APPROVE,
  coreHrController.approveJoinRequest,
);
router.post(
  _CORE_HR_CONSTANTS._R_O_U_T_E_S.BRANCH_JOIN_REQUEST_REJECT,
  coreHrController.rejectJoinRequest,
);

router.get(
  _CORE_HR_CONSTANTS._R_O_U_T_E_S._E_M_P_L_O_Y_E_E_S,
  coreHrController.listEmployees,
);
router.post(
  _CORE_HR_CONSTANTS._R_O_U_T_E_S._E_M_P_L_O_Y_E_E_S,
  coreHrController.createEmployee,
);
router.patch(
  _CORE_HR_CONSTANTS._R_O_U_T_E_S.EMPLOYEE_BY_ID,
  coreHrController.updateEmployee,
);
router.delete(
  _CORE_HR_CONSTANTS._R_O_U_T_E_S.EMPLOYEE_BY_ID,
  coreHrController.deleteEmployee,
);

router.get(
  _CORE_HR_CONSTANTS._R_O_U_T_E_S._D_E_P_A_R_T_M_E_N_T_S,
  coreHrController.listDepartments,
);
router.post(
  _CORE_HR_CONSTANTS._R_O_U_T_E_S._D_E_P_A_R_T_M_E_N_T_S,
  coreHrController.createDepartment,
);

router.get(
  _CORE_HR_CONSTANTS._R_O_U_T_E_S._R_O_L_E_S,
  coreHrController.listRoles,
);
router.post(
  _CORE_HR_CONSTANTS._R_O_U_T_E_S._R_O_L_E_S,
  coreHrController.createRole,
);

router.get(
  _CORE_HR_CONSTANTS._R_O_U_T_E_S._P_O_S_T_S,
  coreHrController.listPosts,
);
router.post(
  _CORE_HR_CONSTANTS._R_O_U_T_E_S._P_O_S_T_S,
  coreHrController.createPost,
);

router.get(
  _CORE_HR_CONSTANTS._R_O_U_T_E_S._S_H_I_F_T_S,
  coreHrController.listShifts,
);
router.post(
  _CORE_HR_CONSTANTS._R_O_U_T_E_S._S_H_I_F_T_S,
  coreHrController.createShift,
);

router.get(
  _CORE_HR_CONSTANTS._R_O_U_T_E_S.TIME_LOGS,
  coreHrController.listTimeLogs,
);
router.post(_CORE_HR_CONSTANTS._R_O_U_T_E_S.CLOCK_IN, coreHrController.clockIn);
router.patch(
  _CORE_HR_CONSTANTS._R_O_U_T_E_S.CLOCK_OUT,
  coreHrController.clockOut,
);

router.get(
  _CORE_HR_CONSTANTS._R_O_U_T_E_S.CASH_REGISTERS,
  coreHrController.listCashRegisters,
);
router.post(
  _CORE_HR_CONSTANTS._R_O_U_T_E_S.CASH_REGISTERS,
  coreHrController.createCashRegister,
);
router.patch(
  _CORE_HR_CONSTANTS._R_O_U_T_E_S.OPEN_CASH_REGISTER,
  coreHrController.openCashRegister,
);
router.patch(
  _CORE_HR_CONSTANTS._R_O_U_T_E_S.CLOSE_CASH_REGISTER,
  coreHrController.closeCashRegister,
);

export default router;
