import { Request, Response } from 'express';
import { asyncHandler } from '../../utils/async';
import { sendSuccess } from '../../utils/error';
import { HttpStatus } from '../../constants/status';
import { inventoryService } from './inventory.service';
import { _INVENTORY_CONSTANTS } from './inventory.constant';

export const listSuppliers = asyncHandler(async (req: Request, res: Response) => {
  const result = await inventoryService.listSuppliers(req.employee.branch_id);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.SUPPLIERS_LISTED, HttpStatus.OK);
});

export const createSupplier = asyncHandler(async (req: Request, res: Response) => {
  const { name, avatar, tax_number, contact_email, contact_phone } = req.body;
  const result = await inventoryService.createSupplier(req.employee.branch_id, name, avatar, tax_number, contact_email, contact_phone);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.SUPPLIER_CREATED, HttpStatus.CREATED);
});

export const getSupplierById = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await inventoryService.getSupplierById(id, req.employee.branch_id);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.SUPPLIERS_LISTED, HttpStatus.OK);
});

export const updateSupplier = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await inventoryService.updateSupplier(id, req.employee.branch_id, req.body);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.SUPPLIER_UPDATED, HttpStatus.OK);
});

export const deleteSupplier = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await inventoryService.deleteSupplier(id, req.employee.branch_id);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.SUPPLIER_DELETED, HttpStatus.OK);
});

export const listItemCategories = asyncHandler(async (req: Request, res: Response) => {
  const result = await inventoryService.listItemCategories(req.employee.branch_id);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.ITEM_CATEGORIES_LISTED, HttpStatus.OK);
});

export const createItemCategory = asyncHandler(async (req: Request, res: Response) => {
  const { name, description } = req.body;
  const result = await inventoryService.createItemCategory(req.employee.branch_id, name, description);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.ITEM_CATEGORY_CREATED, HttpStatus.CREATED);
});

export const listItems = asyncHandler(async (req: Request, res: Response) => {
  const result = await inventoryService.listItems(req.employee.branch_id);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.ITEMS_LISTED, HttpStatus.OK);
});

export const createItem = asyncHandler(async (req: Request, res: Response) => {
  const { category_id, name, item_type, shelf_life_days } = req.body;
  const result = await inventoryService.createItem(req.employee.branch_id, category_id, name, item_type, shelf_life_days);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.ITEM_CREATED, HttpStatus.CREATED);
});

export const getItemById = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await inventoryService.getItemById(id, req.employee.branch_id);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.ITEMS_LISTED, HttpStatus.OK);
});

export const updateItem = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await inventoryService.updateItem(id, req.employee.branch_id, req.body);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.ITEM_UPDATED, HttpStatus.OK);
});

export const deleteItem = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await inventoryService.deleteItem(id, req.employee.branch_id);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.ITEM_DELETED, HttpStatus.OK);
});

export const listUOMs = asyncHandler(async (req: Request, res: Response) => {
  const result = await inventoryService.listUOMs(req.employee.branch_id);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.UOMS_LISTED, HttpStatus.OK);
});

export const createUOM = asyncHandler(async (req: Request, res: Response) => {
  const { code, description } = req.body;
  const result = await inventoryService.createUOM(req.employee.branch_id, code, description);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.UOM_CREATED, HttpStatus.CREATED);
});

export const listUOMConversions = asyncHandler(async (req: Request, res: Response) => {
  const result = await inventoryService.listUOMConversions(req.employee.branch_id);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.UOM_CONVERSIONS_LISTED, HttpStatus.OK);
});

export const createUOMConversion = asyncHandler(async (req: Request, res: Response) => {
  const { from_uom_id, to_uom_id, factor } = req.body;
  const result = await inventoryService.createUOMConversion(req.employee.branch_id, from_uom_id, to_uom_id, factor);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.UOM_CONVERSION_CREATED, HttpStatus.CREATED);
});

export const listVariantsByItem = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await inventoryService.listVariantsByItem(id, req.employee.branch_id);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.VARIANTS_LISTED, HttpStatus.OK);
});

export const createItemVariant = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const { uom_id, sku, barcode, base_cost, min_stock_lvl } = req.body;
  const result = await inventoryService.createItemVariant(req.employee.branch_id, id, uom_id, sku, barcode, base_cost, min_stock_lvl);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.VARIANT_CREATED, HttpStatus.CREATED);
});

export const getVariantById = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await inventoryService.getVariantById(id, req.employee.branch_id);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.VARIANTS_LISTED, HttpStatus.OK);
});

export const updateVariant = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await inventoryService.updateVariant(id, req.employee.branch_id, req.body);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.VARIANT_UPDATED, HttpStatus.OK);
});

export const listPurchaseOrders = asyncHandler(async (req: Request, res: Response) => {
  const result = await inventoryService.listPurchaseOrders(req.employee.branch_id);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.POS_LISTED, HttpStatus.OK);
});

export const createPurchaseOrder = asyncHandler(async (req: Request, res: Response) => {
  const { supplier_id, items, notes } = req.body;
  const result = await inventoryService.createPurchaseOrder(req.employee.branch_id, supplier_id, req.employee.id, items, notes);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.PO_CREATED, HttpStatus.CREATED);
});

export const getPurchaseOrderById = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await inventoryService.getPurchaseOrderById(id, req.employee.branch_id);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.POS_LISTED, HttpStatus.OK);
});

export const sendPurchaseOrder = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await inventoryService.sendPurchaseOrder(id, req.employee.branch_id);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.PO_SENT, HttpStatus.OK);
});

export const receivePurchaseOrder = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const { invoice_number, notes } = req.body;
  const result = await inventoryService.receivePurchaseOrder(id, req.employee.branch_id, req.employee.id, invoice_number, notes);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.PO_RECEIVED, HttpStatus.OK);
});

export const listReceiptsByPO = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await inventoryService.listReceiptsByPO(id, req.employee.branch_id);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.RECEIPTS_LISTED, HttpStatus.OK);
});

export const createVendorReturn = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const { return_reason, refund_value } = req.body;
  const result = await inventoryService.createVendorReturn(req.employee.branch_id, id, return_reason, refund_value, req.employee.id);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.RETURN_CREATED, HttpStatus.CREATED);
});

export const listReturnsByPO = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await inventoryService.listReturnsByPO(id, req.employee.branch_id);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.RETURNS_LISTED, HttpStatus.OK);
});

export const updateVendorReturn = asyncHandler(async (req: Request, res: Response) => {
  const { returnId } = req.params as Record<string, string>;
  const { status } = req.body;
  const result = await inventoryService.updateVendorReturn(returnId, req.employee.branch_id, status);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.RETURN_UPDATED, HttpStatus.OK);
});

export const getStockLevels = asyncHandler(async (req: Request, res: Response) => {
  const result = await inventoryService.getStockLevels(req.employee.branch_id);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.STOCK_LEVELS_FETCHED, HttpStatus.OK);
});

export const getStockLedger = asyncHandler(async (req: Request, res: Response) => {
  const result = await inventoryService.getStockLedger(req.employee.branch_id);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.STOCK_LEDGER_FETCHED, HttpStatus.OK);
});

export const logUsage = asyncHandler(async (req: Request, res: Response) => {
  const { variant_id, quantity, reference_id } = req.body;
  const result = await inventoryService.logUsage(req.employee.branch_id, variant_id, quantity, req.employee.id, reference_id);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.USAGE_LOGGED, HttpStatus.CREATED);
});

export const logWastage = asyncHandler(async (req: Request, res: Response) => {
  const { variant_id, quantity, reason } = req.body;
  const result = await inventoryService.logWastage(req.employee.branch_id, variant_id, quantity, reason, req.employee.id);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.WASTAGE_LOGGED, HttpStatus.CREATED);
});

export const listStockTransfers = asyncHandler(async (req: Request, res: Response) => {
  const result = await inventoryService.listStockTransfers(req.employee.branch_id);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.TRANSFERS_LISTED, HttpStatus.OK);
});

export const createStockTransfer = asyncHandler(async (req: Request, res: Response) => {
  const { to_branch_id, items, driver_name } = req.body;
  const result = await inventoryService.createStockTransfer(req.employee.branch_id, to_branch_id, items, req.employee.id, driver_name);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.TRANSFER_CREATED, HttpStatus.CREATED);
});

export const getStockTransferById = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await inventoryService.getStockTransferById(id, req.employee.branch_id);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.TRANSFERS_LISTED, HttpStatus.OK);
});

export const receiveStockTransfer = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await inventoryService.receiveStockTransfer(id, req.employee.branch_id, req.employee.id);
  return sendSuccess(res, result, _INVENTORY_CONSTANTS._M_E_S_S_A_G_E_S.TRANSFER_RECEIVED, HttpStatus.OK);
});
