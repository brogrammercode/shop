import { LoyaltyTransType, ComplaintStatus } from '@prisma/client';
import prisma from '../../infra/database/client';

export class CrmRepo {
  async createCoupon(data: { branch_id: string; code: string; discount_pct: number; valid_until?: Date; min_order_val?: number; max_discount?: number; }) {
    return prisma.coupon.create({ data });
  }

  async findCouponsByBranch(branchId: string) {
    return prisma.coupon.findMany({ where: { branch_id: branchId }, orderBy: { created_at: 'desc' } });
  }

  async findCouponById(id: string) {
    return prisma.coupon.findUnique({ where: { id } });
  }

  async updateCoupon(id: string, data: Partial<{ status: any }>) {
    return prisma.coupon.update({ where: { id }, data });
  }

  async createLoyaltyTransaction(data: { uid: string; branch_id: string; trans_type: LoyaltyTransType; points: number; order_id?: string }) {
    return prisma.loyaltyTrans.create({ data });
  }

  async findLoyaltyTransactionsByCustomer(uid: string) {
    return prisma.loyaltyTrans.findMany({ where: { uid }, orderBy: { created_at: 'desc' } });
  }

  async getCustomerLoyaltyBalance(uid: string) {
    const transactions = await this.findLoyaltyTransactionsByCustomer(uid);
    return transactions.reduce((acc: number, curr: any) => (curr.trans_type === 'EARNED' || curr.trans_type === 'BONUS') ? acc + curr.points : acc - curr.points, 0);
  }

  async createComplaint(data: { uid: string; branch_id: string; order_id: string; subject: string; description: string; status: ComplaintStatus }) {
    return prisma.complaint.create({ data });
  }

  async findComplaintsByBranch(branchId: string) {
    return prisma.complaint.findMany({ where: { branch_id: branchId }, include: { user: true, order: true }, orderBy: { created_at: 'desc' } });
  }

  async findComplaintById(id: string) {
    return prisma.complaint.findUnique({ where: { id }, include: { user: true, order: true } });
  }

  async updateComplaintStatus(id: string, status: ComplaintStatus, resolved_by?: string, resolution_notes?: string) {
    return prisma.complaint.update({ where: { id }, data: { status, resolved_by, resolution_notes } });
  }
}

export const crmRepo = new CrmRepo();
