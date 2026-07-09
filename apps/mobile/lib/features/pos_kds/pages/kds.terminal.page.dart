import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/di.dart';
import 'package:mobile/features/pos_kds/controllers/pos_kds.cubit.dart';
import 'package:mobile/features/pos_kds/controllers/pos_kds.state.dart';
import 'package:mobile/features/pos_kds/models/order.model.dart';
import 'package:mobile/features/pos_kds/services/table_side_label_resolver.dart';
import 'package:mobile/features/catalog/controllers/catalog.cubit.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile/components/ui/loader.dart';

class KdsTerminalPage extends StatefulWidget {
  const KdsTerminalPage({super.key});

  @override
  State<KdsTerminalPage> createState() => _KdsTerminalPageState();
}

class _KdsTerminalPageState extends State<KdsTerminalPage> {
  Timer? _pollingTimer;
  final PageController _pageController = PageController(viewportFraction: 0.9);

  String _dateFilter = 'TODAY';
  String _typeFilter = 'ALL';
  List<String> _selectedCategoryIds = [];
  bool _isCategoriesInitialized = false;
  final Set<String> _updatingOrderIds = {};
  int _pollingIntervalSeconds = 10;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
    _loadPollingInterval();
  }

  Future<void> _loadPollingInterval() async {
    final seconds = await AppDependencies.localStorage.getKdsPollingSeconds();
    if (!mounted) {
      return;
    }
    setState(() => _pollingIntervalSeconds = seconds);
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(Duration(seconds: _pollingIntervalSeconds), (
      timer,
    ) {
      _fetchOrders();
    });
  }

  void _fetchOrders() {
    context.read<PosKdsCubit>().listOrders();
  }

  String _deliveryAddress(OrderModel order) {
    final addresses = order.user?.addresses ?? const [];
    for (final address in addresses) {
      if (address.id == order.delivery_address_id) {
        final value = _addressValue([
          address.area,
          address.locality,
          address.city,
          address.state,
          address.pin_code,
        ]);
        if (value.isNotEmpty) {
          return value;
        }
      }
    }
    if (addresses.length == 1) {
      final address = addresses.first;
      return _addressValue([
        address.area,
        address.locality,
        address.city,
        address.state,
        address.pin_code,
      ]);
    }
    return '';
  }

  String _addressValue(List<String> parts) {
    return parts.where((part) => part.trim().isNotEmpty).join(', ');
  }

  String _tableDisplay(OrderModel order, PosKdsState posState) {
    final table =
        order.table ??
        posState.tables
            .where((table) => table.id == order.table_id)
            .firstOrNull;
    final tableName = table?.table_number.trim().isNotEmpty == true
        ? table!.table_number
        : '';
    final sideNames = _sideDisplay(order, table?.side_labels ?? const []);
    if (tableName.isNotEmpty && sideNames.isNotEmpty) {
      return 'Table $tableName ($sideNames)';
    }
    if (tableName.isNotEmpty) {
      return 'Table $tableName';
    }
    if (sideNames.isNotEmpty) {
      return 'Sides: $sideNames';
    }
    return '';
  }

  String _sideDisplay(OrderModel order, List<String> labels) {
    return TableSideLabelResolver.display(order);
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  bool get _hasActiveFilters =>
      _typeFilter != 'ALL' ||
      _dateFilter != 'TODAY' ||
      _selectedCategoryIds.length !=
          context.read<CatalogCubit>().state.menuCategories.length;

  void _showFilterSheet() {
    final catalogState = context.read<CatalogCubit>().state;
    final categories = catalogState.menuCategories;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
              child: SafeArea(
                child: SingleChildScrollView(
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
                            'Filters',
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
                                  _typeFilter = 'ALL';
                                  _dateFilter = 'TODAY';
                                  _selectedCategoryIds = categories
                                      .map((c) => c.id)
                                      .toList();
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

                      Text(
                        'CATEGORIES',
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
                        children: categories.map((c) {
                          return _buildCategoryChip(
                            ctx,
                            setSheetState,
                            c.name,
                            c.id,
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20.h),

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
                        children: [
                          _buildTypeChip(
                            ctx,
                            setSheetState,
                            'All',
                            'ALL',
                            Icons.all_inclusive,
                          ),
                          _buildTypeChip(
                            ctx,
                            setSheetState,
                            'Dine In',
                            'DINE_IN',
                            Icons.table_restaurant_outlined,
                          ),
                          _buildTypeChip(
                            ctx,
                            setSheetState,
                            'Takeaway',
                            'TAKEAWAY',
                            Icons.takeout_dining_outlined,
                          ),
                          _buildTypeChip(
                            ctx,
                            setSheetState,
                            'Delivery',
                            'DELIVERY',
                            Icons.delivery_dining_outlined,
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      Text(
                        'DATE',
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
                          _buildSortChip(
                            ctx,
                            setSheetState,
                            'Today',
                            'TODAY',
                            Icons.today_outlined,
                          ),
                          _buildSortChip(
                            ctx,
                            setSheetState,
                            'This week',
                            'THIS_WEEK',
                            Icons.view_week_outlined,
                          ),
                          _buildSortChip(
                            ctx,
                            setSheetState,
                            'This month',
                            'THIS_MONTH',
                            Icons.calendar_month_outlined,
                          ),
                          _buildSortChip(
                            ctx,
                            setSheetState,
                            'All time',
                            'ALL',
                            Icons.history_outlined,
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      Text(
                        'REFRESH RATE',
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
                          _buildPollingChip(
                            ctx,
                            setSheetState,
                            '10 sec',
                            10,
                            Icons.timer_10_outlined,
                          ),
                          _buildPollingChip(
                            ctx,
                            setSheetState,
                            '30 sec',
                            30,
                            Icons.timer_outlined,
                          ),
                          _buildPollingChip(
                            ctx,
                            setSheetState,
                            '1 min',
                            60,
                            Icons.timer_outlined,
                          ),
                          _buildPollingChip(
                            ctx,
                            setSheetState,
                            '5 min',
                            300,
                            Icons.timer_outlined,
                          ),
                          _buildPollingChip(
                            ctx,
                            setSheetState,
                            '10 min',
                            600,
                            Icons.timer_outlined,
                          ),
                          _buildPollingChip(
                            ctx,
                            setSheetState,
                            '15 min',
                            900,
                            Icons.timer_outlined,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    StateSetter setSheetState,
    String label,
    String categoryId,
  ) {
    final isSelected = _selectedCategoryIds.contains(categoryId);
    return GestureDetector(
      onTap: () {
        setSheetState(() {
          if (isSelected) {
            _selectedCategoryIds.remove(categoryId);
          } else {
            _selectedCategoryIds.add(categoryId);
          }
        });
        setState(() {}); // Update main UI instantly
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
              isSelected ? Icons.check : Icons.restaurant_menu,
              size: 13.w,
              color: isSelected
                  ? AppColors.primaryGreen
                  : AppColors.textSecondary,
            ),
            SizedBox(width: 5.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: isSelected
                    ? AppColors.primaryGreen
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(
    BuildContext context,
    StateSetter setSheetState,
    String label,
    String value,
    IconData icon,
  ) {
    final isSelected = _typeFilter == value;
    return GestureDetector(
      onTap: () {
        setSheetState(() {
          _typeFilter = value;
        });
        setState(() {}); // Update main UI instantly
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
              color: isSelected
                  ? AppColors.primaryGreen
                  : AppColors.textSecondary,
            ),
            SizedBox(width: 5.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: isSelected
                    ? AppColors.primaryGreen
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortChip(
    BuildContext context,
    StateSetter setSheetState,
    String label,
    String value,
    IconData icon,
  ) {
    final isSelected = _dateFilter == value;
    return GestureDetector(
      onTap: () {
        setSheetState(() {
          _dateFilter = value;
        });
        setState(() {}); // Update main UI instantly
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
              color: isSelected
                  ? AppColors.primaryGreen
                  : AppColors.textSecondary,
            ),
            SizedBox(width: 5.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: isSelected
                    ? AppColors.primaryGreen
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPollingChip(
    BuildContext context,
    StateSetter setSheetState,
    String label,
    int seconds,
    IconData icon,
  ) {
    final isSelected = _pollingIntervalSeconds == seconds;
    return GestureDetector(
      onTap: () {
        setState(() => _pollingIntervalSeconds = seconds);
        AppDependencies.localStorage.saveKdsPollingSeconds(seconds);
        setSheetState(() {});
        _startPolling();
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
              color: isSelected
                  ? AppColors.primaryGreen
                  : AppColors.textSecondary,
            ),
            SizedBox(width: 5.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: isSelected
                    ? AppColors.primaryGreen
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<OrderModel> _visibleOrders(List<OrderModel> orders, String statusTab) {
    return orders.where((order) {
      if (order.status.toUpperCase() != statusTab) return false;

      final typeMatches =
          _typeFilter == 'ALL' || order.order_type.toUpperCase() == _typeFilter;
      if (!typeMatches) return false;

      bool dateMatches = true;
      if (_dateFilter == 'TODAY') {
        final orderDate = DateTime.tryParse(order.created_at)?.toLocal();
        if (orderDate != null) {
          final now = DateTime.now();
          dateMatches =
              orderDate.year == now.year &&
              orderDate.month == now.month &&
              orderDate.day == now.day;
        }
      } else if (_dateFilter == 'THIS_WEEK') {
        final orderDate = DateTime.tryParse(order.created_at)?.toLocal();
        if (orderDate != null) {
          final now = DateTime.now();
          final startOfWeek = DateTime(
            now.year,
            now.month,
            now.day,
          ).subtract(Duration(days: now.weekday - 1));
          dateMatches = orderDate.isAfter(
            startOfWeek.subtract(const Duration(seconds: 1)),
          );
        }
      } else if (_dateFilter == 'THIS_MONTH') {
        final orderDate = DateTime.tryParse(order.created_at)?.toLocal();
        if (orderDate != null) {
          final now = DateTime.now();
          dateMatches =
              orderDate.year == now.year && orderDate.month == now.month;
        }
      }

      if (!dateMatches) return false;

      final orderHasItemsInCategories = order.items.any((item) {
        final categoryId = item.menu_item?.category_id;
        return _selectedCategoryIds.contains(categoryId);
      });

      return orderHasItemsInCategories;
    }).toList();
  }

  String _timeAgo(String timestamp) {
    final date = DateTime.tryParse(timestamp)?.toLocal();
    if (date == null) return timestamp;
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }

  void _updateStatus(OrderModel order, String newStatus) {
    setState(() {
      _updatingOrderIds.add(order.id);
    });
    context
        .read<PosKdsCubit>()
        .updateOrderStatus(order.id, newStatus)
        .then((_) {
          if (mounted) {
            setState(() {
              _updatingOrderIds.remove(order.id);
            });
          }
          _fetchOrders();
        })
        .catchError((error) {
          if (mounted) {
            setState(() {
              _updatingOrderIds.remove(order.id);
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final catalogState = context.watch<CatalogCubit>().state;
    final categories = catalogState.menuCategories;

    if (!_isCategoriesInitialized && categories.isNotEmpty) {
      _selectedCategoryIds = categories.map((c) => c.id).toList();
      _isCategoriesInitialized = true;
    }

    return Scaffold(
      backgroundColor: AppColors.pureWhite, // Clean white background
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          'KDS',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: AppColors.textPrimary,
              size: 24.w,
            ),
            onPressed: _showFilterSheet,
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: BlocBuilder<PosKdsCubit, PosKdsState>(
        builder: (context, state) {
          if (state.loadOrdersInfo.status == OperationStatus.loading &&
              state.orders.isEmpty) {
            return const Center(child: AppLoader(size: 24, strokeWidth: 2));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: AppColors.pureWhite,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 16.w,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Active Orders  ${state.orders.where((o) => ['OPEN', 'PREPARING'].contains(o.status)).length}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.check_circle_outline,
                      size: 16.w,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Completed  ${state.orders.where((o) => o.status == 'READY' || o.status == 'PAID').length}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  padEnds: false,
                  children: [
                    _buildKanbanColumn(
                      'New Orders',
                      'OPEN',
                      const Color(0xFFFBE4E4),
                      state.orders,
                    ),
                    _buildKanbanColumn(
                      'In Preparation',
                      'PREPARING',
                      const Color(0xFFFDF0D5),
                      state.orders,
                    ),
                    _buildKanbanColumn(
                      'Ready to Serve',
                      'READY',
                      const Color(0xFFDFF5E1),
                      state.orders,
                    ),
                    _buildKanbanColumn(
                      'Cancelled',
                      'CANCELLED',
                      const Color(0xFFE5E7EB),
                      state.orders,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildKanbanColumn(
    String title,
    String status,
    Color bgColor,
    List<OrderModel> orders,
  ) {
    final visibleOrders = _visibleOrders(orders, status);

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.h, 0, 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${visibleOrders.length}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.builder(
              itemCount: visibleOrders.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(visibleOrders[index], status);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(OrderModel order) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Order?'),
        content: Text(
          'Are you sure you want to cancel order #${order.order_no}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep Order'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _updateStatus(order, 'CANCELLED');
            },
            child: const Text(
              'Cancel Order',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order, String columnStatus) {
    final orderItems = order.items.where((item) {
      final categoryId = item.menu_item?.category_id;
      return _selectedCategoryIds.contains(categoryId);
    }).toList();

    double itemCount = 0;
    for (var item in orderItems) {
      itemCount += item.qty;
    }

    final customer = order.user;

    final posState = context.read<PosKdsCubit>().state;
    final tableDisplay = _tableDisplay(order, posState);
    final deliveryAddress = _deliveryAddress(order);

    return GestureDetector(
      onLongPress: () {
        if (columnStatus == 'OPEN' || columnStatus == 'PREPARING') {
          _showCancelDialog(order);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                border: Border(
                  bottom: BorderSide(color: AppColors.borderGrey, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '#${order.order_no.toString().padLeft(3, '0')}',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              order.order_type == 'DINE_IN'
                                  ? Icons.table_restaurant_outlined
                                  : Icons.takeout_dining_outlined,
                              size: 13.w,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '${order.order_type}  •  ${_timeAgo(order.created_at)}',
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
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      _buildInfoPill(
                        Icons.receipt_long,
                        '${orderItems.length} lines',
                      ),
                      SizedBox(width: 8.w),
                      _buildInfoPill(
                        Icons.restaurant_menu,
                        '${itemCount.toStringAsFixed(0)} qty',
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
                              : [customer.phone, customer.email]
                                    .where((item) => item.trim().isNotEmpty)
                                    .join(' • '),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildDetailLine(
                          order.order_type == 'DINE_IN'
                              ? Icons.table_restaurant_outlined
                              : Icons.location_on_outlined,
                          tableDisplay.isNotEmpty
                              ? tableDisplay
                              : 'Fulfillment',
                          deliveryAddress.isNotEmpty
                              ? deliveryAddress
                              : order.order_type,
                        ),
                      ),
                    ],
                  ),

                  if (order.notes.isNotEmpty) ...[
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade50,
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: Colors.yellow.shade200),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.sticky_note_2_outlined,
                            size: 14.w,
                            color: Colors.orange.shade800,
                          ),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              order.notes,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.orange.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (orderItems.isNotEmpty) ...[
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: orderItems.map((item) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 32.w,
                                  height: 32.w,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      color: AppColors.borderGrey,
                                    ),
                                  ),
                                  child: Text(
                                    '${item.qty.toInt()}x',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.menu_item?.display_name ??
                                            'Unknown Item',
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      if (item.notes.isNotEmpty)
                                        Container(
                                          margin: EdgeInsets.only(top: 8.h),
                                          padding: EdgeInsets.all(8.w),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFF8E1),
                                            borderRadius: BorderRadius.circular(
                                              6.r,
                                            ),
                                            border: Border.all(
                                              color: const Color(0xFFFFECB3),
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.priority_high,
                                                size: 14.w,
                                                color: const Color(0xFFF57F17),
                                              ),
                                              SizedBox(width: 6.w),
                                              Expanded(
                                                child: Text(
                                                  item.notes,
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: const Color(
                                                      0xFFF57F17,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
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

            // Footer Action Section
            if (columnStatus == 'OPEN')
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                child: ElevatedButton(
                  onPressed: _updatingOrderIds.contains(order.id)
                      ? null
                      : () => _updateStatus(order, 'PREPARING'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF9A826),
                    disabledBackgroundColor: const Color(
                      0xFFF9A826,
                    ).withOpacity(0.6),
                    foregroundColor: AppColors.pureWhite,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    elevation: 0,
                  ),
                  child: _updatingOrderIds.contains(order.id)
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'START PREP',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14.sp,
                            letterSpacing: 1.2,
                          ),
                        ),
                ),
              ),
            if (columnStatus == 'PREPARING')
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                child: ElevatedButton(
                  onPressed: _updatingOrderIds.contains(order.id)
                      ? null
                      : () => _updateStatus(order, 'READY'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    disabledBackgroundColor: AppColors.primaryGreen.withOpacity(
                      0.6,
                    ),
                    foregroundColor: AppColors.pureWhite,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    elevation: 0,
                  ),
                  child: _updatingOrderIds.contains(order.id)
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'MARK READY',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14.sp,
                            letterSpacing: 1.2,
                          ),
                        ),
                ),
              ),
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
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              if (subtitle.trim().isNotEmpty)
                Text(
                  subtitle,
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
}
