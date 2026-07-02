import 'package:mobile/services/api_client.dart';
import 'package:mobile/utils/try_catch.dart';
import 'package:mobile/features/inventory/supplier.model.dart';
import 'package:mobile/features/inventory/item_category.model.dart';
import 'package:mobile/features/inventory/item.model.dart';
import 'package:mobile/features/inventory/unit_of_measure.model.dart';
import 'package:mobile/features/inventory/u_o_m_conversion.model.dart';
import 'package:mobile/features/inventory/item_variant.model.dart';
import 'package:mobile/features/inventory/purchase_order.model.dart';
import 'package:mobile/features/inventory/goods_receipt.model.dart';
import 'package:mobile/features/inventory/vendor_return.model.dart';
import 'package:mobile/features/inventory/stock_ledger.model.dart';
import 'package:mobile/features/inventory/stock_transfer.model.dart';

class InventoryEndpoints {
  static const String suppliers = '/inventory/suppliers';
  static String supplier(String id) => '/inventory/suppliers/$id';
  static const String itemCategories = '/inventory/item-categories';
  static const String items = '/inventory/items';
  static String item(String id) => '/inventory/items/$id';
  static String itemVariants(String itemId) => '/inventory/items/$itemId/variants';
  static String variant(String id) => '/inventory/variants/$id';
  static const String uom = '/inventory/uom';
  static const String uomConversions = '/inventory/uom-conversions';
  static const String purchaseOrders = '/inventory/purchase-orders';
  static String purchaseOrder(String id) => '/inventory/purchase-orders/$id';
  static String sendPO(String id) => '/inventory/purchase-orders/$id/send';
  static String receivePO(String id) => '/inventory/purchase-orders/$id/receive';
  static String poReceipts(String id) => '/inventory/purchase-orders/$id/receipts';
  static String poReturns(String id) => '/inventory/purchase-orders/$id/returns';
  static String poReturn(String id, String returnId) => '/inventory/purchase-orders/$id/returns/$returnId';
  static const String stock = '/inventory/stock';
  static const String stockLedger = '/inventory/stock-ledger';
  static const String usage = '/inventory/usage';
  static const String wastage = '/inventory/wastage';
  static const String stockTransfers = '/inventory/stock-transfers';
  static String stockTransfer(String id) => '/inventory/stock-transfers/$id';
  static String receiveTransfer(String id) => '/inventory/stock-transfers/$id/receive';
}

class InventoryRepo {
  final ApiClient _apiClient;

  InventoryRepo({required ApiClient apiClient}) : _apiClient = apiClient;

  TaskResult<List<SupplierModel>> listSuppliers() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(InventoryEndpoints.suppliers);
      final data = response.data['data'] as List;
      return data.map((e) => SupplierModel.fromJson(e)).toList();
    });
  }

  TaskResult<SupplierModel> createSupplier(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(InventoryEndpoints.suppliers, data: data);
      return SupplierModel.fromJson(response.data['data']);
    });
  }

  TaskResult<SupplierModel> updateSupplier(String id, Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.patch(InventoryEndpoints.supplier(id), data: data);
      return SupplierModel.fromJson(response.data['data']);
    });
  }

  TaskResult<dynamic> deleteSupplier(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.delete(InventoryEndpoints.supplier(id));
      return response.data['data'];
    });
  }

  TaskResult<List<ItemCategoryModel>> listItemCategories() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(InventoryEndpoints.itemCategories);
      final data = response.data['data'] as List;
      return data.map((e) => ItemCategoryModel.fromJson(e)).toList();
    });
  }

  TaskResult<ItemCategoryModel> createItemCategory(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(InventoryEndpoints.itemCategories, data: data);
      return ItemCategoryModel.fromJson(response.data['data']);
    });
  }

  TaskResult<List<ItemModel>> listItems() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(InventoryEndpoints.items);
      final data = response.data['data'] as List;
      return data.map((e) => ItemModel.fromJson(e)).toList();
    });
  }

  TaskResult<ItemModel> createItem(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(InventoryEndpoints.items, data: data);
      return ItemModel.fromJson(response.data['data']);
    });
  }

  TaskResult<ItemModel> updateItem(String id, Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.patch(InventoryEndpoints.item(id), data: data);
      return ItemModel.fromJson(response.data['data']);
    });
  }

  TaskResult<dynamic> deleteItem(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.delete(InventoryEndpoints.item(id));
      return response.data['data'];
    });
  }

  TaskResult<List<ItemVariantModel>> listVariants(String itemId) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(InventoryEndpoints.itemVariants(itemId));
      final data = response.data['data'] as List;
      return data.map((e) => ItemVariantModel.fromJson(e)).toList();
    });
  }

  TaskResult<ItemVariantModel> createVariant(String itemId, Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(InventoryEndpoints.itemVariants(itemId), data: data);
      return ItemVariantModel.fromJson(response.data['data']);
    });
  }

  TaskResult<ItemVariantModel> updateVariant(String id, Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.patch(InventoryEndpoints.variant(id), data: data);
      return ItemVariantModel.fromJson(response.data['data']);
    });
  }

  TaskResult<List<UnitOfMeasureModel>> listUOMs() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(InventoryEndpoints.uom);
      final data = response.data['data'] as List;
      return data.map((e) => UnitOfMeasureModel.fromJson(e)).toList();
    });
  }

  TaskResult<UnitOfMeasureModel> createUOM(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(InventoryEndpoints.uom, data: data);
      return UnitOfMeasureModel.fromJson(response.data['data']);
    });
  }

  TaskResult<List<UOMConversionModel>> listUOMConversions() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(InventoryEndpoints.uomConversions);
      final data = response.data['data'] as List;
      return data.map((e) => UOMConversionModel.fromJson(e)).toList();
    });
  }

  TaskResult<UOMConversionModel> createUOMConversion(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(InventoryEndpoints.uomConversions, data: data);
      return UOMConversionModel.fromJson(response.data['data']);
    });
  }

  TaskResult<List<PurchaseOrderModel>> listPurchaseOrders() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(InventoryEndpoints.purchaseOrders);
      final data = response.data['data'] as List;
      return data.map((e) => PurchaseOrderModel.fromJson(e)).toList();
    });
  }

  TaskResult<PurchaseOrderModel> createPurchaseOrder(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(InventoryEndpoints.purchaseOrders, data: data);
      return PurchaseOrderModel.fromJson(response.data['data']);
    });
  }

  TaskResult<PurchaseOrderModel> getPurchaseOrder(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(InventoryEndpoints.purchaseOrder(id));
      return PurchaseOrderModel.fromJson(response.data['data']);
    });
  }

  TaskResult<dynamic> sendPurchaseOrder(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.patch(InventoryEndpoints.sendPO(id));
      return response.data['data'];
    });
  }

  TaskResult<GoodsReceiptModel> receivePurchaseOrder(String id, Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(InventoryEndpoints.receivePO(id), data: data);
      return GoodsReceiptModel.fromJson(response.data['data']);
    });
  }

  TaskResult<List<GoodsReceiptModel>> listReceipts(String poId) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(InventoryEndpoints.poReceipts(poId));
      final data = response.data['data'] as List;
      return data.map((e) => GoodsReceiptModel.fromJson(e)).toList();
    });
  }

  TaskResult<VendorReturnModel> createVendorReturn(String poId, Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(InventoryEndpoints.poReturns(poId), data: data);
      return VendorReturnModel.fromJson(response.data['data']);
    });
  }

  TaskResult<List<VendorReturnModel>> listVendorReturns(String poId) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(InventoryEndpoints.poReturns(poId));
      final data = response.data['data'] as List;
      return data.map((e) => VendorReturnModel.fromJson(e)).toList();
    });
  }

  TaskResult<VendorReturnModel> updateVendorReturn(String poId, String returnId, Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.patch(InventoryEndpoints.poReturn(poId, returnId), data: data);
      return VendorReturnModel.fromJson(response.data['data']);
    });
  }

  TaskResult<List<dynamic>> getStockLevels() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(InventoryEndpoints.stock);
      return response.data['data'] as List;
    });
  }

  TaskResult<List<StockLedgerModel>> getStockLedger() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(InventoryEndpoints.stockLedger);
      final data = response.data['data'] as List;
      return data.map((e) => StockLedgerModel.fromJson(e)).toList();
    });
  }

  TaskResult<StockLedgerModel> logUsage(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(InventoryEndpoints.usage, data: data);
      return StockLedgerModel.fromJson(response.data['data']);
    });
  }

  TaskResult<StockLedgerModel> logWastage(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(InventoryEndpoints.wastage, data: data);
      return StockLedgerModel.fromJson(response.data['data']);
    });
  }

  TaskResult<List<StockTransferModel>> listStockTransfers() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(InventoryEndpoints.stockTransfers);
      final data = response.data['data'] as List;
      return data.map((e) => StockTransferModel.fromJson(e)).toList();
    });
  }

  TaskResult<StockTransferModel> createStockTransfer(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(InventoryEndpoints.stockTransfers, data: data);
      return StockTransferModel.fromJson(response.data['data']);
    });
  }

  TaskResult<StockTransferModel> getStockTransfer(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(InventoryEndpoints.stockTransfer(id));
      return StockTransferModel.fromJson(response.data['data']);
    });
  }

  TaskResult<StockTransferModel> receiveStockTransfer(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.patch(InventoryEndpoints.receiveTransfer(id));
      return StockTransferModel.fromJson(response.data['data']);
    });
  }
}
