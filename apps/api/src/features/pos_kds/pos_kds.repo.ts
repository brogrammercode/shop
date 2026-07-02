import { OrderStatus, KOTStatus, OrderType, PayMethod } from '@prisma/client';
import prisma from '../../infra/database/client';

export class PosKdsRepo {
  async createOrder(data: { branch_id: string; customer_id?: string; order_type: OrderType; table_id?: string; total_amount: number; subtotal: number; tax_amount: number; discount_amount: number }) {
    return prisma.order.create({ data });
  }

  async findOrdersByBranch(branchId: string) {
    return prisma.order.findMany({ where: { branch_id: branchId }, include: { customer: true, table: true }, orderBy: { created_at: 'desc' } });
  }

  async findOrderById(id: string) {
    return prisma.order.findUnique({ where: { id }, include: { customer: true, table: true, items: true, kots: true, payments: true } });
  }

  async updateOrderStatus(id: string, status: OrderStatus) {
    return prisma.order.update({ where: { id }, data: { status } });
  }

  async createOrderItem(data: { branch_id: string; order_id: string; menu_item_id: string; qty: number; unit_price: number; total_price: number; notes?: string }) {
    return prisma.orderItem.create({ data });
  }

  async createOrderItems(items: { branch_id: string; order_id: string; menu_item_id: string; qty: number; unit_price: number; total_price: number; notes?: string }[]) {
    return prisma.orderItem.createMany({ data: items });
  }

  async createTable(data: { branch_id: string; zone_id: string; table_number: string; capacity: number }) {
    return prisma.table.create({ data });
  }

  async findTablesByBranch(branchId: string) {
    return prisma.table.findMany({ where: { branch_id: branchId, is_deleted: false } });
  }

  async findTableById(id: string) {
    return prisma.table.findUnique({ where: { id } });
  }

  async updateTable(id: string, data: Partial<{ name: string; capacity: number; location: string; status: any }>) {
    return prisma.table.update({ where: { id }, data });
  }

  async deleteTable(id: string) {
    return prisma.table.update({ where: { id }, data: { is_deleted: true } });
  }

  async createKOT(data: { branch_id: string; order_id: string; station: any; status: KOTStatus; print_count?: number }) {
    return prisma.kitchenOrderTicket.create({ data });
  }

  async findKOTsByBranch(branchId: string) {
    return prisma.kitchenOrderTicket.findMany({ where: { branch_id: branchId }, include: { order: true }, orderBy: { created_at: 'desc' } });
  }

  async findKOTById(id: string) {
    return prisma.kitchenOrderTicket.findUnique({ where: { id }, include: { order: true } });
  }

  async updateKOTStatus(id: string, status: KOTStatus) {
    return prisma.kitchenOrderTicket.update({ where: { id }, data: { status } });
  }

  async createPayment(data: { branch_id: string; order_id: string; amount_paid: number; payment_method: PayMethod; transaction_ref?: string }) {
    return prisma.advancePayment.create({ data });
  }

  async findPaymentsByBranch(branchId: string) {
    return prisma.advancePayment.findMany({ where: { branch_id: branchId }, include: { order: true }, orderBy: { created_at: 'desc' } });
  }

  async findPaymentById(id: string) {
    return prisma.advancePayment.findUnique({ where: { id }, include: { order: true } });
  }

  async updatePaymentStatus(id: string, status: any) {
    // No-op or log since AdvancePayment has no status field
    return this.findPaymentById(id);
  }
}

export const posKdsRepo = new PosKdsRepo();
