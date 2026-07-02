import 'package:flutter/material.dart';
import 'package:mobile/features/core_hr/pages/auth.page.dart';
import 'package:mobile/features/core_hr/pages/home.layout.page.dart';
import 'package:mobile/features/core_hr/pages/crossroad.page.dart';
import 'package:mobile/features/core_hr/pages/join.branch.page.dart';
import 'package:mobile/features/core_hr/pages/create.branch.page.dart';
import 'package:mobile/features/core_hr/pages/branch.detail.page.dart';

import 'package:mobile/features/inventory/supplier.list.page.dart';
import 'package:mobile/features/inventory/create.supplier.page.dart';
import 'package:mobile/features/inventory/supplier.detail.page.dart';
import 'package:mobile/features/inventory/purchase.order.list.page.dart';
import 'package:mobile/features/inventory/create.po.page.dart';
import 'package:mobile/features/inventory/purchase.order.detail.page.dart';
import 'package:mobile/features/inventory/goods.receipt.form.page.dart';
import 'package:mobile/features/inventory/vendor.return.form.page.dart';

import 'package:mobile/features/catalog/item.list.page.dart';
import 'package:mobile/features/catalog/create.item.page.dart';
import 'package:mobile/features/catalog/item.detail.page.dart';
import 'package:mobile/features/catalog/create.variant.page.dart';
import 'package:mobile/features/catalog/variant.detail.page.dart';
import 'package:mobile/features/catalog/category.list.page.dart';
import 'package:mobile/features/catalog/create.category.page.dart';
import 'package:mobile/features/catalog/uom.list.page.dart';
import 'package:mobile/features/catalog/create.uom.page.dart';

import 'package:mobile/features/inventory/stock_ledger.list.page.dart';
import 'package:mobile/features/inventory/stock_transfer.list.page.dart';
import 'package:mobile/features/inventory/create.stock_transfer.page.dart';
import 'package:mobile/features/inventory/stock_transfer.detail.page.dart';

import 'package:mobile/features/manufacturing/bom.list.page.dart';
import 'package:mobile/features/manufacturing/create.bom.page.dart';
import 'package:mobile/features/manufacturing/bom.detail.page.dart';
import 'package:mobile/features/manufacturing/production_batch.list.page.dart';
import 'package:mobile/features/manufacturing/create.production_batch.page.dart';
import 'package:mobile/features/manufacturing/production_batch.detail.page.dart';
import 'package:mobile/features/manufacturing/qc_audit.form.page.dart';
import 'package:mobile/features/manufacturing/wastage_log.form.page.dart';

import 'package:mobile/features/pos_kds/table_zone.list.page.dart';
import 'package:mobile/features/pos_kds/table.list.page.dart';
import 'package:mobile/features/pos_kds/pos.terminal.page.dart';
import 'package:mobile/features/pos_kds/order.list.page.dart';
import 'package:mobile/features/pos_kds/order.detail.page.dart';
import 'package:mobile/features/pos_kds/advance_payment.form.page.dart';
import 'package:mobile/features/pos_kds/delivery_partner.list.page.dart';
import 'package:mobile/features/pos_kds/kds.terminal.page.dart';

import 'package:mobile/features/core_hr/pages/employee.list.page.dart';
import 'package:mobile/features/core_hr/pages/employee.detail.page.dart';
import 'package:mobile/features/core_hr/pages/employee.form.page.dart';
import 'package:mobile/features/core_hr/pages/department.list.page.dart';
import 'package:mobile/features/core_hr/pages/role.list.page.dart';
import 'package:mobile/features/core_hr/pages/post.list.page.dart';
import 'package:mobile/features/core_hr/pages/shift.list.page.dart';
import 'package:mobile/features/core_hr/pages/time_log.list.page.dart';
import 'package:mobile/features/core_hr/pages/cash_register.list.page.dart';
import 'package:mobile/features/core_hr/pages/cash_register.detail.page.dart';
import 'package:mobile/features/core_hr/pages/user_log.list.page.dart';

import 'package:mobile/features/core_hr/pages/department.form.page.dart';
import 'package:mobile/features/core_hr/pages/role.form.page.dart';
import 'package:mobile/features/core_hr/pages/post.form.page.dart';
import 'package:mobile/features/core_hr/pages/shift.form.page.dart';
import 'package:mobile/features/core_hr/pages/cash_register.form.page.dart';

import 'package:mobile/features/finance/finance.dashboard.page.dart';
import 'package:mobile/features/finance/account.list.page.dart';
import 'package:mobile/features/finance/account.detail.page.dart';
import 'package:mobile/features/finance/account.form.page.dart';
import 'package:mobile/features/finance/ledger.list.page.dart';
import 'package:mobile/features/finance/ledger.form.page.dart';
import 'package:mobile/features/finance/fixed_asset.list.page.dart';
import 'package:mobile/features/finance/fixed_asset.detail.page.dart';
import 'package:mobile/features/finance/fixed_asset.form.page.dart';
import 'package:mobile/features/finance/royalty.list.page.dart';
import 'package:mobile/features/finance/royalty.detail.page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String crossRoad = '/crossroad';
  static const String joinBranchForm = '/join-branch-form';
  static const String createBranch = '/create-branch';
  static const String branchDetail = '/branch-detail';

  // Procurement Routes
  static const String supplierList = '/supplier-list';
  static const String createSupplier = '/create-supplier';
  static const String supplierDetail = '/supplier-detail';
  static const String poList = '/po-list';
  static const String createPo = '/create-po';
  static const String poDetail = '/po-detail';
  static const String grnForm = '/grn-form';
  static const String vendorReturnForm = '/vendor-return-form';

  // Catalog Routes
  static const String itemList = '/item-list';
  static const String createItem = '/create-item';
  static const String itemDetail = '/item-detail';
  static const String createVariant = '/create-variant';
  static const String variantDetail = '/variant-detail';
  static const String categoryList = '/category-list';
  static const String createCategory = '/create-category';
  static const String uomList = '/uom-list';
  static const String createUom = '/create-uom';

  // Production & Inventory Routes
  static const String stockLedger = '/stock-ledger';
  static const String stockTransferList = '/stock-transfer-list';
  static const String createStockTransfer = '/create-stock-transfer';
  static const String stockTransferDetail = '/stock-transfer-detail';
  static const String bomList = '/bom-list';
  static const String createBom = '/create-bom';
  static const String bomDetail = '/bom-detail';
  static const String batchList = '/production-batch-list';
  static const String createBatch = '/create-production-batch';
  static const String batchDetail = '/production-batch-detail';
  static const String qcAuditForm = '/qc-audit-form';
  static const String wastageForm = '/wastage-log-form';

  // POS & KDS Routes
  static const String tableZoneList = '/table-zone-list';
  static const String tableList = '/table-list';
  static const String posTerminal = '/pos-terminal';
  static const String orderList = '/order-list';
  static const String orderDetail = '/order-detail';
  static const String advancePayment = '/advance-payment';
  static const String deliveryPartnerList = '/delivery-partner-list';
  static const String kdsTerminal = '/kds-terminal';

  // Core HR Routes
  static const String employeeList = '/employee-list';
  static const String employeeDetail = '/employee-detail';
  static const String employeeForm = '/employee-form';
  static const String departmentList = '/department-list';

  static const String departmentForm = '/department-form';
  static const String roleForm = '/role-form';
  static const String postForm = '/post-form';
  static const String shiftForm = '/shift-form';
  static const String cashRegisterForm = '/cash-register-form';

  // Finance Routes
  static const String financeDashboard = '/finance-dashboard';
  static const String financeAccountList = '/finance-account-list';
  static const String financeAccountDetail = '/finance-account-detail';
  static const String financeAccountForm = '/finance-account-form';
  static const String financeLedgerList = '/finance-ledger-list';
  static const String financeLedgerForm = '/finance-ledger-form';
  static const String financeAssetList = '/finance-asset-list';
  static const String financeAssetDetail = '/finance-asset-detail';
  static const String financeAssetForm = '/finance-asset-form';
  static const String financeRoyaltyList = '/finance-royalty-list';
  static const String financeRoyaltyDetail = '/finance-royalty-detail';

  static const String roleList = '/role-list';
  static const String postList = '/post-list';
  static const String shiftList = '/shift-list';
  static const String timeLogList = '/time-log-list';
  static const String cashRegisterList = '/cash-register-list';
  static const String cashRegisterDetail = '/cash-register-detail';
  static const String userLogList = '/user-log-list';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const AuthPage(),
    home: (context) => const HomeLayoutPage(),
    crossRoad: (context) => const CrossRoadPage(),
    joinBranchForm: (context) => const JoinBranchPage(),
    createBranch: (context) => const CreateBranchPage(),
    branchDetail: (context) => const BranchDetailPage(),

    // Procurement
    supplierList: (context) => const SupplierListPage(),
    createSupplier: (context) => const CreateSupplierPage(),
    supplierDetail: (context) => const SupplierDetailPage(),
    poList: (context) => const PurchaseOrderListPage(),
    createPo: (context) => const CreatePoPage(),
    poDetail: (context) => const PurchaseOrderDetailPage(),
    grnForm: (context) => const GoodsReceiptFormPage(),
    vendorReturnForm: (context) => const VendorReturnFormPage(),

    // Catalog
    itemList: (context) => const ItemListPage(),
    createItem: (context) => const CreateItemPage(),
    itemDetail: (context) => const ItemDetailPage(),
    createVariant: (context) => const CreateVariantPage(),
    variantDetail: (context) => const VariantDetailPage(),
    categoryList: (context) => const CategoryListPage(),
    createCategory: (context) => const CreateCategoryPage(),
    uomList: (context) => const UomListPage(),
    createUom: (context) => const CreateUomPage(),

    // Production & Inventory
    stockLedger: (context) => const StockLedgerListPage(),
    stockTransferList: (context) => const StockTransferListPage(),
    createStockTransfer: (context) => const CreateStockTransferPage(),
    stockTransferDetail: (context) => const StockTransferDetailPage(),
    bomList: (context) => const BomListPage(),
    createBom: (context) => const CreateBomPage(),
    bomDetail: (context) => const BomDetailPage(),
    batchList: (context) => const ProductionBatchListPage(),
    createBatch: (context) => const CreateProductionBatchPage(),
    batchDetail: (context) => const ProductionBatchDetailPage(),
    qcAuditForm: (context) => const QcAuditFormPage(),
    wastageForm: (context) => const WastageLogFormPage(),

    // POS & KDS
    tableZoneList: (context) => const TableZoneListPage(),
    tableList: (context) => const TableListPage(),
    posTerminal: (context) => const PosTerminalPage(),
    orderList: (context) => const OrderListPage(),
    orderDetail: (context) => const OrderDetailPage(),
    advancePayment: (context) => const AdvancePaymentFormPage(),
    deliveryPartnerList: (context) => const DeliveryPartnerListPage(),
    kdsTerminal: (context) => const KdsTerminalPage(),

    // Core HR
    employeeList: (context) => const EmployeeListPage(),
    employeeDetail: (context) => const EmployeeDetailPage(),
    employeeForm: (context) => const EmployeeFormPage(),
    departmentList: (context) => const DepartmentListPage(),

    departmentForm: (context) => const DepartmentFormPage(),
    roleForm: (context) => const RoleFormPage(),
    postForm: (context) => const PostFormPage(),
    shiftForm: (context) => const ShiftFormPage(),
    cashRegisterForm: (context) => const CashRegisterFormPage(),

    // Finance
    financeDashboard: (context) => const FinanceDashboardPage(),
    financeAccountList: (context) => const AccountListPage(),
    financeAccountDetail: (context) => const AccountDetailPage(),
    financeAccountForm: (context) => const AccountFormPage(),
    financeLedgerList: (context) => const LedgerListPage(),
    financeLedgerForm: (context) => const LedgerFormPage(),
    financeAssetList: (context) => const FixedAssetListPage(),
    financeAssetDetail: (context) => const FixedAssetDetailPage(),
    financeAssetForm: (context) => const FixedAssetFormPage(),
    financeRoyaltyList: (context) => const RoyaltyListPage(),
    financeRoyaltyDetail: (context) => const RoyaltyDetailPage(),

    roleList: (context) => const RoleListPage(),
    postList: (context) => const PostListPage(),
    shiftList: (context) => const ShiftListPage(),
    timeLogList: (context) => const TimeLogListPage(),
    cashRegisterList: (context) => const CashRegisterListPage(),
    cashRegisterDetail: (context) => const CashRegisterDetailPage(),
    userLogList: (context) => const UserLogListPage(),
  };
}
