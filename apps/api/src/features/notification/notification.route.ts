import { Router } from "express";
import {
  authenticate,
  requireBranchEmployee,
} from "../core_hr/core_hr.middleware";
import { _NOTIFICATION_CONSTANTS } from "./notification.constant";
import * as notificationController from "./notification.controller";

const router = Router();

router.use(authenticate, requireBranchEmployee);

router.get(
  _NOTIFICATION_CONSTANTS._R_O_U_T_E_S._L_I_S_T,
  notificationController.listNotifications,
);
router.post(
  _NOTIFICATION_CONSTANTS._R_O_U_T_E_S._D_E_V_I_C_E_T_O_K_E_N,
  notificationController.saveDeviceToken,
);
router.patch(
  _NOTIFICATION_CONSTANTS._R_O_U_T_E_S._R_E_A_D_A_L_L,
  notificationController.markAllNotificationsRead,
);
router.patch(
  _NOTIFICATION_CONSTANTS._R_O_U_T_E_S._R_E_A_D,
  notificationController.markNotificationRead,
);

export default router;
