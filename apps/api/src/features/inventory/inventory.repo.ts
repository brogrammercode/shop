import { POStatus, ReturnStatus, StockTransType, TransferStatus, ItemType } from '@prisma/client';
import prisma from '../../infra/database/client';

export class InventoryRepo {
  async createSupplier(data: { branch_id: string; name: string; avatar?: string; tax_number?: string; contact_email?: string; contact_phone?: string }) {
    return prisma.supplier.create({ data });
  }

  async findSuppliersByBranch(branchId: string) {
    return prisma.supplier.findMany({ where: { branch_id: branchId, is_deleted: false } });
  }

  async findSupplierById(id: string) {
    return prisma.supplier.findUnique({ where: { id } });
  }

  async updateSupplier(id: string, data: Partial<{ name: string; avatar: string; tax_number: string; contact_email: string; contact_phone: string }>) {
    return prisma.supplier.update({ where: { id }, data });
  }

  async deleteSupplier(id: string) {
    return prisma.supplier.update({ where: { id }, data: { is_deleted: true } });
  }

  async createItemCategory(data: { branch_id: string; name: string; description?: string }) {
    return prisma.itemCategory.create({ data });
  }

  async findItemCategoriesByBranch(branchId: string) {
    return prisma.itemCategory.findMany({ where: { branch_id: branchId, is_deleted: false } });
  }

  async createItem(data: { branch_id: string; category_id: string; name: string; item_type: ItemType; shelf_life_days?: number }) {
    return prisma.item.create({ data });
  }

  async findItemsByBranch(branchId: string) {
    return prisma.item.findMany({ where: { branch_id: branchId, is_deleted: false }, include: { category: true } });
  }

  async findItemById(id: string) {
    return prisma.item.findUnique({ where: { id } });
  }

  async updateItem(id: string, data: Partial<{ category_id: string; name: string; item_type: ItemType; shelf_life_days: number }>) {
    return prisma.item.update({ where: { id }, data });
  }

  async deleteItem(id: string) {
    return prisma.item.update({ where: { id }, data: { is_deleted: true } });
  }

  async createUOM(data: { branch_id: string; code: string; description?: string }) {
    return prisma.unitOfMeasure.create({ data });
  }

  async findUOMsByBranch(branchId: string) {
    return prisma.unitOfMeasure.findMany({ where: { branch_id: branchId, is_deleted: false } });
  }

  async createUOMConversion(data: { branch_id: string; from_uom_id: string; to_uom_id: string; factor: number }) {
    return prisma.uOMConversion.create({ data });
  }

  async findUOMConversionsByBranch(branchId: string) {
    return prisma.uOMConversion.findMany({ where: { branch_id: branchId }, include: { from_uom: true, to_uom: true } });
  }

  async createItemVariant(data: { branch_id: string; item_id: string; uom_id: string; sku: string; barcode?: string; base_cost: number; min_stock_lvl: number }) {
    return prisma.itemVariant.create({ data });
  }

  async findVariantsByItem(itemId: string) {
    return prisma.itemVariant.findMany({ where: { item_id: itemId, is_deleted: false }, include: { uom: true } });
  }

  async findVariantById(id: string) {
    return prisma.itemVariant.findUnique({ where: { id } });
  }

  async updateVariant(id: string, data: Partial<{ uom_id: string; sku: string; barcode: string; base_cost: number; min_stock_lvl: number }>) {
    return prisma.itemVariant.update({ where: { id }, data });
  }

  async createPurchaseOrder(data: { branch_id: string; supplier_id: string; created_by: string; total_amount: number; notes?: string }) {
    return prisma.purchaseOrder.create({ data });
  }

  async findPOsByBranch(branchId: string) {
    return prisma.purchaseOrder.findMany({ where: { branch_id: branchId }, include: { supplier: true }, orderBy: { created_at: 'desc' } });
  }

  async findPOById(id: string) {
    return prisma.purchaseOrder.findUnique({ where: { id }, include: { items: true, supplier: true } });
  }

  async updatePOStatus(id: string, status: POStatus, approvedBy?: string) {
    return prisma.purchaseOrder.update({ where: { id }, data: { status, approved_by: approvedBy } });
  }

  async createPOItems(items: { po_id: string; variant_id: string; qty_ordered: number; unit_price: number; total_price: number }[]) {
    return prisma.pOItem.createMany({ data: items });
  }

  async createGoodsReceipt(data: { branch_id: string; po_id: string; received_by: string; invoice_number?: string; notes?: string }) {
    return prisma.goodsReceipt.create({ data });
  }

  async findReceiptsByPO(poId: string) {
    return prisma.goodsReceipt.findMany({ where: { po_id: poId } });
  }

  async createVendorReturn(data: { branch_id: string; po_id: string; return_reason: string; refund_value: number; processed_by: string }) {
    return prisma.vendorReturn.create({ data });
  }

  async findReturnsByPO(poId: string) {
    return prisma.vendorReturn.findMany({ where: { po_id: poId } });
  }

  async updateVendorReturnStatus(id: string, status: ReturnStatus) {
    return prisma.vendorReturn.update({ where: { id }, data: { status } });
  }

  async createStockEntry(data: { branch_id: string; variant_id: string; transaction_type: StockTransType; quantity_change: number; running_balance: number; reference_id?: string; created_by?: string }) {
    return prisma.stockLedger.create({ data });
  }

  async findStockEntriesByBranch(branchId: string) {
    return prisma.stockLedger.findMany({ where: { branch_id: branchId }, orderBy: { created_at: 'desc' }, take: 100 });
  }

  async getLastStockEntryForVariant(variantId: string) {
    return prisma.stockLedger.findFirst({ where: { variant_id: variantId }, orderBy: { created_at: 'desc' } });
  }

  async getStockLevels(branchId: string) {
    const variants = await prisma.itemVariant.findMany({ where: { branch_id: branchId, is_deleted: false }, include: { item: true, uom: true } });
    const stockLevels = await Promise.all(
      variants.map(async (v) => {
        const lastEntry = await this.getLastStockEntryForVariant(v.id);
        return { variant: v, balance: lastEntry?.running_balance || 0 };
      })
    );
    return stockLevels;
  }

  async createStockTransfer(data: { from_branch_id: string; to_branch_id: string; dispatched_by: string; driver_name?: string }) {
    return prisma.stockTransfer.create({ data });
  }

  async findTransfersByBranch(branchId: string) {
    return prisma.stockTransfer.findMany({
      where: { OR: [{ from_branch_id: branchId }, { to_branch_id: branchId }] },
      include: { from_branch: true, to_branch: true },
      orderBy: { created_at: 'desc' },
    });
  }

  async findTransferById(id: string) {
    return prisma.stockTransfer.findUnique({ where: { id }, include: { items: true } });
  }

  async updateTransferStatus(id: string, status: TransferStatus, receivedBy?: string) {
    return prisma.stockTransfer.update({ where: { id }, data: { status, received_by: receivedBy } });
  }

  async createTransferItems(items: { transfer_id: string; variant_id: string; quantity: number }[]) {
    return prisma.transferItem.createMany({ data: items });
  }
}

export const inventoryRepo = new InventoryRepo();
