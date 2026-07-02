import { inventoryRepo } from './inventory.repo';
import { _INVENTORY_CONSTANTS } from './inventory.constant';
import { AppError, NotFoundError, BadRequestError } from '../../utils/error';
import { HttpStatus } from '../../constants/status';
import { ItemType, StockTransType } from '@prisma/client';

export class InventoryService {
  async createSupplier(branchId: string, name: string, avatar?: string, tax_number?: string, contact_email?: string, contact_phone?: string) {
    return inventoryRepo.createSupplier({ branch_id: branchId, name, avatar, tax_number, contact_email, contact_phone });
  }

  async listSuppliers(branchId: string) {
    return inventoryRepo.findSuppliersByBranch(branchId);
  }

  async getSupplierById(id: string, branchId: string) {
    const supplier = await inventoryRepo.findSupplierById(id);
    if (!supplier || supplier.branch_id !== branchId) {
      throw new NotFoundError(_INVENTORY_CONSTANTS._E_R_R_O_R_S.SUPPLIER_NOT_FOUND);
    }
    return supplier;
  }

  async updateSupplier(id: string, branchId: string, data: any) {
    await this.getSupplierById(id, branchId);
    return inventoryRepo.updateSupplier(id, data);
  }

  async deleteSupplier(id: string, branchId: string) {
    await this.getSupplierById(id, branchId);
    return inventoryRepo.deleteSupplier(id);
  }

  async createItemCategory(branchId: string, name: string, description?: string) {
    return inventoryRepo.createItemCategory({ branch_id: branchId, name, description });
  }

  async listItemCategories(branchId: string) {
    return inventoryRepo.findItemCategoriesByBranch(branchId);
  }

  async createItem(branchId: string, category_id: string, name: string, item_type: ItemType, shelf_life_days?: number) {
    return inventoryRepo.createItem({ branch_id: branchId, category_id, name, item_type, shelf_life_days });
  }

  async listItems(branchId: string) {
    return inventoryRepo.findItemsByBranch(branchId);
  }

  async getItemById(id: string, branchId: string) {
    const item = await inventoryRepo.findItemById(id);
    if (!item || item.branch_id !== branchId) {
      throw new NotFoundError(_INVENTORY_CONSTANTS._E_R_R_O_R_S.ITEM_NOT_FOUND);
    }
    return item;
  }

  async updateItem(id: string, branchId: string, data: any) {
    await this.getItemById(id, branchId);
    return inventoryRepo.updateItem(id, data);
  }

  async deleteItem(id: string, branchId: string) {
    await this.getItemById(id, branchId);
    return inventoryRepo.deleteItem(id);
  }

  async createUOM(branchId: string, code: string, description?: string) {
    return inventoryRepo.createUOM({ branch_id: branchId, code, description });
  }

  async listUOMs(branchId: string) {
    return inventoryRepo.findUOMsByBranch(branchId);
  }

  async createUOMConversion(branchId: string, from_uom_id: string, to_uom_id: string, factor: number) {
    return inventoryRepo.createUOMConversion({ branch_id: branchId, from_uom_id, to_uom_id, factor });
  }

  async listUOMConversions(branchId: string) {
    return inventoryRepo.findUOMConversionsByBranch(branchId);
  }

  async createItemVariant(branchId: string, item_id: string, uom_id: string, sku: string, barcode: string | undefined, base_cost: number, min_stock_lvl: number) {
    return inventoryRepo.createItemVariant({ branch_id: branchId, item_id, uom_id, sku, barcode, base_cost, min_stock_lvl });
  }

  async listVariantsByItem(itemId: string, branchId: string) {
    await this.getItemById(itemId, branchId);
    return inventoryRepo.findVariantsByItem(itemId);
  }

  async getVariantById(id: string, branchId: string) {
    const variant = await inventoryRepo.findVariantById(id);
    if (!variant || variant.branch_id !== branchId) {
      throw new NotFoundError(_INVENTORY_CONSTANTS._E_R_R_O_R_S.VARIANT_NOT_FOUND);
    }
    return variant;
  }

  async updateVariant(id: string, branchId: string, data: any) {
    await this.getVariantById(id, branchId);
    return inventoryRepo.updateVariant(id, data);
  }

  async createPurchaseOrder(branchId: string, supplier_id: string, created_by: string, items: { variant_id: string; qty_ordered: number; unit_price: number }[], notes?: string) {
    let totalAmount = 0;
    const poItems = items.map(item => {
      const totalPrice = item.qty_ordered * item.unit_price;
      totalAmount += totalPrice;
      return { ...item, total_price: totalPrice };
    });

    const po = await inventoryRepo.createPurchaseOrder({ branch_id: branchId, supplier_id, created_by, total_amount: totalAmount, notes });
    
    await inventoryRepo.createPOItems(poItems.map(item => ({ ...item, po_id: po.id })));
    
    return this.getPurchaseOrderById(po.id, branchId);
  }

  async listPurchaseOrders(branchId: string) {
    return inventoryRepo.findPOsByBranch(branchId);
  }

  async getPurchaseOrderById(id: string, branchId: string) {
    const po = await inventoryRepo.findPOById(id);
    if (!po || po.branch_id !== branchId) {
      throw new NotFoundError(_INVENTORY_CONSTANTS._E_R_R_O_R_S.PO_NOT_FOUND);
    }
    return po;
  }

  async sendPurchaseOrder(id: string, branchId: string) {
    const po = await this.getPurchaseOrderById(id, branchId);
    if (po.status !== 'DRAFT') {
      throw new BadRequestError(_INVENTORY_CONSTANTS._E_R_R_O_R_S.INVALID_STATUS);
    }
    return inventoryRepo.updatePOStatus(id, 'SENT');
  }

  async receivePurchaseOrder(id: string, branchId: string, received_by: string, invoice_number?: string, notes?: string) {
    const po = await this.getPurchaseOrderById(id, branchId);
    if (po.status !== 'SENT' && po.status !== 'PARTIALLY_RECEIVED') {
      throw new BadRequestError(_INVENTORY_CONSTANTS._E_R_R_O_R_S.INVALID_STATUS);
    }

    const receipt = await inventoryRepo.createGoodsReceipt({ branch_id: branchId, po_id: id, received_by, invoice_number, notes });

    // Update stock for all items
    for (const item of po.items) {
      const lastEntry = await inventoryRepo.getLastStockEntryForVariant(item.variant_id);
      const currentBalance = lastEntry?.running_balance || 0;
      await inventoryRepo.createStockEntry({
        branch_id: branchId,
        variant_id: item.variant_id,
        transaction_type: 'PURCHASE',
        quantity_change: item.qty_ordered,
        running_balance: currentBalance + item.qty_ordered,
        reference_id: receipt.id,
        created_by: received_by,
      });
    }

    await inventoryRepo.updatePOStatus(id, 'RECEIVED');
    return receipt;
  }

  async listReceiptsByPO(poId: string, branchId: string) {
    await this.getPurchaseOrderById(poId, branchId);
    return inventoryRepo.findReceiptsByPO(poId);
  }

  async createVendorReturn(branchId: string, po_id: string, return_reason: string, refund_value: number, processed_by: string) {
    const po = await this.getPurchaseOrderById(po_id, branchId);
    const vendorReturn = await inventoryRepo.createVendorReturn({ branch_id: branchId, po_id, return_reason, refund_value, processed_by });
    
    // In a real scenario, we'd specify which items were returned. Here we just log the return entry for simplicity.
    return vendorReturn;
  }

  async listReturnsByPO(poId: string, branchId: string) {
    await this.getPurchaseOrderById(poId, branchId);
    return inventoryRepo.findReturnsByPO(poId);
  }

  async updateVendorReturn(id: string, branchId: string, status: any) {
    return inventoryRepo.updateVendorReturnStatus(id, status);
  }

  async getStockLevels(branchId: string) {
    return inventoryRepo.getStockLevels(branchId);
  }

  async getStockLedger(branchId: string) {
    return inventoryRepo.findStockEntriesByBranch(branchId);
  }

  async logUsage(branchId: string, variant_id: string, quantity: number, employee_id: string, reference_id?: string) {
    const lastEntry = await inventoryRepo.getLastStockEntryForVariant(variant_id);
    const currentBalance = lastEntry?.running_balance || 0;
    
    if (currentBalance < quantity) {
      throw new BadRequestError(_INVENTORY_CONSTANTS._E_R_R_O_R_S.INSUFFICIENT_STOCK);
    }

    return inventoryRepo.createStockEntry({
      branch_id: branchId,
      variant_id,
      transaction_type: 'PRODUCTION_OUT',
      quantity_change: -quantity,
      running_balance: currentBalance - quantity,
      reference_id,
      created_by: employee_id,
    });
  }

  async logWastage(branchId: string, variant_id: string, quantity: number, reason: string, employee_id: string) {
    const lastEntry = await inventoryRepo.getLastStockEntryForVariant(variant_id);
    const currentBalance = lastEntry?.running_balance || 0;
    
    if (currentBalance < quantity) {
      throw new BadRequestError(_INVENTORY_CONSTANTS._E_R_R_O_R_S.INSUFFICIENT_STOCK);
    }

    return inventoryRepo.createStockEntry({
      branch_id: branchId,
      variant_id,
      transaction_type: 'WASTAGE',
      quantity_change: -quantity,
      running_balance: currentBalance - quantity,
      reference_id: reason,
      created_by: employee_id,
    });
  }

  async createStockTransfer(fromBranchId: string, toBranchId: string, items: { variant_id: string; quantity: number }[], dispatched_by: string, driver_name?: string) {
    // Deduct stock from source branch
    for (const item of items) {
      const lastEntry = await inventoryRepo.getLastStockEntryForVariant(item.variant_id);
      const currentBalance = lastEntry?.running_balance || 0;
      if (currentBalance < item.quantity) {
        throw new BadRequestError(_INVENTORY_CONSTANTS._E_R_R_O_R_S.INSUFFICIENT_STOCK);
      }
    }

    const transfer = await inventoryRepo.createStockTransfer({ from_branch_id: fromBranchId, to_branch_id: toBranchId, dispatched_by, driver_name });
    await inventoryRepo.createTransferItems(items.map(i => ({ ...i, transfer_id: transfer.id })));

    for (const item of items) {
      const lastEntry = await inventoryRepo.getLastStockEntryForVariant(item.variant_id);
      const currentBalance = lastEntry?.running_balance || 0;
      await inventoryRepo.createStockEntry({
        branch_id: fromBranchId,
        variant_id: item.variant_id,
        transaction_type: 'TRANSFER_OUT',
        quantity_change: -item.quantity,
        running_balance: currentBalance - item.quantity,
        reference_id: transfer.id,
        created_by: dispatched_by,
      });
    }

    return this.getStockTransferById(transfer.id, fromBranchId);
  }

  async listStockTransfers(branchId: string) {
    return inventoryRepo.findTransfersByBranch(branchId);
  }

  async getStockTransferById(id: string, branchId: string) {
    const transfer = await inventoryRepo.findTransferById(id);
    if (!transfer || (transfer.from_branch_id !== branchId && transfer.to_branch_id !== branchId)) {
      throw new NotFoundError(_INVENTORY_CONSTANTS._E_R_R_O_R_S.TRANSFER_NOT_FOUND);
    }
    return transfer;
  }

  async receiveStockTransfer(id: string, branchId: string, received_by: string) {
    const transfer = await this.getStockTransferById(id, branchId);
    if (transfer.to_branch_id !== branchId) {
      throw new BadRequestError('Only destination branch can receive transfer');
    }
    if (transfer.status !== 'DISPATCHED') {
      throw new BadRequestError(_INVENTORY_CONSTANTS._E_R_R_O_R_S.INVALID_STATUS);
    }

    await inventoryRepo.updateTransferStatus(id, 'RECEIVED', received_by);

    for (const item of transfer.items) {
      const lastEntry = await inventoryRepo.getLastStockEntryForVariant(item.variant_id);
      const currentBalance = lastEntry?.running_balance || 0;
      await inventoryRepo.createStockEntry({
        branch_id: branchId,
        variant_id: item.variant_id,
        transaction_type: 'TRANSFER_IN',
        quantity_change: item.quantity,
        running_balance: currentBalance + item.quantity,
        reference_id: transfer.id,
        created_by: received_by,
      });
    }

    return this.getStockTransferById(id, branchId);
  }
}

export const inventoryService = new InventoryService();
