import { crmRepo } from './crm.repo';
import { _CRM_CONSTANTS } from './crm.constant';
import { AppError, NotFoundError, BadRequestError } from '../../utils/error';
import { HttpStatus } from '../../constants/status';
import { LoyaltyTransType, ComplaintStatus } from '@prisma/client';

export class CrmService {
  async createCoupon(branchId: string, code: string, discount_type: any, discount_value: number, valid_from: string, valid_until: string, min_order_amount?: number, max_discount_amount?: number, usage_limit?: number) {
    return crmRepo.createCoupon({
      branch_id: branchId,
      code,
      discount_pct: discount_value,
      valid_until: new Date(valid_until),
      min_order_val: min_order_amount,
      max_discount: max_discount_amount,
    });
  }

  async listCoupons(branchId: string) {
    return crmRepo.findCouponsByBranch(branchId);
  }

  async getCouponById(id: string, branchId: string) {
    const coupon = await crmRepo.findCouponById(id);
    if (!coupon || coupon.branch_id !== branchId) {
      throw new NotFoundError(_CRM_CONSTANTS._E_R_R_O_R_S.COUPON_NOT_FOUND);
    }
    return coupon;
  }

  async updateCoupon(id: string, branchId: string, data: any) {
    await this.getCouponById(id, branchId);
    return crmRepo.updateCoupon(id, data);
  }

  async createLoyaltyTransaction(branchId: string, customer_id: string, trans_type: LoyaltyTransType, points: number, order_id?: string) {
    if (trans_type === 'REDEEMED') {
      const balance = await crmRepo.getCustomerLoyaltyBalance(customer_id);
      if (balance < points) {
        throw new BadRequestError(_CRM_CONSTANTS._E_R_R_O_R_S.INSUFFICIENT_LOYALTY);
      }
    }
    return crmRepo.createLoyaltyTransaction({ branch_id: branchId, uid: customer_id, trans_type, points, order_id });
  }

  async getLoyaltyByCustomer(customerId: string) {
    const transactions = await crmRepo.findLoyaltyTransactionsByCustomer(customerId);
    const balance = await crmRepo.getCustomerLoyaltyBalance(customerId);
    return { balance, transactions };
  }

  async createComplaint(branchId: string, customer_id: string, category: string, description: string, order_id?: string) {
    return crmRepo.createComplaint({ branch_id: branchId, uid: customer_id, subject: category, description, order_id: order_id!, status: 'OPEN' });
  }

  async listComplaints(branchId: string) {
    return crmRepo.findComplaintsByBranch(branchId);
  }

  async getComplaintById(id: string, branchId: string) {
    const complaint = await crmRepo.findComplaintById(id);
    if (!complaint || complaint.branch_id !== branchId) {
      throw new NotFoundError(_CRM_CONSTANTS._E_R_R_O_R_S.COMPLAINT_NOT_FOUND);
    }
    return complaint;
  }

  async updateComplaintStatus(id: string, branchId: string, status: ComplaintStatus, employeeId: string, resolution_notes?: string) {
    await this.getComplaintById(id, branchId);
    let resolvedBy = undefined;
    if (status === 'RESOLVED') {
      resolvedBy = employeeId;
    }
    return crmRepo.updateComplaintStatus(id, status, resolvedBy, resolution_notes);
  }
}

export const crmService = new CrmService();
