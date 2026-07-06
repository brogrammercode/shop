import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/components/ui/app_refresher.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/core/widgets/action_bottom_sheet.dart';
import 'package:mobile/features/pos_kds/constants/pos.constant.dart';
import 'package:mobile/features/pos_kds/controllers/pos_kds.cubit.dart';
import 'package:mobile/features/pos_kds/controllers/pos_kds.state.dart';
import 'package:mobile/features/pos_kds/models/order.model.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shimmer/shimmer.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final MobileScannerController _scannerController = MobileScannerController();
  String _statusFilter = 'ALL';
  String _typeFilter = 'ALL';
  String _sortMode = 'NEWEST';
  bool _isHandlingScan = false;

  @override
  void initState() {
    super.initState();
    context.read<PosKdsCubit>().listOrders();
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  String _formatAmount(double amount) {
    return '₹ ${amount.toStringAsFixed(2)}';
  }

  String _formatTime(String timeStr) {
    if (timeStr.isEmpty) return 'N/A';
    try {
      final dateTime = DateTime.parse(timeStr).toLocal();
      final hour = dateTime.hour > 12
          ? dateTime.hour - 12
          : (dateTime.hour == 0 ? 12 : dateTime.hour);
      final min = dateTime.minute.toString().padLeft(2, '0');
      final amPm = dateTime.hour >= 12 ? 'PM' : 'AM';
      final day = dateTime.day.toString().padLeft(2, '0');
      final month = dateTime.month.toString().padLeft(2, '0');
      return '$day/$month $hour:$min $amPm';
    } catch (e) {
      return timeStr;
    }
  }

  List<OrderModel> _visibleOrders(List<OrderModel> orders) {
    final filtered = orders.where((order) {
      final statusMatches =
          _statusFilter == 'ALL' || order.status.toUpperCase() == _statusFilter;
      final typeMatches =
          _typeFilter == 'ALL' || order.order_type.toUpperCase() == _typeFilter;
      return statusMatches && typeMatches;
    }).toList();

    filtered.sort((a, b) {
      switch (_sortMode) {
        case 'OLDEST':
          return _dateValue(a.created_at).compareTo(_dateValue(b.created_at));
        case 'AMOUNT_HIGH':
          return b.total_amount.compareTo(a.total_amount);
        case 'AMOUNT_LOW':
          return a.total_amount.compareTo(b.total_amount);
        case 'ORDER_NO':
          return b.order_no.compareTo(a.order_no);
        default:
          return _dateValue(b.created_at).compareTo(_dateValue(a.created_at));
      }
    });

    return filtered;
  }

  int _dateValue(String value) {
    return DateTime.tryParse(value)?.millisecondsSinceEpoch ?? 0;
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    switch (status.toUpperCase()) {
      case 'OPEN':
      case 'BILLED':
        bgColor = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
        break;
      case 'PAID':
        bgColor = const Color(0xFFE8F5E9);
        textColor = AppColors.primaryGreen;
        break;
      case 'CANCELLED':
      case 'REFUNDED':
        bgColor = const Color(0xFFFFF5F5);
        textColor = const Color(0xFFEF4F5F);
        break;
      default:
        bgColor = AppColors.softGrey;
        textColor = AppColors.textSecondary;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w800,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: 5,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 176.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(
                color: AppColors.pureWhite,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.chevron_left,
                color: AppColors.textPrimary,
                size: 24.w,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  PosConstant.ORDER_LIST_TITLE,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Scan, filter, sort, and manage orders',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showFilterSheet(),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: const BoxDecoration(
                    color: AppColors.pureWhite,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowColor,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: _hasActiveFilters ? AppColors.primaryGreen : AppColors.textPrimary,
                    size: 20.w,
                  ),
                ),
                if (_hasActiveFilters)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: _showQrScanner,
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(
                color: AppColors.pureWhite,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.qr_code_scanner,
                color: AppColors.textPrimary,
                size: 20.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(List<OrderModel> orders) {
    final paid = orders.where((order) => order.status == 'PAID').length;
    final open = orders.where((order) => order.status == 'OPEN').length;
    final total = orders.fold<double>(
      0,
      (sum, order) => sum + order.total_amount,
    );
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildSummaryItem('Orders', orders.length.toString()),
          _buildSummaryDivider(),
          _buildSummaryItem('Open', open.toString()),
          _buildSummaryDivider(),
          _buildSummaryItem('Paid', paid.toString()),
          _buildSummaryDivider(),
          _buildSummaryItem('Sales', _formatAmount(total)),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textTertiary,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryDivider() {
    return Container(
      width: 1.w,
      height: 32.h,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      color: AppColors.borderGrey,
    );
  }

  bool get _hasActiveFilters =>
      _statusFilter != 'ALL' || _typeFilter != 'ALL' || _sortMode != 'NEWEST';

  IconData _orderTypeIcon(String orderType) {
    switch (orderType.toUpperCase()) {
      case 'DINE_IN':
        return Icons.table_restaurant_outlined;
      case 'TAKEAWAY':
        return Icons.takeout_dining_outlined;
      case 'DELIVERY':
        return Icons.delivery_dining_outlined;
      case 'AGGREGATOR':
        return Icons.app_shortcut_outlined;
      case 'PRE_ORDER':
        return Icons.schedule_outlined;
      default:
        return Icons.shopping_bag_outlined;
    }
  }


  void _showFilterSheet() {
    final orders = context.read<PosKdsCubit>().state.orders;
    final statuses = ['ALL', ...orders.map((o) => o.status).toSet()];
    final types = ['ALL', ...orders.map((o) => o.order_type).toSet()];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: AppColors.borderGrey,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filters & Sort',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (_hasActiveFilters)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _statusFilter = 'ALL';
                              _typeFilter = 'ALL';
                              _sortMode = 'NEWEST';
                            });
                            setSheetState(() {});
                          },
                          child: Text(
                            'Reset',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  // Status filter
                  Text(
                    'ORDER STATUS',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textTertiary,
                      letterSpacing: 0.8,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: statuses.map((status) {
                      final isSelected = _statusFilter == status.toUpperCase();
                      return GestureDetector(
                        onTap: () {
                          setState(() => _statusFilter = status.toUpperCase());
                          setSheetState(() {});
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFE8F5E9) : AppColors.pureWhite,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: isSelected ? AppColors.primaryGreen : AppColors.borderGrey,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.flag_outlined,
                                size: 13.w,
                                color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                status,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected ? AppColors.primaryGreen : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20.h),
                  // Order type filter
                  Text(
                    'ORDER TYPE',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textTertiary,
                      letterSpacing: 0.8,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: types.map((type) {
                      final isSelected = _typeFilter == type.toUpperCase();
                      return GestureDetector(
                        onTap: () {
                          setState(() => _typeFilter = type.toUpperCase());
                          setSheetState(() {});
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFE8F5E9) : AppColors.pureWhite,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: isSelected ? AppColors.primaryGreen : AppColors.borderGrey,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _orderTypeIcon(type),
                                size: 13.w,
                                color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                type,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected ? AppColors.primaryGreen : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20.h),
                  // Sort
                  Text(
                    'SORT BY',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textTertiary,
                      letterSpacing: 0.8,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      _buildSortChip(ctx, setSheetState, 'Newest first', 'NEWEST', Icons.arrow_downward_rounded),
                      _buildSortChip(ctx, setSheetState, 'Oldest first', 'OLDEST', Icons.arrow_upward_rounded),
                      _buildSortChip(ctx, setSheetState, 'Highest total', 'AMOUNT_HIGH', Icons.trending_up),
                      _buildSortChip(ctx, setSheetState, 'Lowest total', 'AMOUNT_LOW', Icons.trending_down),
                      _buildSortChip(ctx, setSheetState, 'Order number', 'ORDER_NO', Icons.tag),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSortChip(
    BuildContext ctx,
    StateSetter setSheetState,
    String label,
    String value,
    IconData icon,
  ) {
    final isSelected = _sortMode == value;
    return GestureDetector(
      onTap: () {
        setState(() => _sortMode = value);
        setSheetState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5E9) : AppColors.pureWhite,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.borderGrey,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13.w,
              color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary,
            ),
            SizedBox(width: 5.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: isSelected ? AppColors.primaryGreen : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    final itemCount = order.items.fold<double>(
      0,
      (sum, item) => sum + item.qty,
    );
    final finalPaying = order.final_paying_price > 0
        ? order.final_paying_price
        : order.total_amount;
    final customer = order.user;
    return GestureDetector(
      onTap: () => _openOrder(order),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.borderGrey),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '#${order.order_no}',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          _buildStatusBadge(order.status),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            _orderTypeIcon(order.order_type),
                            size: 13.w,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${order.order_type}  •  ${_formatTime(order.created_at)}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _showOrderActions(order),
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: const BoxDecoration(
                      color: AppColors.pureWhite,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowColor,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.more_vert,
                      color: AppColors.textPrimary,
                      size: 18.w,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                _buildInfoPill(
                  Icons.receipt_long,
                  '${order.items.length} lines',
                ),
                SizedBox(width: 8.w),
                _buildInfoPill(
                  Icons.restaurant_menu,
                  '${itemCount.toStringAsFixed(0)} qty',
                ),
                SizedBox(width: 8.w),
                _buildInfoPill(
                  Icons.payments_outlined,
                  _formatAmount(finalPaying),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Container(height: 1.h, color: AppColors.borderGrey),
            SizedBox(height: 12.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildDetailLine(
                    Icons.person_outline,
                    customer == null || customer.name.isEmpty
                        ? 'Walk-in customer'
                        : customer.name,
                    customer == null
                        ? 'No linked customer'
                        : [
                            customer.phone,
                            customer.email,
                          ].where((item) => item.trim().isNotEmpty).join(' • '),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildDetailLine(
                    order.order_type == 'DINE_IN'
                        ? Icons.table_restaurant_outlined
                        : Icons.location_on_outlined,
                    order.table_id.isNotEmpty
                        ? 'Table ${order.table_id}'
                        : 'Fulfillment',
                    order.delivery_address_id.isNotEmpty
                        ? order.delivery_address_id
                        : order.order_type,
                  ),
                ),
              ],
            ),
            if (order.items.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  children: order.items.take(3).map((item) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 6.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.menu_item?.display_name ??
                                  'Item ${item.menu_item_id}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            '${item.qty.toStringAsFixed(0)} × ${_formatAmount(item.unit_price)}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPill(IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Row(
          children: [
            Icon(icon, size: 13.w, color: AppColors.primaryGreen),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailLine(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16.w, color: AppColors.textSecondary),
        SizedBox(width: 6.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              if (subtitle.trim().isNotEmpty)
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _openOrder(OrderModel order) {
    context.read<PosKdsCubit>().getOrder(order.id);
    Navigator.pushNamed(context, AppRoutes.orderDetail);
  }

  // _showSortSheet replaced by _showFilterSheet (accessed from filter icon)



  void _showOrderActions(OrderModel order) {
    ActionBottomSheet.show(
      context,
      topActions: [
        BottomSheetTopAction(
          label: 'Open',
          icon: Icons.open_in_new,
          onTap: () => _openOrder(order),
        ),
        BottomSheetTopAction(
          label: 'Print',
          icon: Icons.print_outlined,
          onTap: () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Printing receipt...'))),
        ),
      ],
      groups: [
        BottomSheetActionGroup(
          actions: [
            BottomSheetAction(
              label: 'Mark paid with cash',
              icon: Icons.payments_outlined,
              iconColor: AppColors.primaryGreen,
              onTap: () async {
                await context.read<PosKdsCubit>().payOrder(order.id, {
                  'payment_method': 'CASH',
                  'amount': order.final_paying_price > 0
                      ? order.final_paying_price
                      : order.total_amount,
                });
                if (mounted) {
                  context.read<PosKdsCubit>().listOrders();
                }
              },
            ),
            BottomSheetAction(
              label: 'Cancel order',
              icon: Icons.cancel_outlined,
              iconColor: const Color(0xFFEF4F5F),
              labelColor: const Color(0xFFEF4F5F),
              onTap: () async {
                await context.read<PosKdsCubit>().cancelOrder(order.id);
                if (mounted) {
                  context.read<PosKdsCubit>().listOrders();
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  void _showQrScanner() {
    _isHandlingScan = false;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.72,
          decoration: BoxDecoration(
            color: AppColors.pureWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            children: [
              SizedBox(height: 12.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.borderGrey,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      color: AppColors.primaryGreen,
                      size: 24.w,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'Scan receipt QR',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        color: AppColors.textSecondary,
                        size: 22.w,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18.r),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        MobileScanner(
                          controller: _scannerController,
                          onDetect: _handleScan,
                        ),
                        Center(
                          child: Container(
                            width: 230.w,
                            height: 230.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18.r),
                              border: Border.all(
                                color: AppColors.pureWhite,
                                width: 2.w,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16.w,
                          right: 16.w,
                          bottom: 16.h,
                          child: Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.55),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              'Align the receipt QR inside the frame',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.pureWhite,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleScan(BarcodeCapture capture) async {
    if (_isHandlingScan) {
      return;
    }
    String? raw;
    for (final barcode in capture.barcodes) {
      if (barcode.rawValue != null && barcode.rawValue!.trim().isNotEmpty) {
        raw = barcode.rawValue;
        break;
      }
    }
    final orderId = _extractOrderId(raw);
    if (orderId == null) {
      return;
    }
    _isHandlingScan = true;
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    await context.read<PosKdsCubit>().getOrder(orderId);
    if (mounted) {
      Navigator.pushNamed(context, AppRoutes.orderDetail);
    }
  }

  String? _extractOrderId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final trimmed = value.trim();
    final uri = Uri.tryParse(trimmed);
    final segments = uri?.pathSegments ?? const [];
    if (segments.isNotEmpty && segments.contains('orders')) {
      return segments.last;
    }
    if (!trimmed.contains('/') && trimmed.length > 6) {
      return trimmed;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: BlocBuilder<PosKdsCubit, PosKdsState>(
                builder: (context, state) {
                  if (state.loadOrdersInfo.status == OperationStatus.loading) {
                    return _buildShimmerList();
                  }
                  final orders = state.orders;
                  final visibleOrders = _visibleOrders(orders);
                  if (orders.isEmpty) {
                    return Center(
                      child: Text(
                        'No orders found',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    );
                  }
                  return AppRefresher(
                    onRefresh: () async {
                      context.read<PosKdsCubit>().listOrders();
                    },
                    child: ListView.separated(
                      padding: EdgeInsets.only(bottom: 24.h),
                      itemCount: visibleOrders.length + 2,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: index < 2 ? 0 : 12.h),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return _buildSummary(orders);
                        }
                        if (index == 1) {
                          return const SizedBox.shrink();
                        }
                        final order = visibleOrders[index - 2];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: _buildOrderCard(order),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
