import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/features/pos_kds/constants/pos.constant.dart';
import 'package:mobile/utils/error.dart';

import 'package:mobile/features/catalog/controllers/catalog.cubit.dart';
import 'package:mobile/features/catalog/controllers/catalog.state.dart';
import 'package:mobile/features/core_hr/models/address.model.dart';
import 'package:mobile/features/crm/crm.cubit.dart';
import 'package:mobile/features/crm/crm.state.dart';
import '../controllers/pos_kds.cubit.dart';
import '../controllers/pos_kds.state.dart';
import 'dart:async';
import 'package:mobile/features/pos_kds/models/order.model.dart';
import 'package:mobile/features/pos_kds/models/ladyluck.model.dart';

class PosCartPage extends StatefulWidget {
  const PosCartPage({super.key});

  @override
  State<PosCartPage> createState() => _PosCartPageState();
}

class _PosCartPageState extends State<PosCartPage> {
  String _selectedOrderType = 'DINE_IN';
  String? _selectedTableId;
  final List<String> _selectedTableSideIds = [];
  final Set<String> _expandedTableIds = {};
  String? _selectedCustomerId;
  String? _selectedAddressId;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _orderNotesController = TextEditingController();
  Timer? _debounce;
  String? _customerName;

  @override
  void initState() {
    super.initState();
    context.read<PosKdsCubit>().resetOrderSaveInfo();
    context.read<PosKdsCubit>().listTables();
    context.read<PosKdsCubit>().listOrders();
    context.read<CrmCubit>().listCoupons();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _orderNotesController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onPhoneChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    final query = value.trim();
    setState(() {
      _customerName = null;
      _selectedCustomerId = null;
      _selectedAddressId = null;
    });
    if (query.isEmpty) {
      context.read<PosKdsCubit>().searchCustomersByPhone(query);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), () {
      context.read<PosKdsCubit>().searchCustomersByPhone(query);
    });
  }

  bool _isActiveDineInBill(OrderModel order) {
    return order.order_type == 'DINE_IN' &&
        order.table_session_id.isNotEmpty &&
        ![
          'PAID',
          'CANCELLED',
          'REFUNDED',
          'COMPLETED',
        ].contains(order.status.toUpperCase());
  }

  bool _sideScopesOverlap(
    List<String> existingSides,
    List<String> selectedSides,
  ) {
    if (existingSides.isEmpty || selectedSides.isEmpty) {
      return true;
    }
    return selectedSides.any(existingSides.contains);
  }

  List<OrderModel> _activeBillsForSelection(
    PosKdsState posState,
    String? tableId,
    List<String> sideIds,
  ) {
    if (tableId == null || tableId.isEmpty) {
      return const [];
    }
    final bySession = <String, OrderModel>{};
    for (final order in posState.orders) {
      if (!_isActiveDineInBill(order) || order.table_id != tableId) {
        continue;
      }
      if (_sideScopesOverlap(order.table_side_ids, sideIds)) {
        bySession[order.table_session_id] = order;
      }
    }
    return bySession.values.toList();
  }

  String? _deriveSelectedTableId(PosKdsState posState) {
    if (_selectedOrderType != 'DINE_IN') {
      return null;
    }
    if (_selectedTableSideIds.isNotEmpty) {
      for (final table in posState.tables) {
        if (table.side_labels.contains(_selectedTableSideIds.first)) {
          return table.id;
        }
      }
    }
    return _selectedTableId;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PosKdsCubit, PosKdsState>(
      listenWhen: (previous, current) =>
          previous.selectedCustomer?.id != current.selectedCustomer?.id,
      listener: (context, state) {
        final selectedCustomer = state.selectedCustomer;
        if (selectedCustomer != null &&
            selectedCustomer.id != _selectedCustomerId) {
          context.read<CrmCubit>().getLoyaltyByCustomer(selectedCustomer.id);
          setState(() {
            _selectedCustomerId = selectedCustomer.id;
            _customerName = selectedCustomer.name.isEmpty
                ? 'Selected customer'
                : selectedCustomer.name;
            _phoneController.text = selectedCustomer.phone;
            _selectedAddressId = selectedCustomer.addresses.isEmpty
                ? null
                : selectedCustomer.addresses.first.id;
          });
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F4F6),
        appBar: AppBar(
          backgroundColor: AppColors.pureWhite,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
              size: 24.w,
            ),
          ),
          title: Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        body: BlocBuilder<PosKdsCubit, PosKdsState>(
          builder: (context, posState) {
            return BlocBuilder<CatalogCubit, CatalogState>(
              builder: (context, catalogState) {
                final crmState = context.watch<CrmCubit>().state;
                final cartItemsCount = posState.cart.values.fold(
                  0,
                  (sum, item) => sum + 1,
                );
                final isSearchingCustomer =
                    posState.searchCustomersInfo.status ==
                    OperationStatus.loading;
                if (cartItemsCount == 0) {
                  return Center(
                    child: Text(
                      PosConstant.CART_EMPTY,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }

                double cartTotal = 0.0;
                final List<Widget> itemWidgets = [];

                posState.cart.forEach((itemId, line) {
                  try {
                    final item = line.item.copyWith(
                      selling_price: line.unit_price,
                    );
                    final qty = line.quantity;
                    final unit = line.quantity_uom_code.trim().isEmpty
                        ? ''
                        : ' ${line.quantity_uom_code}';
                    cartTotal += line.total;

                    itemWidgets.add(
                      Container(
                        margin: EdgeInsets.only(bottom: 16.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 16.w,
                              height: 16.w,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.primaryGreen,
                                ),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              alignment: Alignment.center,
                              child: Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryGreen,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.display_name,
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        '₹ ${(item.selling_price * qty).toStringAsFixed(0)}',
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '₹ ${item.selling_price.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFCE4EC),
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color: const Color(0xFFF8BBD0),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            context
                                                .read<PosKdsCubit>()
                                                .removeFromCart(line.id);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.w,
                                              vertical: 6.h,
                                            ),
                                            child: Icon(
                                              Icons.remove,
                                              color: const Color(0xFFC2185B),
                                              size: 16.w,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '${_formatQty(qty)}$unit',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w900,
                                            color: const Color(0xFFC2185B),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            context
                                                .read<PosKdsCubit>()
                                                .setCartQuantity(
                                                  line.id,
                                                  line.quantity + line.step_qty,
                                                );
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.w,
                                              vertical: 6.h,
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              color: const Color(0xFFC2185B),
                                              size: 16.w,
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
                      ),
                    );
                  } catch (_) {}
                });

                final selectedCustomer = posState.selectedCustomer;
                final selectedDineInTableId = _deriveSelectedTableId(posState);
                final activeDineInBills = _activeBillsForSelection(
                  posState,
                  selectedDineInTableId,
                  _selectedTableSideIds,
                );
                final activeDineInBill = activeDineInBills.length == 1
                    ? activeDineInBills.first
                    : null;
                final ladyluckDiscountAmount =
                    posState.ladyluckDiscountAmount;
                final payableAmount = posState.cartPayable;

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.all(16.w),
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: AppColors.pureWhite,
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Customer Details',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  TextField(
                                    controller: _phoneController,
                                    onChanged: _onPhoneChanged,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      hintText: 'Enter Phone Number',
                                      hintStyle: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.textTertiary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.phone,
                                        color: AppColors.textSecondary,
                                        size: 20.w,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFF9FAFB),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  if (isSearchingCustomer) ...[
                                    SizedBox(height: 12.h),
                                    Center(
                                      child: SizedBox(
                                        width: 20.w,
                                        height: 20.w,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.primaryGreen,
                                        ),
                                      ),
                                    ),
                                  ],
                                  if (!isSearchingCustomer &&
                                      posState
                                          .matchingCustomers
                                          .isNotEmpty) ...[
                                    SizedBox(height: 8.h),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF9FAFB),
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        border: Border.all(
                                          color: AppColors.borderGrey,
                                        ),
                                      ),
                                      child: Column(
                                        children: posState.matchingCustomers
                                            .map((user) {
                                              return ListTile(
                                                leading: Icon(
                                                  Icons.person,
                                                  color:
                                                      AppColors.textSecondary,
                                                  size: 20.w,
                                                ),
                                                title: Text(
                                                  user.name.isEmpty
                                                      ? 'Unknown'
                                                      : user.name,
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w800,
                                                    color:
                                                        AppColors.textPrimary,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  user.phone,
                                                  style: TextStyle(
                                                    fontSize: 11.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        AppColors.textSecondary,
                                                  ),
                                                ),
                                                onTap: () {
                                                  context
                                                      .read<PosKdsCubit>()
                                                      .selectCustomer(user);
                                                  context
                                                      .read<CrmCubit>()
                                                      .getLoyaltyByCustomer(
                                                        user.id,
                                                      );
                                                  setState(() {
                                                    _selectedCustomerId =
                                                        user.id;
                                                    _customerName = user.name;
                                                    _phoneController.text =
                                                        user.phone;
                                                    _selectedAddressId =
                                                        user.addresses.isEmpty
                                                        ? null
                                                        : user
                                                              .addresses
                                                              .first
                                                              .id;
                                                  });
                                                },
                                              );
                                            })
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                  if (!isSearchingCustomer &&
                                      posState.matchingCustomers.isEmpty &&
                                      _selectedCustomerId != null) ...[
                                    SizedBox(height: 12.h),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: AppColors.primaryGreen,
                                          size: 16.w,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          'Selected: $_customerName',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.primaryGreen,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 16.w),
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: AppColors.pureWhite,
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order Type',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  Row(
                                    children: [
                                      _buildOrderTypeChip(
                                        'DINE_IN',
                                        'Dine In',
                                        Icons.restaurant,
                                      ),
                                      SizedBox(width: 8.w),
                                      _buildOrderTypeChip(
                                        'TAKEAWAY',
                                        'Takeaway',
                                        Icons.shopping_bag,
                                      ),
                                      SizedBox(width: 8.w),
                                      _buildOrderTypeChip(
                                        'DELIVERY',
                                        'Delivery',
                                        Icons.delivery_dining,
                                      ),
                                    ],
                                  ),
                                  if (_selectedOrderType == 'DINE_IN') ...[
                                    SizedBox(height: 16.h),
                                    Text(
                                      'Select Table',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    if (posState.tables.isEmpty)
                                      Text(
                                        'No tables available',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textSecondary,
                                        ),
                                      )
                                    else
                                      ...posState.tables.map((table) {
                                        return Column(
                                          children: [
                                            _buildSelectableTile(
                                              label: table.table_number,
                                              subtitle: table.status,
                                              isSelected:
                                                  _selectedTableSideIds.any(
                                                    (side) => table.side_labels
                                                        .contains(side),
                                                  ) ||
                                                  _selectedTableId == table.id,
                                              onTap: () {
                                                setState(() {
                                                  if (_expandedTableIds
                                                      .contains(table.id)) {
                                                    _expandedTableIds.remove(
                                                      table.id,
                                                    );
                                                  } else {
                                                    _expandedTableIds.add(
                                                      table.id,
                                                    );
                                                  }
                                                  if (table
                                                      .side_labels
                                                      .isEmpty) {
                                                    _selectedTableId = table.id;
                                                  }
                                                });
                                              },
                                            ),
                                            if (_expandedTableIds.contains(
                                                  table.id,
                                                ) &&
                                                table.side_labels.isNotEmpty)
                                              Container(
                                                margin: EdgeInsets.only(
                                                  left: 16.w,
                                                  bottom: 8.h,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Select Sides',
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: AppColors
                                                            .textSecondary,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8.h),
                                                    Wrap(
                                                      spacing: 8.w,
                                                      runSpacing: 8.h,
                                                      children: table.side_labels.map((
                                                        side,
                                                      ) {
                                                        final isSideSelected =
                                                            _selectedTableSideIds
                                                                .contains(side);
                                                        return GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              if (isSideSelected) {
                                                                _selectedTableSideIds
                                                                    .remove(
                                                                      side,
                                                                    );
                                                              } else {
                                                                _selectedTableSideIds
                                                                    .add(side);
                                                              }
                                                            });
                                                          },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      12.w,
                                                                  vertical: 6.h,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  isSideSelected
                                                                  ? AppColors
                                                                        .primaryGreen
                                                                  : AppColors
                                                                        .pureWhite,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    20.r,
                                                                  ),
                                                              border: Border.all(
                                                                color:
                                                                    isSideSelected
                                                                    ? AppColors
                                                                          .primaryGreen
                                                                    : AppColors
                                                                          .borderGrey,
                                                              ),
                                                            ),
                                                            child: Text(
                                                              side,
                                                              style: TextStyle(
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    isSideSelected
                                                                    ? FontWeight
                                                                          .w800
                                                                    : FontWeight
                                                                          .w600,
                                                                color:
                                                                    isSideSelected
                                                                    ? AppColors
                                                                          .pureWhite
                                                                    : AppColors
                                                                          .textPrimary,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        );
                                      }),
                                    if (activeDineInBill != null) ...[
                                      SizedBox(height: 10.h),
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(10.w),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE8F5E9),
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                          border: Border.all(
                                            color: AppColors.primaryGreen,
                                          ),
                                        ),
                                        child: Text(
                                          'Adding to active bill #${activeDineInBill.order_no}',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.primaryGreen,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                  if (_selectedOrderType == 'DELIVERY') ...[
                                    SizedBox(height: 16.h),
                                    Text(
                                      'Select Address',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    if (selectedCustomer == null)
                                      Text(
                                        'Select a customer first',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textSecondary,
                                        ),
                                      )
                                    else if (selectedCustomer.addresses.isEmpty)
                                      Text(
                                        'No address found for selected customer',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textSecondary,
                                        ),
                                      )
                                    else
                                      ...selectedCustomer.addresses.map((
                                        address,
                                      ) {
                                        final label = _addressLabel(address);
                                        return _buildSelectableTile(
                                          label: label.isEmpty
                                              ? 'Address ${address.id}'
                                              : label,
                                          isSelected:
                                              _selectedAddressId == address.id,
                                          onTap: () {
                                            setState(() {
                                              _selectedAddressId = address.id;
                                            });
                                          },
                                        );
                                      }),
                                  ],
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(16.w),
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: AppColors.pureWhite,
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.shopping_cart,
                                        color: AppColors.textPrimary,
                                        size: 20.w,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Order Items',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  ...itemWidgets,
                                ],
                              ),
                            ),
                            if (selectedCustomer != null)
                              _buildLadyluckCard(posState),
                            _buildCustomerContext(posState, crmState),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.pureWhite,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Column(
                          children: [
                            // ── Order Notes ─────────────────────────────
                            Container(
                              margin: EdgeInsets.only(bottom: 12.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.sticky_note_2_outlined,
                                        size: 14.w,
                                        color: AppColors.textSecondary,
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        'ORDER NOTES',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textTertiary,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  AppInput(
                                    hintText:
                                        'Add special instructions, allergies, preferences…',
                                    controller: _orderNotesController,
                                    maxLines: 3,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 1.h,
                              color: AppColors.borderGrey,
                              margin: EdgeInsets.only(bottom: 12.h),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Item Total',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  '₹ ${cartTotal.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            if (ladyluckDiscountAmount > 0) ...[
                              SizedBox(height: 8.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    PosConstant.LADYLUCK_DISCOUNT_LABEL,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primaryGreen,
                                    ),
                                  ),
                                  Text(
                                    '-₹ ${ladyluckDiscountAmount.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.primaryGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '₹ ${cartTotal.toStringAsFixed(0)}',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        'TOTAL',
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      if (ladyluckDiscountAmount > 0)
                                        Text(
                                          'Payable ₹ ${payableAmount.toStringAsFixed(0)}',
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.primaryGreen,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 160.w,
                                  child: AppButton(
                                    text: 'Place Order',
                                    isLoading:
                                        posState.saveOrdersInfo.status ==
                                        OperationStatus.loading,
                                    onPressed: () async {
                                      if (_selectedOrderType == 'DINE_IN' &&
                                          _selectedTableId == null &&
                                          _selectedTableSideIds.isEmpty) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Please select a table',
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      if (_selectedOrderType == 'DELIVERY' &&
                                          _selectedAddressId == null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Please select an address',
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      final List<Map<String, dynamic>>
                                      orderItemsList = [];
                                      for (final line in posState.cart.values) {
                                        orderItemsList.add({
                                          'menu_item_id': line.menu_item_id,
                                          'sale_mode_id': line.sale_mode_id,
                                          'sale_mode_label':
                                              line.sale_mode_label,
                                          'quantity_uom_id':
                                              line.quantity_uom_id,
                                          'quantity_uom_code':
                                              line.quantity_uom_code,
                                          'quantity': line.quantity,
                                          'unit_price': line.unit_price,
                                          'total_price': line.total,
                                          'notes': '',
                                        });
                                      }

                                      final derivedTableId =
                                          _deriveSelectedTableId(posState);
                                      final activeBills =
                                          _activeBillsForSelection(
                                            posState,
                                            derivedTableId,
                                            _selectedTableSideIds,
                                          );
                                      if (activeBills.length > 1) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Selected seats belong to multiple active bills',
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      final order = await context
                                          .read<PosKdsCubit>()
                                          .placeOrderFromCart(
                                            cartTotal,
                                            orderItemsList,
                                            _selectedOrderType,
                                            derivedTableId,
                                            _selectedCustomerId,
                                            tableSessionId:
                                                activeBills.length == 1
                                                ? activeBills
                                                      .first
                                                      .table_session_id
                                                : null,
                                            deliveryAddressId:
                                                _selectedOrderType == 'DELIVERY'
                                                ? _selectedAddressId
                                                : null,
                                            finalPayingPrice: payableAmount,
                                            ladyluckDiscountId:
                                                ladyluckDiscountAmount > 0
                                                ? posState
                                                      .activeLadyluckDiscount
                                                      ?.id
                                                : null,
                                            tableSideIds:
                                                _selectedOrderType == 'DINE_IN'
                                                ? _selectedTableSideIds
                                                : null,
                                            notes:
                                                _orderNotesController.text
                                                    .trim()
                                                    .isEmpty
                                                ? null
                                                : _orderNotesController.text
                                                      .trim(),
                                          );
                                      if (!context.mounted || order == null) {
                                        return;
                                      }
                                      Navigator.pushReplacementNamed(
                                        context,
                                        AppRoutes.orderDetail,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderTypeChip(String type, String label, IconData icon) {
    final isSelected = _selectedOrderType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedOrderType = type;
            if (type != 'DINE_IN') {
              _selectedTableId = null;
              _selectedTableSideIds.clear();
              _expandedTableIds.clear();
            }
            if (type != 'DELIVERY') {
              _selectedAddressId = null;
            } else if (_selectedAddressId == null &&
                context.read<PosKdsCubit>().state.selectedCustomer != null &&
                context
                    .read<PosKdsCubit>()
                    .state
                    .selectedCustomer!
                    .addresses
                    .isNotEmpty) {
              _selectedAddressId = context
                  .read<PosKdsCubit>()
                  .state
                  .selectedCustomer!
                  .addresses
                  .first
                  .id;
            }
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryGreen : AppColors.pureWhite,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? AppColors.primaryGreen : AppColors.borderGrey,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? AppColors.pureWhite
                    : AppColors.textSecondary,
                size: 20.w,
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                  color: isSelected
                      ? AppColors.pureWhite
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _addressLabel(AddressModel address) {
    return [
      address.area,
      address.locality,
      address.city,
      address.pin_code,
    ].where((part) => part.trim().isNotEmpty).join(', ');
  }

  String _formatQty(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value
        .toStringAsFixed(3)
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }

  Widget _buildSelectableTile({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    String? subtitle,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.borderGrey,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected
                  ? AppColors.primaryGreen
                  : AppColors.textSecondary,
              size: 18.w,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null && subtitle.trim().isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLadyluckCard(PosKdsState posState) {
    final discount = posState.activeLadyluckDiscount;
    final hasScratchCard =
        posState.ladyluckSummary.available_scratch_cards.isNotEmpty;
    final isLoading =
        posState.loadLadyluckInfo.status == OperationStatus.loading;
    final isScratching =
        posState.scratchLadyluckInfo.status == OperationStatus.loading;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFFEF3C7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isLoading
          ? Center(
              child: SizedBox(
                width: 18.w,
                height: 18.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primaryGreen,
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34.w,
                      height: 34.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFDE68A),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.card_giftcard,
                        color: const Color(0xFF92400E),
                        size: 18.w,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            discount == null
                                ? PosConstant.LADYLUCK_REWARDS
                                : PosConstant.LADYLUCK_APPLIED,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '${posState.ladyluckSummary.account.points_balance} ${PosConstant.LADYLUCK_POINTS}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (hasScratchCard)
                      GestureDetector(
                        onTap: isScratching
                            ? null
                            : () => context
                                  .read<PosKdsCubit>()
                                  .scratchCustomerLadyluckCard(),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 7.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withOpacity(
                              isScratching ? 0.6 : 1,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: isScratching
                              ? SizedBox(
                                  width: 12.w,
                                  height: 12.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.pureWhite,
                                  ),
                                )
                              : Text(
                                  PosConstant.LADYLUCK_SCRATCH_NOW,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.pureWhite,
                                  ),
                                ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 12.h),
                if (discount != null)
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.pureWhite,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFFEF3C7)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.percent,
                          color: const Color(0xFF2563EB),
                          size: 18.w,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatLadyluckDiscount(discount),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                '${PosConstant.LADYLUCK_MIN_ORDER} Rs. ${discount.min_order_amount.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '-Rs. ${posState.ladyluckDiscountAmount.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Text(
                    hasScratchCard
                        ? '${PosConstant.LADYLUCK_SCRATCH_READY}. ${PosConstant.LADYLUCK_SCRATCH_BODY}'
                        : PosConstant.LADYLUCK_NO_CARD,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF92400E),
                    ),
                  ),
              ],
            ),
    );
  }

  String _formatLadyluckDiscount(LadyluckDiscountModel discount) {
    if (discount.discount_type == 'PERCENTAGE') {
      final cap = discount.max_discount_amount > 0
          ? ' up to Rs. ${discount.max_discount_amount.toStringAsFixed(0)}'
          : '';
      return '${discount.discount_value.toStringAsFixed(0)}% off$cap';
    }
    return 'Rs. ${discount.discount_value.toStringAsFixed(0)} off';
  }

  Widget _buildCustomerContext(PosKdsState posState, CrmState crmState) {
    if (_selectedCustomerId == null) {
      return const SizedBox.shrink();
    }

    final selectedCustomer = posState.selectedCustomer;
    final previousOrders = posState.orders
        .where((order) => order.uid == _selectedCustomerId)
        .toList();
    final activeCoupons = crmState.coupons
        .where((coupon) => !coupon.is_deleted && coupon.status == 'ACTIVE')
        .toList();
    final loyalty = crmState.customerLoyalty;
    final points = loyalty is Map
        ? (loyalty['balance'] ?? loyalty['points'] ?? 0).toString()
        : '0';
    final loyaltyTransactions =
        loyalty is Map && loyalty['transactions'] is List
        ? loyalty['transactions'] as List
        : const [];
    final totalSpend = previousOrders.fold<double>(
      0,
      (sum, order) => sum + order.total_amount,
    );
    final paidOrders = previousOrders
        .where((order) => order.status.toUpperCase() == 'PAID')
        .length;
    final latestOrder = previousOrders.isEmpty ? null : previousOrders.first;
    final addresses = selectedCustomer?.addresses ?? const [];

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 4.h, bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(0.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Benefits',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          if (selectedCustomer != null) ...[
            Text(
              selectedCustomer.name.isEmpty
                  ? 'Selected customer'
                  : selectedCustomer.name,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              [
                selectedCustomer.phone,
                selectedCustomer.email,
              ].where((item) => item.trim().isNotEmpty).join('  |  '),
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Saved addresses: ${addresses.length}',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 4.h),
            if (addresses.isEmpty)
              Text(
                'No saved delivery address',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              )
            else
              ...addresses.take(2).map((address) {
                final label = _addressLabel(address);
                return Text(
                  label.isEmpty ? address.id : label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                );
              }),
            SizedBox(height: 12.h),
          ],
          Text(
            'Previous orders: ${previousOrders.length}  |  Paid: $paidOrders  |  Spend: ₹ ${totalSpend.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          if (latestOrder != null)
            Text(
              'Latest: #${latestOrder.order_no} - ${latestOrder.order_type} - ₹ ${latestOrder.total_amount.toStringAsFixed(0)} - ${latestOrder.status}',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          SizedBox(height: latestOrder == null ? 0 : 4.h),
          ...previousOrders.take(4).map((order) {
            return Text(
              '#${order.order_no} - ${order.order_type} - ₹ ${order.total_amount.toStringAsFixed(0)} - ${order.status}',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            );
          }),
          if (previousOrders.isEmpty)
            Text(
              'No previous orders found',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          SizedBox(height: 12.h),
          Text(
            'Coupons/offers: ${activeCoupons.length} available',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          ...activeCoupons.take(4).map((coupon) {
            return Text(
              '${coupon.code} - ${coupon.discount_pct.toStringAsFixed(0)}% off - min ₹ ${coupon.min_order_val.toStringAsFixed(0)} - max ₹ ${coupon.max_discount.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            );
          }),
          if (activeCoupons.isEmpty)
            Text(
              'No coupons/offers available',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          SizedBox(height: 12.h),
          Text(
            'Loyalty points: $points  |  Transactions: ${loyaltyTransactions.length}',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }
}
