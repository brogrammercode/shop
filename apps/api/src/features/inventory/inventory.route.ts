import { Router } from 'express';
import { _INVENTORY_CONSTANTS } from './inventory.constant';
import * as inventoryController from './inventory.controller';
import { authenticate, requireInventoryAccess } from './inventory.middleware';

const router = Router();

router.use(authenticate, requireInventoryAccess);

router.get(_INVENTORY_CONSTANTS._R_O_U_T_E_S._S_U_P_P_L_I_E_R_S, inventoryController.listSuppliers);
router.post(_INVENTORY_CONSTANTS._R_O_U_T_E_S._S_U_P_P_L_I_E_R_S, inventoryController.createSupplier);
router.get(_INVENTORY_CONSTANTS._R_O_U_T_E_S.SUPPLIER_BY_ID, inventoryController.getSupplierById);
router.patch(_INVENTORY_CONSTANTS._R_O_U_T_E_S.SUPPLIER_BY_ID, inventoryController.updateSupplier);
router.delete(_INVENTORY_CONSTANTS._R_O_U_T_E_S.SUPPLIER_BY_ID, inventoryController.deleteSupplier);

router.get(_INVENTORY_CONSTANTS._R_O_U_T_E_S.ITEM_CATEGORIES, inventoryController.listItemCategories);
router.post(_INVENTORY_CONSTANTS._R_O_U_T_E_S.ITEM_CATEGORIES, inventoryController.createItemCategory);

router.get(_INVENTORY_CONSTANTS._R_O_U_T_E_S._I_T_E_M_S, inventoryController.listItems);
router.post(_INVENTORY_CONSTANTS._R_O_U_T_E_S._I_T_E_M_S, inventoryController.createItem);
router.get(_INVENTORY_CONSTANTS._R_O_U_T_E_S.ITEM_BY_ID, inventoryController.getItemById);
router.patch(_INVENTORY_CONSTANTS._R_O_U_T_E_S.ITEM_BY_ID, inventoryController.updateItem);
router.delete(_INVENTORY_CONSTANTS._R_O_U_T_E_S.ITEM_BY_ID, inventoryController.deleteItem);

router.get(_INVENTORY_CONSTANTS._R_O_U_T_E_S.ITEM_VARIANTS, inventoryController.listVariantsByItem);
router.post(_INVENTORY_CONSTANTS._R_O_U_T_E_S.ITEM_VARIANTS, inventoryController.createItemVariant);
router.get(_INVENTORY_CONSTANTS._R_O_U_T_E_S.VARIANT_BY_ID, inventoryController.getVariantById);
router.patch(_INVENTORY_CONSTANTS._R_O_U_T_E_S.VARIANT_BY_ID, inventoryController.updateVariant);

router.get(_INVENTORY_CONSTANTS._R_O_U_T_E_S._U_O_M, inventoryController.listUOMs);
router.post(_INVENTORY_CONSTANTS._R_O_U_T_E_S._U_O_M, inventoryController.createUOM);

router.get(_INVENTORY_CONSTANTS._R_O_U_T_E_S.UOM_CONVERSIONS, inventoryController.listUOMConversions);
router.post(_INVENTORY_CONSTANTS._R_O_U_T_E_S.UOM_CONVERSIONS, inventoryController.createUOMConversion);

router.get(_INVENTORY_CONSTANTS._R_O_U_T_E_S.PURCHASE_ORDERS, inventoryController.listPurchaseOrders);
router.post(_INVENTORY_CONSTANTS._R_O_U_T_E_S.PURCHASE_ORDERS, inventoryController.createPurchaseOrder);
router.get(_INVENTORY_CONSTANTS._R_O_U_T_E_S.PURCHASE_ORDER_BY_ID, inventoryController.getPurchaseOrderById);
router.patch(_INVENTORY_CONSTANTS._R_O_U_T_E_S.PURCHASE_ORDER_SEND, inventoryController.sendPurchaseOrder);
router.post(_INVENTORY_CONSTANTS._R_O_U_T_E_S.PURCHASE_ORDER_RECEIVE, inventoryController.receivePurchaseOrder);
router.get(_INVENTORY_CONSTANTS._R_O_U_T_E_S.PURCHASE_ORDER_RECEIPTS, inventoryController.listReceiptsByPO);
router.post(_INVENTORY_CONSTANTS._R_O_U_T_E_S.PURCHASE_ORDER_RETURNS, inventoryController.createVendorReturn);
router.get(_INVENTORY_CONSTANTS._R_O_U_T_E_S.PURCHASE_ORDER_RETURNS, inventoryController.listReturnsByPO);
router.patch(_INVENTORY_CONSTANTS._R_O_U_T_E_S.PURCHASE_ORDER_RETURN_BY_ID, inventoryController.updateVendorReturn);

router.get(_INVENTORY_CONSTANTS._R_O_U_T_E_S._S_T_O_C_K, inventoryController.getStockLevels);
router.get(_INVENTORY_CONSTANTS._R_O_U_T_E_S.STOCK_LEDGER, inventoryController.getStockLedger);
router.post(_INVENTORY_CONSTANTS._R_O_U_T_E_S._U_S_A_G_E, inventoryController.logUsage);
router.post(_INVENTORY_CONSTANTS._R_O_U_T_E_S._W_A_S_T_A_G_E, inventoryController.logWastage);

router.get(_INVENTORY_CONSTANTS._R_O_U_T_E_S.STOCK_TRANSFERS, inventoryController.listStockTransfers);
router.post(_INVENTORY_CONSTANTS._R_O_U_T_E_S.STOCK_TRANSFERS, inventoryController.createStockTransfer);
router.get(_INVENTORY_CONSTANTS._R_O_U_T_E_S.STOCK_TRANSFER_BY_ID, inventoryController.getStockTransferById);
router.patch(_INVENTORY_CONSTANTS._R_O_U_T_E_S.STOCK_TRANSFER_RECEIVE, inventoryController.receiveStockTransfer);

export default router;
