import { Request, Response } from "express";
import { asyncHandler } from "../../utils/async";
import { BadRequestError, sendSuccess } from "../../utils/error";
import { HttpStatus } from "../../constants/status";
import { _NOTIFICATION_CONSTANTS } from "./notification.constant";
import { notificationService } from "./notification.service";

export const listNotifications = asyncHandler(
  async (req: Request, res: Response) => {
    const result = await notificationService.list(
      req.user!.uid,
      req.employee.branch_id,
    );
    return sendSuccess(
      res,
      result,
      _NOTIFICATION_CONSTANTS._M_E_S_S_A_G_E_S.LISTED,
      HttpStatus.OK,
    );
  },
);

export const markNotificationRead = asyncHandler(
  async (req: Request, res: Response) => {
    const { id } = req.params as Record<string, string>;
    const result = await notificationService.markRead(id);
    return sendSuccess(
      res,
      result,
      _NOTIFICATION_CONSTANTS._M_E_S_S_A_G_E_S.READ,
      HttpStatus.OK,
    );
  },
);

export const markAllNotificationsRead = asyncHandler(
  async (req: Request, res: Response) => {
    const result = await notificationService.markAllRead(
      req.user!.uid,
      req.employee.branch_id,
    );
    return sendSuccess(
      res,
      result,
      _NOTIFICATION_CONSTANTS._M_E_S_S_A_G_E_S.READ_ALL,
      HttpStatus.OK,
    );
  },
);

export const saveDeviceToken = asyncHandler(
  async (req: Request, res: Response) => {
    const { token, platform } = req.body;
    if (!token) {
      throw new BadRequestError(
        _NOTIFICATION_CONSTANTS._E_R_R_O_R_S.DEVICE_TOKEN_REQUIRED,
      );
    }
    const result = await notificationService.saveDeviceToken(
      req.user!.uid,
      token,
      platform,
    );
    return sendSuccess(
      res,
      result,
      _NOTIFICATION_CONSTANTS._M_E_S_S_A_G_E_S.DEVICE_TOKEN_SAVED,
      HttpStatus.OK,
    );
  },
);
