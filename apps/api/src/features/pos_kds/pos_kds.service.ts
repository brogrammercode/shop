import { posKdsRepo } from './pos_kds.repo';
import { _POS_KDS_CONSTANTS } from './pos_kds.constant';
import { AppError, NotFoundError, BadRequestError } from '../../utils/error';
import { HttpStatus } from '../../constants/status';
import { OrderType, PayMethod, KOTStatus } from '@prisma/client';

export class PosKdsService {
  async createOrder(branchId: string, data: { uid?: string; delivery_address_id?: string; order_type: OrderType; table_id?: string; table_side_ids?: string[]; final_paying_price?: number; employee_id?: string; partner_id?: string; items: { menu_item_id: string; variant_id?: string; quantity: number; unit_price: number; notes?: string }[] }) {
    let subtotal = 0;
    const orderItems = data.items.map(item => {
      const itemSubtotal = item.quantity * item.unit_price;
      subtotal += itemSubtotal;
      return { ...item, subtotal: itemSubtotal };
    });

    const tax_amount = 0;
    const discount_amount = 0;
    const total_amount = subtotal + tax_amount - discount_amount;
    const final_paying_price = Number(data.final_paying_price ?? total_amount);
    const orderWindow = this.getOrderWindowAfterFour();
    const order_no = (await posKdsRepo.countOrdersByCreatedRange(branchId, orderWindow.start, orderWindow.end)) + 1;

    const order = await posKdsRepo.createOrder({
      branch_id: branchId,
      order_no,
      uid: data.uid,
      delivery_address_id: data.delivery_address_id,
      order_type: data.order_type,
      table_id: data.table_id,
      table_side_ids: data.table_side_ids,
      total_amount,
      subtotal,
      tax_amount,
      discount_amount,
      final_paying_price,
      employee_id: data.employee_id,
      partner_id: data.order_type === OrderType.DELIVERY ? data.partner_id : undefined,
      code: `ORD-${Date.now()}-${order_no.toString().padStart(3, '0')}`,
    });

    await posKdsRepo.createOrderItems(orderItems.map(item => ({ 
      branch_id: branchId,
      order_id: order.id,
      menu_item_id: item.menu_item_id,
      qty: item.quantity ?? (item as any).qty,
      unit_price: item.unit_price,
      total_price: item.subtotal,
      notes: item.notes
    })));

    if (data.order_type === 'DINE_IN' && data.table_id) {
      await posKdsRepo.updateTable(data.table_id, { status: 'OCCUPIED' });
    }

    const kot = await posKdsRepo.createKOT({ branch_id: branchId, order_id: order.id, station: 'HOT_FOOD', status: 'PREPARING' });

    return this.getOrderById(order.id, branchId);
  }

  private getOrderWindowAfterFour() {
    const now = new Date();
    const start = new Date(now);
    start.setHours(4, 0, 0, 0);
    if (now < start) {
      start.setDate(start.getDate() - 1);
    }
    const end = new Date(start);
    end.setDate(end.getDate() + 1);
    return { start, end };
  }

  async getCustomerByPhone(phone: string) {
    return posKdsRepo.findUserByPhone(phone);
  }

  async listOrders(branchId: string) {
    return posKdsRepo.findOrdersByBranch(branchId);
  }

  async getOrderById(id: string, branchId: string) {
    const order = await posKdsRepo.findOrderById(id);
    if (!order || order.branch_id !== branchId) {
      throw new NotFoundError(_POS_KDS_CONSTANTS._E_R_R_O_R_S.ORDER_NOT_FOUND);
    }
    return order;
  }

  async deleteOrder(id: string, branchId: string) {
    const order = await this.getOrderById(id, branchId);
    if (order.table_id) {
      // Check if table has other active orders, if not, make it AVAILABLE
      const orders = await this.listOrders(branchId);
      const otherActiveOrders = orders.filter(o => o.table_id === order.table_id && o.id !== order.id && !['COMPLETED', 'CANCELLED'].includes(o.status));
      if (otherActiveOrders.length === 0) {
        await posKdsRepo.updateTable(order.table_id, { status: 'AVAILABLE' });
      }
    }
    return posKdsRepo.deleteOrder(id);
  }

  async payOrder(id: string, branchId: string, payment_method: PayMethod, amount: number) {
    const order = await this.getOrderById(id, branchId);
    if (order.status !== 'OPEN' && order.status !== 'BILLED') {
      throw new BadRequestError(_POS_KDS_CONSTANTS._E_R_R_O_R_S.INVALID_STATUS);
    }

    const payment = await posKdsRepo.createPayment({
      branch_id: branchId,
      order_id: id,
      amount_paid: amount,
      payment_method,
    });

    await posKdsRepo.updateOrderStatus(id, 'PAID');

    if (order.table_id) {
      await posKdsRepo.updateTable(order.table_id, { status: 'AVAILABLE' });
    }

    return payment;
  }

  async refundOrder(id: string, branchId: string) {
    const order = await this.getOrderById(id, branchId);
    if (order.status !== 'PAID') {
      throw new BadRequestError(_POS_KDS_CONSTANTS._E_R_R_O_R_S.INVALID_STATUS);
    }

    return posKdsRepo.updateOrderStatus(id, 'REFUNDED');
  }

  async cancelOrder(id: string, branchId: string) {
    const order = await this.getOrderById(id, branchId);
    if (order.status !== 'OPEN' && order.status !== 'BILLED') {
      throw new BadRequestError(_POS_KDS_CONSTANTS._E_R_R_O_R_S.INVALID_STATUS);
    }

    for (const kot of (order as any).kots || []) {
      if (kot.status === 'PREPARING') {
        await posKdsRepo.updateKOTStatus(kot.id, 'CANCELLED');
      }
    }

    if (order.table_id) {
      await posKdsRepo.updateTable(order.table_id, { status: 'AVAILABLE' });
    }

    return posKdsRepo.updateOrderStatus(id, 'CANCELLED');
  }

  async createTableZone(branchId: string, name: string) {
    return posKdsRepo.createTableZone({ branch_id: branchId, name });
  }

  async listTableZones(branchId: string) {
    return posKdsRepo.findTableZonesByBranch(branchId);
  }

  async getTableZoneById(id: string, branchId: string) {
    const zone = await posKdsRepo.findTableZoneById(id);
    if (!zone || zone.branch_id !== branchId) {
      throw new NotFoundError(_POS_KDS_CONSTANTS._E_R_R_O_R_S.TABLE_ZONE_NOT_FOUND || 'Table zone not found');
    }
    return zone;
  }

  async updateTableZone(id: string, branchId: string, data: any) {
    await this.getTableZoneById(id, branchId);
    return posKdsRepo.updateTableZone(id, data);
  }

  async deleteTableZone(id: string, branchId: string) {
    await this.getTableZoneById(id, branchId);
    return posKdsRepo.deleteTableZone(id);
  }

  async createTable(branchId: string, zone_id: string, table_number: string, capacity: number, side_count?: number, side_labels?: string[]) {
    let finalSideLabels = side_labels;
    if (!finalSideLabels && side_count && side_count > 0) {
      finalSideLabels = Array.from({ length: side_count }, (_, i) => `${table_number}-${i + 1}`);
    }
    return posKdsRepo.createTable({ branch_id: branchId, zone_id, table_number, capacity, side_count, side_labels: finalSideLabels });
  }

  async listTables(branchId: string) {
    return posKdsRepo.findTablesByBranch(branchId);
  }

  async getTableById(id: string, branchId: string) {
    const table = await posKdsRepo.findTableById(id);
    if (!table || table.branch_id !== branchId) {
      throw new NotFoundError(_POS_KDS_CONSTANTS._E_R_R_O_R_S.TABLE_NOT_FOUND);
    }
    return table;
  }

  async updateTable(id: string, branchId: string, data: any) {
    const table = await this.getTableById(id, branchId);
    if (data.side_count !== undefined && !data.side_labels) {
      const tNumber = data.table_number || table.table_number;
      data.side_labels = Array.from({ length: data.side_count }, (_, i) => `${tNumber}-${i + 1}`);
    }
    return posKdsRepo.updateTable(id, data);
  }

  async deleteTable(id: string, branchId: string) {
    await this.getTableById(id, branchId);
    return posKdsRepo.deleteTable(id);
  }

  async listKOTs(branchId: string) {
    return posKdsRepo.findKOTsByBranch(branchId);
  }

  async getKOTById(id: string, branchId: string) {
    const kot = await posKdsRepo.findKOTById(id);
    if (!kot || kot.branch_id !== branchId) {
      throw new NotFoundError(_POS_KDS_CONSTANTS._E_R_R_O_R_S.KOT_NOT_FOUND);
    }
    return kot;
  }

  async updateKOTStatus(id: string, branchId: string, status: KOTStatus) {
    const kot = await this.getKOTById(id, branchId);
    const updatedKot = await posKdsRepo.updateKOTStatus(id, status);
    return updatedKot;
  }

  async listPayments(branchId: string) {
    return posKdsRepo.findPaymentsByBranch(branchId);
  }

  async getPaymentById(id: string, branchId: string) {
    const payment = await posKdsRepo.findPaymentById(id);
    if (!payment || payment.order.branch_id !== branchId) {
      throw new NotFoundError(_POS_KDS_CONSTANTS._E_R_R_O_R_S.PAYMENT_NOT_FOUND);
    }
    return payment;
  }
}

export const posKdsService = new PosKdsService();
