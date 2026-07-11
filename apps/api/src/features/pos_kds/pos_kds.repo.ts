import { AddressType, OrderStatus, KOTStatus, OrderType, PayMethod, TableSessionStatus } from '@prisma/client';
import prisma from '../../infra/database/client';

export class PosKdsRepo {
  async createOrder(data: { branch_id: string; order_no: number; uid?: string; delivery_address_id?: string; order_type: OrderType; table_id?: string; table_session_id?: string; table_side_ids?: string[]; total_amount: number; subtotal: number; tax_amount: number; discount_amount: number; final_paying_price?: number; employee_id?: string; partner_id?: string; code: string; notes?: string; payment_proofs?: string[] }) {
    return prisma.order.create({ data: data as any });
  }

  async findNextOrderNo(branchId: string) {
    const result = await prisma.order.aggregate({
      where: { branch_id: branchId },
      _max: { order_no: true },
    });
    return (result._max.order_no || 0) + 1;
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
    const orders = await prisma.order.findMany({ where: { branch_id: branchId }, include: { user: true, table: true, table_session: true, items: { include: { menu_item: true } } }, orderBy: { created_at: 'desc' } });
    return this.withUserAddresses(orders);
  }

  async findOrdersByUser(uid: string) {
    return prisma.order.findMany({
      where: { uid },
      include: {
        branch: { select: { id: true, name: true } },
        items: {
          include: { menu_item: { select: { id: true, display_name: true } } },
        },
      },
      orderBy: { created_at: 'desc' },
    });
  }

  async findOrderById(id: string) {
    const order = await prisma.order.findUnique({ where: { id }, include: { user: true, table: true, table_session: true, items: { include: { menu_item: true } }, kots: true, advance_payments: true } });
    if (!order) {
      return order;
    }
    const orders = await this.withUserAddresses([order]);
    return orders[0];
  }

  async findActiveCustomerOrder(branchId: string, uid: string, orderType: OrderType, deliveryAddressId?: string) {
    return prisma.order.findFirst({
      where: {
        branch_id: branchId,
        uid,
        order_type: orderType,
        status: { notIn: [OrderStatus.PAID, OrderStatus.CANCELLED, OrderStatus.REFUNDED] },
        ...(orderType === OrderType.DELIVERY ? { delivery_address_id: deliveryAddressId || null } : {}),
      },
      include: { items: true },
      orderBy: { created_at: 'desc' },
    });
  }

  private async withUserAddresses<T extends { uid: string | null; order_type?: string | null; user?: any }>(orders: T[]) {
    const userIds = orders.map((order) => order.uid).filter((uid): uid is string => Boolean(uid));
    if (userIds.length === 0) {
      return orders;
    }
    const addresses = await prisma.address.findMany({ where: { entity_type: AddressType.USER, entity_id: { in: userIds } } });
    return orders.map((order) => ({
      ...order,
      user: order.user
        ? {
            ...order.user,
            addresses: order.order_type === OrderType.DELIVERY
              ? addresses.filter((address) => address.entity_id === order.uid)
              : [],
          }
        : order.user,
    }));
  }

  async updateOrderStatus(id: string, status: OrderStatus) {
    return prisma.order.update({ where: { id }, data: { status } });
  }

  async updateOrder(id: string, data: any) {
    return prisma.order.update({ where: { id }, data });
  }

  async findActiveTableSessions(branchId: string, tableId: string) {
    return prisma.tableSession.findMany({
      where: {
        branch_id: branchId,
        table_id: tableId,
        status: { in: [TableSessionStatus.ACTIVE, TableSessionStatus.BILLED] },
      },
      include: {
        orders: {
          where: {
            status: { notIn: [OrderStatus.PAID, OrderStatus.CANCELLED, OrderStatus.REFUNDED] },
          },
          include: { items: true },
          orderBy: { created_at: 'desc' },
        },
      },
    });
  }

  async findTableSessionById(id: string) {
    return prisma.tableSession.findUnique({
      where: { id },
      include: {
        orders: {
          where: {
            status: { notIn: [OrderStatus.PAID, OrderStatus.CANCELLED, OrderStatus.REFUNDED] },
          },
          include: { items: true },
          orderBy: { created_at: 'desc' },
        },
      },
    });
  }

  async createTableSession(data: { branch_id: string; table_id: string; table_side_ids?: string[]; uid?: string }) {
    return prisma.tableSession.create({ data: data as any });
  }

  async updateTableSession(id: string, data: { status?: TableSessionStatus; closed_at?: Date }) {
    return prisma.tableSession.update({ where: { id }, data });
  }

  async createOrderItem(data: { branch_id: string; order_id: string; menu_item_id: string; qty: number; unit_price: number; total_price: number; notes?: string }) {
    return prisma.orderItem.create({ data });
  }

  async createOrderItems(items: { branch_id: string; order_id: string; menu_item_id: string; sale_mode_id?: string; qty: number; unit_price: number; total_price: number; sale_mode_label?: string; quantity_uom_id?: string; quantity_uom_code?: string; base_quantity?: number; base_uom_id?: string; base_uom_code?: string; notes?: string }[]) {
    return prisma.orderItem.createMany({ data: items });
  }

  async findMenuItemForSale(menuItemId: string, branchId: string) {
    return prisma.menuItem.findFirst({
      where: { id: menuItemId, branch_id: branchId, is_deleted: false, status: 'ACTIVE' },
      include: {
        variant: { include: { uom: true } },
        sale_modes: {
          where: { is_deleted: false, status: 'ACTIVE' },
          include: { uom: true },
          orderBy: { sort_order: 'asc' },
        },
      },
    });
  }

  async findUOMConversion(branchId: string, fromUomId: string, toUomId: string) {
    return prisma.uOMConversion.findFirst({
      where: {
        branch_id: branchId,
        from_uom_id: fromUomId,
        to_uom_id: toUomId,
      },
    });
  }

  async createTable(data: { branch_id: string; zone_id: string; table_number: string; capacity: number; side_count?: number; side_labels?: string[] }) {
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

  async createTableZone(data: { branch_id: string; name: string }) {
    return prisma.tableZone.create({ data });
  }

  async findTableZonesByBranch(branchId: string) {
    return prisma.tableZone.findMany({ where: { branch_id: branchId, is_deleted: false } });
  }

  async findTableZoneById(id: string) {
    return prisma.tableZone.findUnique({ where: { id } });
  }

  async updateTableZone(id: string, data: Partial<{ name: string; is_deleted: boolean }>) {
    return prisma.tableZone.update({ where: { id }, data });
  }

  async deleteTableZone(id: string) {
    return prisma.tableZone.update({ where: { id }, data: { is_deleted: true } });
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

  async deleteOrder(id: string) {
    return prisma.$transaction([
      prisma.orderItem.deleteMany({ where: { order_id: id } }),
      prisma.kitchenOrderTicket.deleteMany({ where: { order_id: id } }),
      prisma.advancePayment.deleteMany({ where: { order_id: id } }),
      prisma.order.delete({ where: { id } })
    ]);
  }

  async findPaymentById(id: string) {
    return prisma.advancePayment.findUnique({ where: { id }, include: { order: true } });
  }

  async updatePaymentStatus(id: string, status: any) {
    return this.findPaymentById(id);
  }
}

export const posKdsRepo = new PosKdsRepo();
