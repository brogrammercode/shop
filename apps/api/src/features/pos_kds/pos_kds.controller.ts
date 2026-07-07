import { Request, Response } from 'express';
import { asyncHandler } from '../../utils/async';
import { sendSuccess, BadRequestError } from '../../utils/error';
import { HttpStatus } from '../../constants/status';
import { posKdsService } from './pos_kds.service';
import { _POS_KDS_CONSTANTS } from './pos_kds.constant';

export const listOrders = asyncHandler(async (req: Request, res: Response) => {
  const result = await posKdsService.listOrders(req.employee.branch_id);
  return sendSuccess(res, result, _POS_KDS_CONSTANTS._M_E_S_S_A_G_E_S.ORDERS_LISTED, HttpStatus.OK);
});

export const createOrder = asyncHandler(async (req: Request, res: Response) => {
  const branchId = req.employee?.branch_id || req.body.branch_id;
  const result = await posKdsService.createOrder(branchId, {
    ...req.body,
    employee_id: req.employee?.id,
  });
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

export const deleteOrder = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await posKdsService.deleteOrder(id, req.employee.branch_id);
  return sendSuccess(res, result, 'Order deleted successfully', HttpStatus.OK);
});

export const listTableZones = asyncHandler(async (req: Request, res: Response) => {
  const result = await posKdsService.listTableZones(req.employee.branch_id);
  return sendSuccess(res, result, _POS_KDS_CONSTANTS._M_E_S_S_A_G_E_S.TABLE_ZONES_LISTED || 'Table zones listed', HttpStatus.OK);
});

export const createTableZone = asyncHandler(async (req: Request, res: Response) => {
  const { name } = req.body;
  const result = await posKdsService.createTableZone(req.employee.branch_id, name);
  return sendSuccess(res, result, _POS_KDS_CONSTANTS._M_E_S_S_A_G_E_S.TABLE_ZONE_CREATED || 'Table zone created', HttpStatus.CREATED);
});

export const getTableZoneById = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await posKdsService.getTableZoneById(id, req.employee.branch_id);
  return sendSuccess(res, result, _POS_KDS_CONSTANTS._M_E_S_S_A_G_E_S.TABLE_ZONES_LISTED || 'Table zone retrieved', HttpStatus.OK);
});

export const updateTableZone = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await posKdsService.updateTableZone(id, req.employee.branch_id, req.body);
  return sendSuccess(res, result, _POS_KDS_CONSTANTS._M_E_S_S_A_G_E_S.TABLE_ZONE_UPDATED || 'Table zone updated', HttpStatus.OK);
});

export const deleteTableZone = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await posKdsService.deleteTableZone(id, req.employee.branch_id);
  return sendSuccess(res, result, _POS_KDS_CONSTANTS._M_E_S_S_A_G_E_S.TABLE_ZONE_DELETED || 'Table zone deleted', HttpStatus.OK);
});

export const listTables = asyncHandler(async (req: Request, res: Response) => {
  const result = await posKdsService.listTables(req.employee.branch_id);
  return sendSuccess(res, result, _POS_KDS_CONSTANTS._M_E_S_S_A_G_E_S.TABLES_LISTED, HttpStatus.OK);
});

export const listPublicTables = asyncHandler(async (req: Request, res: Response) => {
  const branchId = req.query.branch_id as string;
  if (!branchId) {
    throw new BadRequestError(_POS_KDS_CONSTANTS._E_R_R_O_R_S.BRANCH_REQUIRED);
  }
  const result = await posKdsService.listTables(branchId);
  return sendSuccess(res, result, _POS_KDS_CONSTANTS._M_E_S_S_A_G_E_S.TABLES_LISTED, HttpStatus.OK);
});

export const createTable = asyncHandler(async (req: Request, res: Response) => {
  const { zone_id, table_number, capacity, side_count, side_labels } = req.body;
  const result = await posKdsService.createTable(req.employee.branch_id, zone_id, table_number, capacity, side_count, side_labels);
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

export const updateOrderStatus = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const { status } = req.body;
  const result = await posKdsService.updateOrderStatus(id, req.employee.branch_id, status);
  return sendSuccess(res, result, 'Order status updated successfully', HttpStatus.OK);
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

export const getCustomerByPhone = asyncHandler(async (req: Request, res: Response) => {
  const { phone } = req.params as Record<string, string>;
  const result = await posKdsService.getCustomerByPhone(phone);
  return sendSuccess(res, result, 'Customer retrieved successfully', HttpStatus.OK);
});
