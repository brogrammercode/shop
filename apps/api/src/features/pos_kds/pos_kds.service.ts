import { posKdsRepo } from "./pos_kds.repo";
import { _POS_KDS_CONSTANTS } from "./pos_kds.constant";
import { AppError, NotFoundError, BadRequestError } from "../../utils/error";
import { HttpStatus } from "../../constants/status";
import { OrderType, PayMethod, KOTStatus, OrderStatus, KOTStation } from "@prisma/client";
import { notificationService } from "../notification/notification.service";
import { _NOTIFICATION_CONSTANTS } from "../notification/notification.constant";
import { ladyluckService } from "../ladyluck/ladyluck.service";

export class PosKdsService {
  async createOrder(
    branchId: string,
    data: {
      uid?: string;
      table_session_id?: string;
      delivery_address_id?: string;
      order_type: OrderType;
      table_id?: string;
      table_side_ids?: string[];
      final_paying_price?: number;
      employee_id?: string;
      partner_id?: string;
      ladyluck_discount_id?: string;
      notes?: string;
      payment_proofs?: string[];
      items: {
        menu_item_id: string;
        variant_id?: string;
        sale_mode_id?: string;
        sale_mode_label?: string;
        quantity_uom_id?: string;
        quantity_uom_code?: string;
        quantity: number;
        unit_price: number;
        notes?: string;
      }[];
    },
  ) {
    let subtotal = 0;
    const orderItems = await Promise.all(data.items.map(async (item) => {
      const resolvedItem = await this.resolveOrderItem(branchId, item);
      const itemSubtotal = resolvedItem.quantity * resolvedItem.unit_price;
      subtotal += itemSubtotal;
      return { ...resolvedItem, subtotal: itemSubtotal };
    }));

    const tax_amount = 0;
    const order_no = await posKdsRepo.findNextOrderNo(branchId);
    const isDineIn = data.order_type === OrderType.DINE_IN;
    const isDelivery = data.order_type === OrderType.DELIVERY;
    const table = isDineIn && data.table_id
      ? await posKdsRepo.findTableById(data.table_id)
      : null;
    const table_side_ids = isDineIn && table
      ? this.normalizeTableSideIds(table, data.table_side_ids)
      : undefined;

    let tableSession: any = null;
    let appendOrder: any = null;
    if (isDineIn) {
      if (!table || !data.table_id) {
        throw new BadRequestError(_POS_KDS_CONSTANTS._E_R_R_O_R_S.TABLE_NOT_FOUND);
      }
      const sessionResult = await this.resolveTableSession(
        branchId,
        data.table_id,
        table_side_ids || [],
        data.table_session_id,
        data.uid,
      );
      tableSession = sessionResult.session;
      appendOrder = sessionResult.order;
    }

    if (
      !isDineIn &&
      data.uid &&
      (data.order_type === OrderType.DELIVERY || data.order_type === OrderType.TAKEAWAY)
    ) {
      appendOrder = await posKdsRepo.findActiveCustomerOrder(
        branchId,
        data.uid,
        data.order_type,
        isDelivery ? data.delivery_address_id : undefined,
      );
    }

    if (appendOrder) {
      return this.appendItemsToOrder(branchId, appendOrder, orderItems, subtotal, data.employee_id, data.ladyluck_discount_id);
    }

    const ladyluckDiscount = await ladyluckService.calculateDiscount(data.uid, branchId, data.ladyluck_discount_id, subtotal);
    const discount_amount = ladyluckDiscount.discount_amount;
    const total_amount = subtotal + tax_amount - discount_amount;
    const final_paying_price = Number(total_amount);

    const order = await posKdsRepo.createOrderBundle(
      {
        branch_id: branchId,
        order_no,
        uid: data.uid,
        delivery_address_id: isDelivery ? data.delivery_address_id : undefined,
        order_type: data.order_type,
        table_id: isDineIn ? data.table_id : undefined,
        table_session_id: tableSession?.id,
        table_side_ids,
        total_amount,
        subtotal,
        tax_amount,
        discount_amount,
        ladyluck_discount_id: ladyluckDiscount.discount_id,
        ladyluck_discount_amount: ladyluckDiscount.discount_amount,
        final_paying_price,
        employee_id: data.employee_id,
        partner_id: isDelivery ? data.partner_id : undefined,
        code: `ORD-${Date.now()}-${order_no.toString().padStart(3, "0")}`,
        notes: data.notes,
        payment_proofs: data.payment_proofs || [],
      },
      orderItems.map((item) => ({
        branch_id: branchId,
        menu_item_id: item.menu_item_id,
        sale_mode_id: item.sale_mode_id,
        qty: item.quantity,
        unit_price: item.unit_price,
        total_price: item.subtotal,
        sale_mode_label: item.sale_mode_label,
        quantity_uom_id: item.quantity_uom_id,
        quantity_uom_code: item.quantity_uom_code,
        base_quantity: item.base_quantity,
        base_uom_id: item.base_uom_id,
        base_uom_code: item.base_uom_code,
        notes: item.notes,
      })),
      {
        branch_id: branchId,
        station: KOTStation.HOT_FOOD,
        status: KOTStatus.PREPARING,
      },
      isDineIn && data.table_id ? data.table_id : undefined,
      ladyluckDiscount.discount_id,
      ladyluckDiscount.discount_amount,
    );

    const createdOrder = await this.getOrderById(order.id, branchId).catch(() => order);
    void this.notifyOrder(createdOrder, {
      type: _NOTIFICATION_CONSTANTS._T_Y_P_E_S.ORDER_CREATED,
      title: _NOTIFICATION_CONSTANTS._M_E_S_S_A_G_E_S.ORDER_CREATED_TITLE,
      message: this.orderMessage(createdOrder, "has been created"),
      actor_id: data.employee_id,
    }).catch(() => undefined);
    return createdOrder;
  }

  private async appendItemsToOrder(
    branchId: string,
    appendOrder: any,
    orderItems: Awaited<ReturnType<PosKdsService["resolveOrderItem"]>>[],
    subtotal: number,
    employeeId?: string,
    ladyluckDiscountId?: string,
  ) {
    const nextSubtotal = Number(appendOrder.subtotal || 0) + subtotal;
    const existingLadyluckDiscountId = appendOrder.ladyluck_discount_id || undefined;
    const ladyluckDiscount = existingLadyluckDiscountId
      ? {
          discount_id: existingLadyluckDiscountId,
          discount_amount: Number(appendOrder.ladyluck_discount_amount || appendOrder.discount_amount || 0),
        }
      : await ladyluckService.calculateDiscount(appendOrder.uid, branchId, ladyluckDiscountId, nextSubtotal);
    const discountAmount = ladyluckDiscount.discount_amount;
    const nextTotal =
      nextSubtotal +
      Number(appendOrder.tax_amount || 0) -
      discountAmount;
    const shouldReopen = [
      OrderStatus.BILLED,
      OrderStatus.READY,
      OrderStatus.OUT_FOR_DELIVERY,
      OrderStatus.DELIVERED,
      OrderStatus.FAILED_DELIVERY,
    ].includes(appendOrder.status);
    const order = await posKdsRepo.appendOrderBundle(
      appendOrder.id,
      orderItems.map((item) => ({
        branch_id: branchId,
        order_id: appendOrder.id,
        menu_item_id: item.menu_item_id,
        sale_mode_id: item.sale_mode_id,
        qty: item.quantity,
        unit_price: item.unit_price,
        total_price: item.quantity * item.unit_price,
        sale_mode_label: item.sale_mode_label,
        quantity_uom_id: item.quantity_uom_id,
        quantity_uom_code: item.quantity_uom_code,
        base_quantity: item.base_quantity,
        base_uom_id: item.base_uom_id,
        base_uom_code: item.base_uom_code,
        notes: item.notes,
      })),
      {
        subtotal: nextSubtotal,
        discount_amount: discountAmount,
        ladyluck_discount_id: ladyluckDiscount.discount_id,
        ladyluck_discount_amount: discountAmount,
        total_amount: nextTotal,
        final_paying_price: nextTotal,
        status: shouldReopen ? OrderStatus.OPEN : appendOrder.status,
      },
      {
        branch_id: branchId,
        station: KOTStation.HOT_FOOD,
        status: KOTStatus.PREPARING,
      },
      !existingLadyluckDiscountId ? ladyluckDiscount.discount_id : undefined,
      discountAmount,
    );
    const updatedOrder = await this.getOrderById(appendOrder.id, branchId).catch(() => order);
    void this.notifyOrder(updatedOrder, {
      type: _NOTIFICATION_CONSTANTS._T_Y_P_E_S.ORDER_STATUS_UPDATED,
      title: _NOTIFICATION_CONSTANTS._M_E_S_S_A_G_E_S.ORDER_STATUS_UPDATED_TITLE,
      message: this.orderMessage(updatedOrder, "has new items added"),
      actor_id: employeeId,
    }).catch(() => undefined);
    return updatedOrder;
  }

  private async resolveTableSession(
    branchId: string,
    tableId: string,
    selectedSideIds: string[],
    tableSessionId?: string,
    uid?: string,
  ) {
    if (tableSessionId) {
      const session = await posKdsRepo.findTableSessionById(tableSessionId);
      if (!session || session.branch_id !== branchId || session.table_id !== tableId) {
        throw new NotFoundError(_POS_KDS_CONSTANTS._E_R_R_O_R_S.TABLE_SESSION_NOT_FOUND);
      }
      if (!["ACTIVE", "BILLED"].includes(session.status)) {
        throw new BadRequestError(_POS_KDS_CONSTANTS._E_R_R_O_R_S.TABLE_SESSION_CLOSED);
      }
      if (!this.sameSessionSeatScope(session.table_side_ids, selectedSideIds)) {
        throw new BadRequestError(_POS_KDS_CONSTANTS._E_R_R_O_R_S.TABLE_SEATS_OCCUPIED);
      }
      return {
        session,
        order: this.activeSessionOrder(session),
      };
    }

    const sessions = await posKdsRepo.findActiveTableSessions(branchId, tableId);
    const conflictingSessions = sessions.filter((session) =>
      this.sideScopesOverlap(session.table_side_ids, selectedSideIds),
    );
    if (conflictingSessions.length > 0) {
      const sameUserSession = uid
        ? conflictingSessions.find((session) => session.uid === uid)
        : null;
      if (sameUserSession) {
        return {
          session: sameUserSession,
          order: this.activeSessionOrder(sameUserSession),
        };
      }
      throw new BadRequestError(_POS_KDS_CONSTANTS._E_R_R_O_R_S.TABLE_SEATS_OCCUPIED);
    }

    const session = await posKdsRepo.createTableSession({
      branch_id: branchId,
      table_id: tableId,
      table_side_ids: selectedSideIds,
      uid,
    });
    return { session, order: null };
  }

  private activeSessionOrder(session: any) {
    return (session.orders || []).find((order: any) =>
      !["PAID", "CANCELLED", "REFUNDED"].includes(order.status),
    );
  }

  private sameSessionSeatScope(rawSessionSides: any, selectedSideIds: string[]) {
    const sessionSides = this.toStringList(rawSessionSides);
    if (sessionSides.length === 0 && selectedSideIds.length === 0) {
      return true;
    }
    if (sessionSides.length === 0 || selectedSideIds.length === 0) {
      return true;
    }
    return selectedSideIds.every((sideId) => sessionSides.includes(sideId));
  }

  private sideScopesOverlap(rawSessionSides: any, selectedSideIds: string[]) {
    const sessionSides = this.toStringList(rawSessionSides);
    if (sessionSides.length === 0 || selectedSideIds.length === 0) {
      return true;
    }
    return selectedSideIds.some((sideId) => sessionSides.includes(sideId));
  }

  private toStringList(value: any) {
    if (!Array.isArray(value)) {
      return [];
    }
    return value.map((item) => item?.toString().trim()).filter(Boolean);
  }

  private async resolveOrderItem(
    branchId: string,
    item: {
      menu_item_id: string;
      sale_mode_id?: string;
      sale_mode_label?: string;
      quantity_uom_id?: string;
      quantity_uom_code?: string;
      quantity: number;
      unit_price: number;
      notes?: string;
    },
  ) {
    const menuItem = await posKdsRepo.findMenuItemForSale(item.menu_item_id, branchId);
    if (!menuItem) {
      throw new NotFoundError(_POS_KDS_CONSTANTS._E_R_R_O_R_S.MENU_ITEM_NOT_FOUND);
    }
    let saleMode = item.sale_mode_id
      ? menuItem.sale_modes.find((mode) => mode.id === item.sale_mode_id)
      : null;

    if (!saleMode) {
      saleMode = menuItem.sale_modes.find((mode) => mode.is_default) || menuItem.sale_modes[0];
    }
    
    const quantity = Number(item.quantity);
    const unitPrice = saleMode ? Number(saleMode.price_per_unit) : Number(item.unit_price);
    const quantityUomId = saleMode?.uom_id || item.quantity_uom_id || menuItem.variant?.uom_id;
    const quantityUomCode = saleMode?.uom?.code || item.quantity_uom_code || menuItem.variant?.uom?.code;
    const baseUomId = menuItem.variant?.uom_id;
    const baseUomCode = menuItem.variant?.uom?.code;
    const baseQuantity = await this.baseQuantity(branchId, quantity, quantityUomId, baseUomId);
    return {
      menu_item_id: item.menu_item_id,
      sale_mode_id: saleMode?.id || item.sale_mode_id,
      sale_mode_label: saleMode?.label || item.sale_mode_label || _POS_KDS_CONSTANTS._D_E_F_A_U_L_T_S.SALE_MODE_LABEL,
      quantity_uom_id: quantityUomId,
      quantity_uom_code: quantityUomCode,
      quantity,
      unit_price: unitPrice,
      base_quantity: baseQuantity,
      base_uom_id: baseUomId,
      base_uom_code: baseUomCode,
      notes: item.notes,
    };
  }

  private async baseQuantity(
    branchId: string,
    quantity: number,
    quantityUomId?: string,
    baseUomId?: string,
  ) {
    if (!quantityUomId || !baseUomId || quantityUomId === baseUomId) {
      return quantity;
    }
    const direct = await posKdsRepo.findUOMConversion(branchId, quantityUomId, baseUomId);
    if (direct) {
      return quantity * direct.factor;
    }
    const reverse = await posKdsRepo.findUOMConversion(branchId, baseUomId, quantityUomId);
    if (reverse && reverse.factor !== 0) {
      return quantity / reverse.factor;
    }
    return quantity;
  }

  private normalizeTableSideIds(
    table: { id: string; side_labels: any },
    sideIds?: string[],
  ) {
    const sideLabels = Array.isArray(table.side_labels)
      ? table.side_labels.map((side) => side.toString())
      : [];
    const seen = new Set<string>();
    return (sideIds || []).reduce<string[]>((sides, rawSideId) => {
      const sideId = rawSideId?.toString().trim();
      if (!sideId) {
        return sides;
      }
      let resolvedSide = sideId;
      if (sideLabels.includes(sideId)) {
        resolvedSide = sideId;
      } else if (sideId.startsWith(`${table.id}-`)) {
        const prefix = `${table.id}-`;
        const index = Number(sideId.replace(prefix, "")) - 1;
        resolvedSide = sideLabels[index] || sideId;
      }
      if (!seen.has(resolvedSide)) {
        seen.add(resolvedSide);
        sides.push(resolvedSide);
      }
      return sides;
    }, []);
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
    if ((order as any).table_session_id) {
      await posKdsRepo.updateTableSession((order as any).table_session_id, {
        status: "CANCELLED" as any,
        closed_at: new Date(),
      });
    }
    if (order.table_id) {
      const activeSessions = await posKdsRepo.findActiveTableSessions(branchId, order.table_id);
      if (activeSessions.length === 0) {
        await posKdsRepo.updateTable(order.table_id, { status: "AVAILABLE" });
      }
    }
    void this.notifyOrder(order, {
      type: _NOTIFICATION_CONSTANTS._T_Y_P_E_S.ORDER_DELETED,
      title: _NOTIFICATION_CONSTANTS._M_E_S_S_A_G_E_S.ORDER_DELETED_TITLE,
      message: this.orderMessage(order, "has been deleted"),
    }).catch(() => undefined);
    return posKdsRepo.deleteOrder(id);
  }

  async payOrder(
    id: string,
    branchId: string,
    payment_method: PayMethod,
    amount: number,
    payment_proofs?: string[],
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

    const proofUrls = Array.isArray(payment_proofs)
      ? payment_proofs.map((proof) => proof?.toString().trim()).filter(Boolean)
      : [];
    await posKdsRepo.updateOrder(id, {
      status: "PAID",
      final_paying_price: Number(amount),
      payment_proofs: [...((order as any).payment_proofs || []), ...proofUrls],
    });
    await ladyluckService.awardOrderPoints(id);

    if ((order as any).table_session_id) {
      await posKdsRepo.updateTableSession((order as any).table_session_id, {
        status: "CLOSED" as any,
        closed_at: new Date(),
      });
    }

    if (order.table_id) {
      const activeSessions = await posKdsRepo.findActiveTableSessions(branchId, order.table_id);
      if (activeSessions.length === 0) {
        await posKdsRepo.updateTable(order.table_id, { status: "AVAILABLE" });
      }
    }

    void this.notifyOrder(
      { ...order, status: "PAID" },
      {
        type: _NOTIFICATION_CONSTANTS._T_Y_P_E_S.ORDER_PAID,
        title: _NOTIFICATION_CONSTANTS._M_E_S_S_A_G_E_S.ORDER_PAID_TITLE,
        message: this.orderMessage(order, "has been paid"),
      },
    ).catch(() => undefined);

    return payment;
  }

  async refundOrder(id: string, branchId: string) {
    const order = await this.getOrderById(id, branchId);
    if (order.status !== "PAID") {
      throw new BadRequestError(_POS_KDS_CONSTANTS._E_R_R_O_R_S.INVALID_STATUS);
    }

    const updatedOrder = await posKdsRepo.updateOrderStatus(id, "REFUNDED");
    await ladyluckService.reverseOrderPoints(id);
    if ((order as any).table_session_id) {
      await posKdsRepo.updateTableSession((order as any).table_session_id, {
        status: "CLOSED" as any,
        closed_at: new Date(),
      });
    }
    if (order.table_id) {
      const activeSessions = await posKdsRepo.findActiveTableSessions(branchId, order.table_id);
      if (activeSessions.length === 0) {
        await posKdsRepo.updateTable(order.table_id, { status: "AVAILABLE" });
      }
    }
    void this.notifyOrder(updatedOrder, {
      type: _NOTIFICATION_CONSTANTS._T_Y_P_E_S.ORDER_REFUNDED,
      title: _NOTIFICATION_CONSTANTS._M_E_S_S_A_G_E_S.ORDER_REFUNDED_TITLE,
      message: this.orderMessage(updatedOrder, "has been refunded"),
    }).catch(() => undefined);
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

    const updatedOrder = await posKdsRepo.updateOrderStatus(id, "CANCELLED");
    if ((order as any).table_session_id) {
      await posKdsRepo.updateTableSession((order as any).table_session_id, {
        status: "CANCELLED" as any,
        closed_at: new Date(),
      });
    }
    if (order.table_id) {
      const activeSessions = await posKdsRepo.findActiveTableSessions(branchId, order.table_id);
      if (activeSessions.length === 0) {
        await posKdsRepo.updateTable(order.table_id, { status: "AVAILABLE" });
      }
    }
    void this.notifyOrder(updatedOrder, {
      type: _NOTIFICATION_CONSTANTS._T_Y_P_E_S.ORDER_CANCELLED,
      title: _NOTIFICATION_CONSTANTS._M_E_S_S_A_G_E_S.ORDER_CANCELLED_TITLE,
      message: this.orderMessage(updatedOrder, "has been cancelled"),
    }).catch(() => undefined);
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
    void this.notifyOrder(kot.order, {
      type: _NOTIFICATION_CONSTANTS._T_Y_P_E_S.KOT_STATUS_UPDATED,
      title: _NOTIFICATION_CONSTANTS._M_E_S_S_A_G_E_S.KOT_STATUS_UPDATED_TITLE,
      message: this.orderMessage(kot.order, `kitchen status is ${status}`),
    }).catch(() => undefined);
    return updatedKot;
  }

  async updateOrderStatus(id: string, branchId: string, status: OrderStatus) {
    const order = await this.getOrderById(id, branchId);
    if (!order) throw new NotFoundError("Order not found");
    const updatedOrder = await posKdsRepo.updateOrderStatus(id, status);
    if (status === OrderStatus.PAID || status === OrderStatus.DELIVERED) {
      await ladyluckService.awardOrderPoints(id);
    }
    if (status === OrderStatus.REFUNDED) {
      await ladyluckService.reverseOrderPoints(id);
    }
    void this.notifyOrder(updatedOrder, {
      type: _NOTIFICATION_CONSTANTS._T_Y_P_E_S.ORDER_STATUS_UPDATED,
      title:
        _NOTIFICATION_CONSTANTS._M_E_S_S_A_G_E_S.ORDER_STATUS_UPDATED_TITLE,
      message: this.orderMessage(updatedOrder, `status is ${status}`),
    }).catch(() => undefined);
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
