import { Request, Response } from 'express';
import { HttpStatus } from '../../constants/status';
import { asyncHandler } from '../../utils/async';
import { BadRequestError, sendSuccess } from '../../utils/error';
import { _LADYLUCK_CONSTANTS } from './ladyluck.constant';
import { ladyluckService } from './ladyluck.service';

export const getSummary = asyncHandler(async (req: Request, res: Response) => {
  const branchId = String(req.query[_LADYLUCK_CONSTANTS._Q_U_E_R_Y.BRANCH_ID] || req.body?.[_LADYLUCK_CONSTANTS._B_O_D_Y.BRANCH_ID] || '').trim();
  const uid = req.user?.uid;

  if (!branchId) {
    throw new BadRequestError(_LADYLUCK_CONSTANTS._E_R_R_O_R_S.BRANCH_REQUIRED);
  }

  if (!uid) {
    throw new BadRequestError(_LADYLUCK_CONSTANTS._E_R_R_O_R_S.ORDER_NOT_REWARDABLE);
  }

  const result = await ladyluckService.getSummary(uid, branchId);
  return sendSuccess(res, result, _LADYLUCK_CONSTANTS._M_E_S_S_A_G_E_S.SUMMARY_FETCHED, HttpStatus.OK);
});

export const scratchCard = asyncHandler(async (req: Request, res: Response) => {
  const branchId = String(req.body?.[_LADYLUCK_CONSTANTS._B_O_D_Y.BRANCH_ID] || req.query[_LADYLUCK_CONSTANTS._Q_U_E_R_Y.BRANCH_ID] || '').trim();
  const uid = req.user?.uid;

  if (!branchId) {
    throw new BadRequestError(_LADYLUCK_CONSTANTS._E_R_R_O_R_S.BRANCH_REQUIRED);
  }

  if (!uid) {
    throw new BadRequestError(_LADYLUCK_CONSTANTS._E_R_R_O_R_S.ORDER_NOT_REWARDABLE);
  }

  const result = await ladyluckService.scratchCard(uid, branchId, String(req.params.id));
  return sendSuccess(res, result, _LADYLUCK_CONSTANTS._M_E_S_S_A_G_E_S.CARD_SCRATCHED, HttpStatus.OK);
});

export const getCustomerSummary = asyncHandler(async (req: Request, res: Response) => {
  const branchId = req.employee?.branch_id?.toString() || '';
  const uid = String(req.params.uid || '').trim();

  if (!branchId) {
    throw new BadRequestError(_LADYLUCK_CONSTANTS._E_R_R_O_R_S.BRANCH_REQUIRED);
  }

  if (!uid) {
    throw new BadRequestError(_LADYLUCK_CONSTANTS._E_R_R_O_R_S.ORDER_NOT_REWARDABLE);
  }

  const result = await ladyluckService.getSummary(uid, branchId);
  return sendSuccess(res, result, _LADYLUCK_CONSTANTS._M_E_S_S_A_G_E_S.SUMMARY_FETCHED, HttpStatus.OK);
});

export const scratchCustomerCard = asyncHandler(async (req: Request, res: Response) => {
  const branchId = req.employee?.branch_id?.toString() || '';
  const uid = String(req.params.uid || '').trim();

  if (!branchId) {
    throw new BadRequestError(_LADYLUCK_CONSTANTS._E_R_R_O_R_S.BRANCH_REQUIRED);
  }

  if (!uid) {
    throw new BadRequestError(_LADYLUCK_CONSTANTS._E_R_R_O_R_S.ORDER_NOT_REWARDABLE);
  }

  const result = await ladyluckService.scratchCard(uid, branchId, String(req.params.id));
  return sendSuccess(res, result, _LADYLUCK_CONSTANTS._M_E_S_S_A_G_E_S.CARD_SCRATCHED, HttpStatus.OK);
});
