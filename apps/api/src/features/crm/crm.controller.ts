import { Request, Response } from 'express';
import { asyncHandler } from '../../utils/async';
import { sendSuccess } from '../../utils/error';
import { HttpStatus } from '../../constants/status';
import { crmService } from './crm.service';
import { _CRM_CONSTANTS } from './crm.constant';

export const listCoupons = asyncHandler(async (req: Request, res: Response) => {
  const result = await crmService.listCoupons(req.employee.branch_id);
  return sendSuccess(res, result, _CRM_CONSTANTS._M_E_S_S_A_G_E_S.COUPONS_LISTED, HttpStatus.OK);
});

export const createCoupon = asyncHandler(async (req: Request, res: Response) => {
  const { code, discount_type, discount_value, valid_from, valid_until, min_order_amount, max_discount_amount, usage_limit } = req.body;
  const result = await crmService.createCoupon(req.employee.branch_id, code, discount_type, discount_value, valid_from, valid_until, min_order_amount, max_discount_amount, usage_limit);
  return sendSuccess(res, result, _CRM_CONSTANTS._M_E_S_S_A_G_E_S.COUPON_CREATED, HttpStatus.CREATED);
});

export const getCouponById = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await crmService.getCouponById(id, req.employee.branch_id);
  return sendSuccess(res, result, _CRM_CONSTANTS._M_E_S_S_A_G_E_S.COUPONS_LISTED, HttpStatus.OK);
});

export const updateCoupon = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await crmService.updateCoupon(id, req.employee.branch_id, req.body);
  return sendSuccess(res, result, _CRM_CONSTANTS._M_E_S_S_A_G_E_S.COUPON_UPDATED, HttpStatus.OK);
});

export const createLoyaltyTransaction = asyncHandler(async (req: Request, res: Response) => {
  const { customer_id, transaction_type, points, order_id } = req.body;
  const result = await crmService.createLoyaltyTransaction(req.employee.branch_id, customer_id, transaction_type, points, order_id);
  return sendSuccess(res, result, _CRM_CONSTANTS._M_E_S_S_A_G_E_S.LOYALTY_CREATED, HttpStatus.CREATED);
});

export const getLoyaltyByCustomer = asyncHandler(async (req: Request, res: Response) => {
  const { customerId } = req.params as Record<string, string>;
  const result = await crmService.getLoyaltyByCustomer(customerId);
  return sendSuccess(res, result, _CRM_CONSTANTS._M_E_S_S_A_G_E_S.LOYALTY_LISTED, HttpStatus.OK);
});

export const listComplaints = asyncHandler(async (req: Request, res: Response) => {
  const result = await crmService.listComplaints(req.employee.branch_id);
  return sendSuccess(res, result, _CRM_CONSTANTS._M_E_S_S_A_G_E_S.COMPLAINTS_LISTED, HttpStatus.OK);
});

export const createComplaint = asyncHandler(async (req: Request, res: Response) => {
  const { customer_id, category, description, order_id } = req.body;
  const result = await crmService.createComplaint(req.employee.branch_id, customer_id, category, description, order_id);
  return sendSuccess(res, result, _CRM_CONSTANTS._M_E_S_S_A_G_E_S.COMPLAINT_CREATED, HttpStatus.CREATED);
});

export const getComplaintById = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await crmService.getComplaintById(id, req.employee.branch_id);
  return sendSuccess(res, result, _CRM_CONSTANTS._M_E_S_S_A_G_E_S.COMPLAINTS_LISTED, HttpStatus.OK);
});

export const updateComplaintStatus = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const { status, resolution_notes } = req.body;
  const result = await crmService.updateComplaintStatus(id, req.employee.branch_id, status, req.employee.id, resolution_notes);
  return sendSuccess(res, result, _CRM_CONSTANTS._M_E_S_S_A_G_E_S.COMPLAINT_UPDATED, HttpStatus.OK);
});
