import { Request, Response } from 'express';
import { asyncHandler } from '../../utils/async';
import { sendSuccess } from '../../utils/error';
import { HttpStatus } from '../../constants/status';
import { posKdsService } from './pos_kds.service';
import { _POS_KDS_CONSTANTS } from './pos_kds.constant';

export const listOrders = asyncHandler(async (req: Request, res: Response) => {
  const result = await posKdsService.listOrders(req.employee.branch_id);
  return sendSuccess(res, result, _POS_KDS_CONSTANTS._M_E_S_S_A_G_E_S.ORDERS_LISTED, HttpStatus.OK);
});

export const createOrder = asyncHandler(async (req: Request, res: Response) => {
  const result = await posKdsService.createOrder(req.employee.branch_id, req.body);
  return sendSuccess(res, result, _POS_KDS_CONSTANTS._M_E_S_S_A_G_E_S.ORDER_CREATED, HttpStatus.CREATED);
});

export const getOrderById = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await posKdsService.getOrderById(id, req.employee.branch_id);
  return sendSuccess(res, result, _POS_KDS_CONSTANTS._M_E_S_S_A_G_E_S.ORDERS_LISTED, HttpStatus.OK);
});

export const payOrder = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const { payment_method, amount } = req.body;
  const result = await posKdsService.payOrder(id, req.employee.branch_id, payment_method, amount);
  return sendSuccess(res, result, _POS_KDS_CONSTANTS._M_E_S_S_A_G_E_S.ORDER_PAID, HttpStatus.OK);
});

export const refundOrder = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await posKdsService.refundOrder(id, req.employee.branch_id);
  return sendSuccess(res, result, _POS_KDS_CONSTANTS._M_E_S_S_A_G_E_S.ORDER_REFUNDED, HttpStatus.OK);
});

export const cancelOrder = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await posKdsService.cancelOrder(id, req.employee.branch_id);
  return sendSuccess(res, result, _POS_KDS_CONSTANTS._M_E_S_S_A_G_E_S.ORDER_CANCELLED, HttpStatus.OK);
});

export const listTables = asyncHandler(async (req: Request, res: Response) => {
  const result = await posKdsService.listTables(req.employee.branch_id);
  return sendSuccess(res, result, _POS_KDS_CONSTANTS._M_E_S_S_A_G_E_S.TABLES_LISTED, HttpStatus.OK);
});

export const createTable = asyncHandler(async (req: Request, res: Response) => {
  const { name, capacity, location } = req.body;
  const result = await posKdsService.createTable(req.employee.branch_id, name, capacity, location);
  return sendSuccess(res, result, _POS_KDS_CONSTANTS._M_E_S_S_A_G_E_S.TABLE_CREATED, HttpStatus.CREATED);
});

export const getTableById = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await posKdsService.getTableById(id, req.employee.branch_id);
  return sendSuccess(res, result, _POS_KDS_CONSTANTS._M_E_S_S_A_G_E_S.TABLES_LISTED, HttpStatus.OK);
});

export const updateTable = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await posKdsService.updateTable(id, req.employee.branch_id, req.body);
  return sendSuccess(res, result, _POS_KDS_CONSTANTS._M_E_S_S_A_G_E_S.TABLE_UPDATED, HttpStatus.OK);
});

export const deleteTable = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await posKdsService.deleteTable(id, req.employee.branch_id);
  return sendSuccess(res, result, _POS_KDS_CONSTANTS._M_E_S_S_A_G_E_S.TABLE_DELETED, HttpStatus.OK);
});

export const listKOTs = asyncHandler(async (req: Request, res: Response) => {
  const result = await posKdsService.listKOTs(req.employee.branch_id);
  return sendSuccess(res, result, _POS_KDS_CONSTANTS._M_E_S_S_A_G_E_S.KOTS_LISTED, HttpStatus.OK);
});

export const getKOTById = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await posKdsService.getKOTById(id, req.employee.branch_id);
  return sendSuccess(res, result, _POS_KDS_CONSTANTS._M_E_S_S_A_G_E_S.KOTS_LISTED, HttpStatus.OK);
});

export const updateKOTStatus = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const { status } = req.body;
  const result = await posKdsService.updateKOTStatus(id, req.employee.branch_id, status);
  return sendSuccess(res, result, _POS_KDS_CONSTANTS._M_E_S_S_A_G_E_S.KOT_STATUS_UPDATED, HttpStatus.OK);
});

export const listPayments = asyncHandler(async (req: Request, res: Response) => {
  const result = await posKdsService.listPayments(req.employee.branch_id);
  return sendSuccess(res, result, _POS_KDS_CONSTANTS._M_E_S_S_A_G_E_S.PAYMENTS_LISTED, HttpStatus.OK);
});

export const getPaymentById = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await posKdsService.getPaymentById(id, req.employee.branch_id);
  return sendSuccess(res, result, _POS_KDS_CONSTANTS._M_E_S_S_A_G_E_S.PAYMENTS_LISTED, HttpStatus.OK);
});
