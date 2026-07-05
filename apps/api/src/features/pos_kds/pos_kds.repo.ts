import { AddressType, OrderStatus, KOTStatus, OrderType, PayMethod } from '@prisma/client';
import prisma from '../../infra/database/client';

export class PosKdsRepo {
  async createOrder(data: { branch_id: string; uid?: string; delivery_address_id?: string; order_type: OrderType; table_id?: string; total_amount: number; subtotal: number; tax_amount: number; discount_amount: number; price_addition_amount?: number; price_reduction_amount?: number; final_paying_price?: number }) {
    return prisma.order.create({ data });
  }

  async findUserByPhone(phone: string) {
    const users = await prisma.user.findMany({ where: { phone: { contains: phone }, is_deleted: false }, take: 10 });
    const userIds = users.map((user) => user.id);
    if (userIds.length === 0) {
      return [];
    }
    const addresses = await prisma.address.findMany({ where: { entity_type: AddressType.USER, entity_id: { in: userIds } } });
    return users.map((user) => ({
      ...user,
      addresses: addresses.filter((address) => address.entity_id === user.id),
    }));
  }

  async findOrdersByBranch(branchId: string) {
    return prisma.order.findMany({ where: { branch_id: branchId }, include: { user: true, table: true, items: true }, orderBy: { created_at: 'desc' } });
  }

  async findOrderById(id: string) {
    return prisma.order.findUnique({ where: { id }, include: { user: true, table: true, items: true, kots: true, advance_payments: true } });
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
    return this.findPaymentById(id);
  }
}

export const posKdsRepo = new PosKdsRepo();
