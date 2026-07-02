import 'package:mobile/utils/error.dart';
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

class InventoryState {
  final List<SupplierModel> suppliers;
  final List<ItemCategoryModel> itemCategories;
  final List<ItemModel> items;
  final List<UnitOfMeasureModel> uoms;
  final List<UOMConversionModel> uomConversions;
  final List<ItemVariantModel> variants;
  final List<PurchaseOrderModel> purchaseOrders;
  final PurchaseOrderModel? selectedPO;
  final List<GoodsReceiptModel> poReceipts;
  final List<VendorReturnModel> poReturns;
  final List<dynamic> stockLevels;
  final List<StockLedgerModel> stockLedger;
  final List<StockTransferModel> stockTransfers;
  final StockTransferModel? selectedTransfer;

  final OperationInfo loadSuppliersInfo;
  final OperationInfo saveSuppliersInfo;
  final OperationInfo loadItemsInfo;
  final OperationInfo saveItemsInfo;
  final OperationInfo loadVariantsInfo;
  final OperationInfo saveVariantsInfo;
  final OperationInfo loadPOInfo;
  final OperationInfo savePOInfo;
  final OperationInfo receiveInfo;
  final OperationInfo returnInfo;
  final OperationInfo stockInfo;
  final OperationInfo usageInfo;
  final OperationInfo wastageInfo;
  final OperationInfo transferInfo;
  final OperationInfo loadTransferInfo;

  const InventoryState({
    this.suppliers = const [],
    this.itemCategories = const [],
    this.items = const [],
    this.uoms = const [],
    this.uomConversions = const [],
    this.variants = const [],
    this.purchaseOrders = const [],
    this.selectedPO,
    this.poReceipts = const [],
    this.poReturns = const [],
    this.stockLevels = const [],
    this.stockLedger = const [],
    this.stockTransfers = const [],
    this.selectedTransfer,
    this.loadSuppliersInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveSuppliersInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadItemsInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveItemsInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadVariantsInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveVariantsInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadPOInfo = const OperationInfo(status: OperationStatus.initial),
    this.savePOInfo = const OperationInfo(status: OperationStatus.initial),
    this.receiveInfo = const OperationInfo(status: OperationStatus.initial),
    this.returnInfo = const OperationInfo(status: OperationStatus.initial),
    this.stockInfo = const OperationInfo(status: OperationStatus.initial),
    this.usageInfo = const OperationInfo(status: OperationStatus.initial),
    this.wastageInfo = const OperationInfo(status: OperationStatus.initial),
    this.transferInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadTransferInfo = const OperationInfo(status: OperationStatus.initial),
  });

  InventoryState copyWith({
    List<SupplierModel>? suppliers,
    List<ItemCategoryModel>? itemCategories,
    List<ItemModel>? items,
    List<UnitOfMeasureModel>? uoms,
    List<UOMConversionModel>? uomConversions,
    List<ItemVariantModel>? variants,
    List<PurchaseOrderModel>? purchaseOrders,
    PurchaseOrderModel? selectedPO,
    List<GoodsReceiptModel>? poReceipts,
    List<VendorReturnModel>? poReturns,
    List<dynamic>? stockLevels,
    List<StockLedgerModel>? stockLedger,
    List<StockTransferModel>? stockTransfers,
    StockTransferModel? selectedTransfer,
    OperationInfo? loadSuppliersInfo,
    OperationInfo? saveSuppliersInfo,
    OperationInfo? loadItemsInfo,
    OperationInfo? saveItemsInfo,
    OperationInfo? loadVariantsInfo,
    OperationInfo? saveVariantsInfo,
    OperationInfo? loadPOInfo,
    OperationInfo? savePOInfo,
    OperationInfo? receiveInfo,
    OperationInfo? returnInfo,
    OperationInfo? stockInfo,
    OperationInfo? usageInfo,
    OperationInfo? wastageInfo,
    OperationInfo? transferInfo,
    OperationInfo? loadTransferInfo,
  }) {
    return InventoryState(
      suppliers: suppliers ?? this.suppliers,
      itemCategories: itemCategories ?? this.itemCategories,
      items: items ?? this.items,
      uoms: uoms ?? this.uoms,
      uomConversions: uomConversions ?? this.uomConversions,
      variants: variants ?? this.variants,
      purchaseOrders: purchaseOrders ?? this.purchaseOrders,
      selectedPO: selectedPO ?? this.selectedPO,
      poReceipts: poReceipts ?? this.poReceipts,
      poReturns: poReturns ?? this.poReturns,
      stockLevels: stockLevels ?? this.stockLevels,
      stockLedger: stockLedger ?? this.stockLedger,
      stockTransfers: stockTransfers ?? this.stockTransfers,
      selectedTransfer: selectedTransfer ?? this.selectedTransfer,
      loadSuppliersInfo: loadSuppliersInfo ?? this.loadSuppliersInfo,
      saveSuppliersInfo: saveSuppliersInfo ?? this.saveSuppliersInfo,
      loadItemsInfo: loadItemsInfo ?? this.loadItemsInfo,
      saveItemsInfo: saveItemsInfo ?? this.saveItemsInfo,
      loadVariantsInfo: loadVariantsInfo ?? this.loadVariantsInfo,
      saveVariantsInfo: saveVariantsInfo ?? this.saveVariantsInfo,
      loadPOInfo: loadPOInfo ?? this.loadPOInfo,
      savePOInfo: savePOInfo ?? this.savePOInfo,
      receiveInfo: receiveInfo ?? this.receiveInfo,
      returnInfo: returnInfo ?? this.returnInfo,
      stockInfo: stockInfo ?? this.stockInfo,
      usageInfo: usageInfo ?? this.usageInfo,
      wastageInfo: wastageInfo ?? this.wastageInfo,
      transferInfo: transferInfo ?? this.transferInfo,
      loadTransferInfo: loadTransferInfo ?? this.loadTransferInfo,
    );
  }
}
