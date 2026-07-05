import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/utils/error.dart';

import 'package:mobile/features/catalog/controllers/catalog.cubit.dart';
import 'package:mobile/features/catalog/controllers/catalog.state.dart';
import 'package:mobile/features/core_hr/models/address.model.dart';
import 'package:mobile/features/crm/crm.cubit.dart';
import 'package:mobile/features/crm/crm.state.dart';
import 'controllers/pos_kds.cubit.dart';
import 'controllers/pos_kds.state.dart';
import 'dart:async';
import 'package:mobile/features/pos_kds/pos.receipt.page.dart';

class PosCartPage extends StatefulWidget {
  const PosCartPage({super.key});

  @override
  State<PosCartPage> createState() => _PosCartPageState();
}

class _PosCartPageState extends State<PosCartPage> {
  String _selectedOrderType = 'DINE_IN';
  String? _selectedTableId;
  String? _selectedCustomerId;
  String? _selectedAddressId;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _priceAdditionController =
      TextEditingController();
  final TextEditingController _priceReductionController =
      TextEditingController();
  final TextEditingController _finalPayingPriceController =
      TextEditingController();
  Timer? _debounce;
  String? _customerName;

  @override
  void initState() {
    super.initState();
    context.read<PosKdsCubit>().listTables();
    context.read<PosKdsCubit>().listOrders();
    context.read<CrmCubit>().listCoupons();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _priceAdditionController.dispose();
    _priceReductionController.dispose();
    _finalPayingPriceController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<PosKdsCubit, PosKdsState>(
      listenWhen: (previous, current) =>
          previous.saveOrdersInfo.status != current.saveOrdersInfo.status,
      listener: (context, state) {
        if (state.saveOrdersInfo.status == OperationStatus.success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const PosReceiptPage()),
          );
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
                  (sum, item) => sum + item,
                );
                final isSearchingCustomer =
                    posState.searchCustomersInfo.status ==
                    OperationStatus.loading;
                if (cartItemsCount == 0) {
                  return Center(
                    child: Text(
                      'Cart is empty',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }

                double cartTotal = 0.0;
                final List<Widget> itemWidgets = [];

                posState.cart.forEach((itemId, qty) {
                  try {
                    final item = catalogState.menuItems.firstWhere(
                      (i) => i.id == itemId,
                    );
                    cartTotal += (item.selling_price * qty);

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
                                        'Rs${(item.selling_price * qty).toStringAsFixed(0)}',
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
                                    'Rs${item.selling_price.toStringAsFixed(0)}',
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
                                                .removeFromCart(item.id);
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
                                          '$qty',
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
                                                .addToCart(item.id);
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

                final priceAddition = _readAmount(_priceAdditionController);
                final priceReduction = _readAmount(_priceReductionController);
                final adjustedTotal =
                    cartTotal + priceAddition - priceReduction;
                final finalPayingPrice =
                    double.tryParse(_finalPayingPriceController.text.trim()) ??
                    adjustedTotal;
                final selectedCustomer = posState.selectedCustomer;

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
                            _buildCustomerContext(posState, crmState),
                            if (_selectedCustomerId != null)
                              SizedBox(height: 16.h),
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
                                        return _buildSelectableTile(
                                          label: table.table_number,
                                          subtitle: table.status,
                                          isSelected:
                                              _selectedTableId == table.id,
                                          onTap: () {
                                            setState(() {
                                              _selectedTableId = table.id;
                                            });
                                          },
                                        );
                                      }),
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
                            Row(
                              children: [
                                Expanded(
                                  child: _buildAmountInput(
                                    _priceAdditionController,
                                    'Add price',
                                    () => setState(() {}),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: _buildAmountInput(
                                    _priceReductionController,
                                    'Reduce price',
                                    () => setState(() {}),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            _buildAmountInput(
                              _finalPayingPriceController,
                              'Final paying price',
                              () => setState(() {}),
                            ),
                            SizedBox(height: 16.h),
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
                                  'Rs${adjustedTotal.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Rs${finalPayingPrice.toStringAsFixed(0)}',
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
                                    onPressed: () {
                                      if (_selectedOrderType == 'DINE_IN' &&
                                          _selectedTableId == null) {
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
                                      posState.cart.forEach((itemId, qty) {
                                        try {
                                          final item = catalogState.menuItems
                                              .firstWhere(
                                                (i) => i.id == itemId,
                                              );
                                          orderItemsList.add({
                                            'menu_item_id': item.id,
                                            'quantity': qty,
                                            'unit_price': item.selling_price,
                                            'total_price':
                                                item.selling_price * qty,
                                            'notes': '',
                                          });
                                        } catch (_) {}
                                      });

                                      context
                                          .read<PosKdsCubit>()
                                          .placeOrderFromCart(
                                            cartTotal,
                                            orderItemsList,
                                            _selectedOrderType,
                                            _selectedTableId,
                                            _selectedCustomerId,
                                            deliveryAddressId:
                                                _selectedAddressId,
                                            priceAdditionAmount: priceAddition,
                                            priceReductionAmount:
                                                priceReduction,
                                            finalPayingPrice: finalPayingPrice,
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

  double _readAmount(TextEditingController controller) {
    return double.tryParse(controller.text.trim()) ?? 0.0;
  }

  String _addressLabel(AddressModel address) {
    return [
      address.area,
      address.locality,
      address.city,
      address.pin_code,
    ].where((part) => part.trim().isNotEmpty).join(', ');
  }

  Widget _buildAmountInput(
    TextEditingController controller,
    String hint,
    VoidCallback onChanged,
  ) {
    return TextField(
      controller: controller,
      onChanged: (_) => onChanged(),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 12.sp,
          color: AppColors.textTertiary,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
    );
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

  Widget _buildCustomerContext(PosKdsState posState, CrmState crmState) {
    if (_selectedCustomerId == null) {
      return const SizedBox.shrink();
    }

    final previousOrders = posState.orders
        .where((order) => order.uid == _selectedCustomerId)
        .take(3)
        .toList();
    final activeCoupons = crmState.coupons
        .where((coupon) => !coupon.is_deleted && coupon.status == 'ACTIVE')
        .take(3)
        .toList();
    final loyalty = crmState.customerLoyalty;
    final points = loyalty is Map
        ? (loyalty['balance'] ?? loyalty['points'] ?? 0).toString()
        : '0';

    return Container(
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
            'Customer Benefits',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Previous orders: ${previousOrders.length}',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          ...previousOrders.map((order) {
            return Text(
              '${order.order_type} - Rs${order.total_amount.toStringAsFixed(0)} - ${order.status}',
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
            'Coupons/offers: ${activeCoupons.length}',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          ...activeCoupons.map((coupon) {
            return Text(
              '${coupon.code} - ${coupon.discount_pct.toStringAsFixed(0)}% off',
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
            'Loyalty points: $points',
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
