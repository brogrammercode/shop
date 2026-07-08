import { posKdsRepo } from "./pos_kds.repo";
import { _POS_KDS_CONSTANTS } from "./pos_kds.constant";
import { AppError, NotFoundError, BadRequestError } from "../../utils/error";
import { HttpStatus } from "../../constants/status";
import { OrderType, PayMethod, KOTStatus, OrderStatus } from "@prisma/client";
import { notificationService } from "../notification/notification.service";
import { _NOTIFICATION_CONSTANTS } from "../notification/notification.constant";

export class PosKdsService {
  async createOrder(
    branchId: string,
    data: {
      uid?: string;
      delivery_address_id?: string;
      order_type: OrderType;
      table_id?: string;
      table_side_ids?: string[];
      final_paying_price?: number;
      employee_id?: string;
      partner_id?: string;
      notes?: string;
      items: {
        menu_item_id: string;
        variant_id?: string;
        quantity: number;
        unit_price: number;
        notes?: string;
      }[];
    },
  ) {
    let subtotal = 0;
    const orderItems = data.items.map((item) => {
      const itemSubtotal = item.quantity * item.unit_price;
      subtotal += itemSubtotal;
      return { ...item, subtotal: itemSubtotal };
    });

    const tax_amount = 0;
    const discount_amount = 0;
    const total_amount = subtotal + tax_amount - discount_amount;
    const final_paying_price = Number(data.final_paying_price ?? total_amount);
    const orderWindow = this.getOrderWindowAfterFour();
    const order_no =
      (await posKdsRepo.countOrdersByCreatedRange(
        branchId,
        orderWindow.start,
        orderWindow.end,
      )) + 1;
    const table = data.table_id
      ? await posKdsRepo.findTableById(data.table_id)
      : null;
    const table_side_ids = table
      ? this.normalizeTableSideIds(table, data.table_side_ids)
      : data.table_side_ids;

    const order = await posKdsRepo.createOrder({
      branch_id: branchId,
      order_no,
      uid: data.uid,
      delivery_address_id: data.delivery_address_id,
      order_type: data.order_type,
      table_id: data.table_id,
      table_side_ids,
      total_amount,
      subtotal,
      tax_amount,
      discount_amount,
      final_paying_price,
      employee_id: data.employee_id,
      partner_id:
        data.order_type === OrderType.DELIVERY ? data.partner_id : undefined,
      code: `ORD-${Date.now()}-${order_no.toString().padStart(3, "0")}`,
      notes: data.notes,
    });

    await posKdsRepo.createOrderItems(
      orderItems.map((item) => ({
        branch_id: branchId,
        order_id: order.id,
        menu_item_id: item.menu_item_id,
        qty: item.quantity ?? (item as any).qty,
        unit_price: item.unit_price,
        total_price: item.subtotal,
        notes: item.notes,
      })),
    );

    if (data.order_type === "DINE_IN" && data.table_id) {
      await posKdsRepo.updateTable(data.table_id, { status: "OCCUPIED" });
    }

    const kot = await posKdsRepo.createKOT({
      branch_id: branchId,
      order_id: order.id,
      station: "HOT_FOOD",
      status: "PREPARING",
    });

    const createdOrder = await this.getOrderById(order.id, branchId);
    await this.notifyOrder(createdOrder, {
      type: _NOTIFICATION_CONSTANTS._T_Y_P_E_S.ORDER_CREATED,
      title: _NOTIFICATION_CONSTANTS._M_E_S_S_A_G_E_S.ORDER_CREATED_TITLE,
      message: this.orderMessage(createdOrder, "has been created"),
      actor_id: data.employee_id,
    });
    return createdOrder;
  }

  private normalizeTableSideIds(
    table: { id: string; side_labels: any },
    sideIds?: string[],
  ) {
    const sideLabels = Array.isArray(table.side_labels)
      ? table.side_labels.map((side) => side.toString())
      : [];
    return (sideIds || []).map((sideId) => {
      if (sideLabels.includes(sideId)) {
        return sideId;
      }
      const prefix = `${table.id}-`;
      if (sideId.startsWith(prefix)) {
        const index = Number(sideId.replace(prefix, "")) - 1;
        return sideLabels[index] || sideId;
      }
      return sideId;
    });
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

  async listMyOrders(uid: string) {
    return posKdsRepo.findOrdersByUser(uid);
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
      const otherActiveOrders = orders.filter(
        (o) =>
          o.table_id === order.table_id &&
          o.id !== order.id &&
          !["COMPLETED", "CANCELLED"].includes(o.status),
      );
      if (otherActiveOrders.length === 0) {
        await posKdsRepo.updateTable(order.table_id, { status: "AVAILABLE" });
      }
    }
    await this.notifyOrder(order, {
      type: _NOTIFICATION_CONSTANTS._T_Y_P_E_S.ORDER_DELETED,
      title: _NOTIFICATION_CONSTANTS._M_E_S_S_A_G_E_S.ORDER_DELETED_TITLE,
      message: this.orderMessage(order, "has been deleted"),
    });
    return posKdsRepo.deleteOrder(id);
  }

  async payOrder(
    id: string,
    branchId: string,
    payment_method: PayMethod,
    amount: number,
  ) {
    const order = await this.getOrderById(id, branchId);
    if (order.status !== "OPEN" && order.status !== "BILLED") {
      throw new BadRequestError(_POS_KDS_CONSTANTS._E_R_R_O_R_S.INVALID_STATUS);
    }

    const payment = await posKdsRepo.createPayment({
      branch_id: branchId,
      order_id: id,
      amount_paid: amount,
      payment_method,
    });

    await posKdsRepo.updateOrderStatus(id, "PAID");

    if (order.table_id) {
      await posKdsRepo.updateTable(order.table_id, { status: "AVAILABLE" });
    }

    await this.notifyOrder(
      { ...order, status: "PAID" },
      {
        type: _NOTIFICATION_CONSTANTS._T_Y_P_E_S.ORDER_PAID,
        title: _NOTIFICATION_CONSTANTS._M_E_S_S_A_G_E_S.ORDER_PAID_TITLE,
        message: this.orderMessage(order, "has been paid"),
      },
    );

    return payment;
  }

  async refundOrder(id: string, branchId: string) {
    const order = await this.getOrderById(id, branchId);
    if (order.status !== "PAID") {
      throw new BadRequestError(_POS_KDS_CONSTANTS._E_R_R_O_R_S.INVALID_STATUS);
    }

    const updatedOrder = await posKdsRepo.updateOrderStatus(id, "REFUNDED");
    await this.notifyOrder(updatedOrder, {
      type: _NOTIFICATION_CONSTANTS._T_Y_P_E_S.ORDER_REFUNDED,
      title: _NOTIFICATION_CONSTANTS._M_E_S_S_A_G_E_S.ORDER_REFUNDED_TITLE,
      message: this.orderMessage(updatedOrder, "has been refunded"),
    });
    return updatedOrder;
  }

  async cancelOrder(id: string, branchId: string) {
    const order = await this.getOrderById(id, branchId);
    if (order.status !== "OPEN" && order.status !== "BILLED") {
      throw new BadRequestError(_POS_KDS_CONSTANTS._E_R_R_O_R_S.INVALID_STATUS);
    }

    for (const kot of (order as any).kots || []) {
      if (kot.status === "PREPARING") {
        await posKdsRepo.updateKOTStatus(kot.id, "CANCELLED");
      }
    }

    if (order.table_id) {
      await posKdsRepo.updateTable(order.table_id, { status: "AVAILABLE" });
    }

    const updatedOrder = await posKdsRepo.updateOrderStatus(id, "CANCELLED");
    await this.notifyOrder(updatedOrder, {
      type: _NOTIFICATION_CONSTANTS._T_Y_P_E_S.ORDER_CANCELLED,
      title: _NOTIFICATION_CONSTANTS._M_E_S_S_A_G_E_S.ORDER_CANCELLED_TITLE,
      message: this.orderMessage(updatedOrder, "has been cancelled"),
    });
    return updatedOrder;
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
      throw new NotFoundError(
        _POS_KDS_CONSTANTS._E_R_R_O_R_S.TABLE_ZONE_NOT_FOUND ||
          "Table zone not found",
      );
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

  async createTable(
    branchId: string,
    zone_id: string,
    table_number: string,
    capacity: number,
    side_count?: number,
    side_labels?: string[],
  ) {
    let finalSideLabels = side_labels;
    if (!finalSideLabels && side_count && side_count > 0) {
      finalSideLabels = Array.from(
        { length: side_count },
        (_, i) => `${table_number}-${i + 1}`,
      );
    }
    return posKdsRepo.createTable({
      branch_id: branchId,
      zone_id,
      table_number,
      capacity,
      side_count,
      side_labels: finalSideLabels,
    });
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
      data.side_labels = Array.from(
        { length: data.side_count },
        (_, i) => `${tNumber}-${i + 1}`,
      );
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
    await this.notifyOrder(kot.order, {
      type: _NOTIFICATION_CONSTANTS._T_Y_P_E_S.KOT_STATUS_UPDATED,
      title: _NOTIFICATION_CONSTANTS._M_E_S_S_A_G_E_S.KOT_STATUS_UPDATED_TITLE,
      message: this.orderMessage(kot.order, `kitchen status is ${status}`),
    });
    return updatedKot;
  }

  async updateOrderStatus(id: string, branchId: string, status: OrderStatus) {
    const order = await this.getOrderById(id, branchId);
    if (!order) throw new NotFoundError("Order not found");
    const updatedOrder = await posKdsRepo.updateOrderStatus(id, status);
    await this.notifyOrder(updatedOrder, {
      type: _NOTIFICATION_CONSTANTS._T_Y_P_E_S.ORDER_STATUS_UPDATED,
      title:
        _NOTIFICATION_CONSTANTS._M_E_S_S_A_G_E_S.ORDER_STATUS_UPDATED_TITLE,
      message: this.orderMessage(updatedOrder, `status is ${status}`),
    });
    return updatedOrder;
  }

  async listPayments(branchId: string) {
    return posKdsRepo.findPaymentsByBranch(branchId);
  }

  async getPaymentById(id: string, branchId: string) {
    const payment = await posKdsRepo.findPaymentById(id);
    if (!payment || payment.order.branch_id !== branchId) {
      throw new NotFoundError(
        _POS_KDS_CONSTANTS._E_R_R_O_R_S.PAYMENT_NOT_FOUND,
      );
    }
    return payment;
  }

  private async notifyOrder(
    order: any,
    data: { type: string; title: string; message: string; actor_id?: string },
  ) {
    await notificationService.notifyOrderLifecycle({
      branch_id: order.branch_id,
      order_id: order.id,
      order_no: order.order_no,
      type: data.type,
      title: data.title,
      message: data.message,
      actor_id: data.actor_id,
      extra_receipent_ids: order.uid ? [order.uid] : [],
    });
  }

  private orderMessage(order: any, action: string) {
    const orderNo = order.order_no
      ? order.order_no.toString().padStart(3, "0")
      : order.id;
    return `Order #${orderNo} ${action}`;
  }
}

export const posKdsService = new PosKdsService();
