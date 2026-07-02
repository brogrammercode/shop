import { posKdsRepo } from './pos_kds.repo';
import { _POS_KDS_CONSTANTS } from './pos_kds.constant';
import { AppError, NotFoundError, BadRequestError } from '../../utils/error';
import { HttpStatus } from '../../constants/status';
import { OrderType, PayMethod, KOTStatus } from '@prisma/client';

export class PosKdsService {
  async createOrder(branchId: string, data: { customer_id?: string; order_type: OrderType; table_id?: string; items: { menu_item_id: string; variant_id?: string; quantity: number; unit_price: number; notes?: string }[] }) {
    let subtotal = 0;
    const orderItems = data.items.map(item => {
      const itemSubtotal = item.quantity * item.unit_price;
      subtotal += itemSubtotal;
      return { ...item, subtotal: itemSubtotal };
    });

    // Mock calculations for tax/discount
    const tax_amount = subtotal * 0.1; 
    const discount_amount = 0;
    const total_amount = subtotal + tax_amount - discount_amount;

    const order = await posKdsRepo.createOrder({
      branch_id: branchId,
      customer_id: data.customer_id,
      order_type: data.order_type,
      table_id: data.table_id,
      total_amount,
      subtotal,
      tax_amount,
      discount_amount,
    });

    await posKdsRepo.createOrderItems(orderItems.map(item => ({ 
      branch_id: branchId,
      order_id: order.id,
      menu_item_id: item.menu_item_id,
      qty: item.quantity,
      unit_price: item.unit_price,
      total_price: item.subtotal,
      notes: item.notes
    })));

    // Generate KOT
    const kot = await posKdsRepo.createKOT({ branch_id: branchId, order_id: order.id, station: 'HOT_FOOD', status: 'PREPARING' });

    return this.getOrderById(order.id, branchId);
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

    // Free the table if it was a DINE_IN order
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

    // Refund logic here (e.g. updating payments)
    // AdvancePayment has no status field

    return posKdsRepo.updateOrderStatus(id, 'REFUNDED');
  }

  async cancelOrder(id: string, branchId: string) {
    const order = await this.getOrderById(id, branchId);
    if (order.status !== 'OPEN' && order.status !== 'BILLED') {
      throw new BadRequestError(_POS_KDS_CONSTANTS._E_R_R_O_R_S.INVALID_STATUS);
    }

    // Cancel related KOTs
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

  async createTable(branchId: string, zone_id: string, table_number: string, capacity: number) {
    return posKdsRepo.createTable({ branch_id: branchId, zone_id, table_number, capacity });
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
    await this.getTableById(id, branchId);
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
