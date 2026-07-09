import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/bottom_action.dart';
import 'package:mobile/constants/api.dart';
import 'package:mobile/features/pos_kds/constants/pos.constant.dart';
import 'package:mobile/features/pos_kds/controllers/pos_kds.cubit.dart';
import 'package:mobile/features/pos_kds/controllers/pos_kds.state.dart';
import 'package:mobile/features/pos_kds/models/order.model.dart';
import 'package:mobile/features/pos_kds/services/order_display_formatter.dart';
import 'package:mobile/utils/error.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:image_picker/image_picker.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final GlobalKey _receiptKey = GlobalKey();
  final TextEditingController _finalPayingPriceController =
      TextEditingController();
  final List<String> _paymentProofPaths = [];

  @override
  void initState() {
    super.initState();
    final order = context.read<PosKdsCubit>().state.selectedOrder;
    if (order != null) {
      _finalPayingPriceController.text = order.total_amount.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _finalPayingPriceController.dispose();
    super.dispose();
  }

  Future<void> _shareReceipt(OrderModel order) async {
    final context = _receiptKey.currentContext;
    final boundary = context?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      return;
    }
    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData?.buffer.asUint8List();
    if (bytes == null) {
      return;
    }
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/order_${order.order_no}_receipt.png');
    await file.writeAsBytes(bytes, flush: true);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'image/png')],
        text: 'ORDER #${order.order_no}',
      ),
    );
  }

  Future<void> _pickPaymentProof() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    }
    setState(() => _paymentProofPaths.add(pickedFile.path));
  }

  void _removePaymentProof(String path) {
    setState(() => _paymentProofPaths.remove(path));
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    switch (status.toUpperCase()) {
      case 'NEW':
      case 'PLACED':
      case 'OPEN':
        bgColor = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
        break;
      case 'PREPARING':
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange.shade800;
        break;
      case 'READY':
      case 'COMPLETED':
        bgColor = const Color(0xFFE8F5E9);
        textColor = AppColors.primaryGreen;
        break;
      case 'OUT_FOR_DELIVERY':
        bgColor = Colors.purple.shade50;
        textColor = Colors.purple.shade700;
        break;
      case 'DELIVERED':
        bgColor = const Color(0xFFE8F5E9);
        textColor = AppColors.primaryGreen;
        break;
      case 'FAILED_DELIVERY':
        bgColor = const Color(0xFFFFF8E1);
        textColor = Colors.orange.shade900;
        break;
      case 'BILLED':
        bgColor = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
        break;
      case 'PAID':
        bgColor = const Color(0xFFE8F5E9);
        textColor = AppColors.primaryGreen;
        break;
      case 'CANCELLED':
        bgColor = const Color(0xFFFFF5F5);
        textColor = const Color(0xFFEF4F5F);
        break;
      case 'REFUNDED':
        bgColor = const Color(0xFFFFF5F5);
        textColor = Colors.orange.shade700;
        break;
      default:
        bgColor = AppColors.softGrey;
        textColor = AppColors.textSecondary;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w900,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
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
      final year = dateTime.year;
      return '$day-$month-$year $hour:$min $amPm';
    } catch (e) {
      return timeStr;
    }
  }

  String _formatAmount(double amount) {
    return '₹ ${amount.toStringAsFixed(2)}';
  }

  void _goBack() {
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  TextStyle _headerStyle() => TextStyle(
    fontFamily: 'Courier',
    fontSize: 12.sp,
    fontWeight: FontWeight.w800,
    color: AppColors.textSecondary,
  );

  TextStyle _itemStyle() => TextStyle(
    fontFamily: 'Courier',
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
  );

  TextStyle _boldStyle() => TextStyle(
    fontFamily: 'Courier',
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
  );

  Widget _buildDashedLine() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 8.0;
        const dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: const DecoratedBox(
                decoration: BoxDecoration(color: Colors.black54),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildShimmerDetail() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          Container(
            height: 180.h,
            margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          Container(
            height: 300.h,
            margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            decoration: BoxDecoration(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildPrintLogSection(PosKdsState state) {
    final isPrinting = state.printReceiptInfo.status == OperationStatus.loading;
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                PosConstant.PRINT_LOG_TITLE.toUpperCase(),
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textTertiary,
                  letterSpacing: 0.8,
                ),
              ),
              GestureDetector(
                onTap: isPrinting
                    ? null
                    : () => context.read<PosKdsCubit>().printTestReceipt(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: AppColors.primaryGreen),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isPrinting)
                        SizedBox(
                          width: 12.w,
                          height: 12.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primaryGreen,
                          ),
                        )
                      else
                        Icon(
                          Icons.print_outlined,
                          size: 14.w,
                          color: AppColors.primaryGreen,
                        ),
                      SizedBox(width: 6.w),
                      Text(
                        PosConstant.PRINT_TEST_BILL,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            constraints: BoxConstraints(maxHeight: 132.h),
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.borderGrey),
            ),
            child: state.printLogs.isEmpty
                ? Text(
                    PosConstant.PRINT_LOG_EMPTY,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  )
                : SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: state.printLogs
                          .map(
                            (log) => Padding(
                              padding: EdgeInsets.only(bottom: 6.h),
                              child: Text(
                                log,
                                style: TextStyle(
                                  fontFamily: 'Courier',
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                  height: 1.25,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: const Color(0xFFFAFAFA),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _goBack,
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
                  Expanded(
                    child: Center(
                      child: Text(
                        PosConstant.ORDER_DETAIL_TITLE,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  BlocBuilder<PosKdsCubit, PosKdsState>(
                    builder: (context, state) {
                      final order = state.selectedOrder;
                      return GestureDetector(
                        onTap: order == null
                            ? null
                            : () => _shareReceipt(order),
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
                            Icons.share_outlined,
                            color: AppColors.textPrimary,
                            size: 20.w,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<PosKdsCubit, PosKdsState>(
                builder: (context, state) {
                  if (state.loadOrdersInfo.status == OperationStatus.loading) {
                    return _buildShimmerDetail();
                  }

                  final order = state.selectedOrder;

                  if (order == null) {
                    return const Center(child: Text('Order not found'));
                  }

                  final finalPayingPrice =
                      double.tryParse(
                        _finalPayingPriceController.text.trim(),
                      ) ??
                      order.total_amount;
                  final deliveryAddress = OrderDisplayFormatter.deliveryAddress(
                    order,
                  );
                  final tableDisplay = OrderDisplayFormatter.tableDisplay(
                    order,
                  );
                  final fulfillmentTitle =
                      OrderDisplayFormatter.fulfillmentTitle(order);

                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 8.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Stack(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(16.w),
                                      decoration: BoxDecoration(
                                        color: AppColors.pureWhite,
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: AppColors.shadowColor,
                                            blurRadius: 8,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    '#${order.order_no}',
                                                    style: TextStyle(
                                                      fontSize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color:
                                                          AppColors.textPrimary,
                                                    ),
                                                  ),
                                                  if (order
                                                      .code
                                                      .isNotEmpty) ...[
                                                    SizedBox(width: 8.w),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 6.w,
                                                            vertical: 2.h,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: AppColors
                                                            .primaryGreen,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4.r,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        order.code,
                                                        style: TextStyle(
                                                          fontSize: 11.sp,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          color: AppColors
                                                              .pureWhite,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                              _buildStatusBadge(order.status),
                                            ],
                                          ),
                                          SizedBox(height: 12.h),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                size: 14.w,
                                                color: AppColors.textSecondary,
                                              ),
                                              SizedBox(width: 6.w),
                                              Text(
                                                _formatTime(order.created_at),
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (tableDisplay.isNotEmpty) ...[
                                            SizedBox(height: 8.h),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons
                                                      .table_restaurant_outlined,
                                                  size: 14.w,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                                SizedBox(width: 6.w),
                                                Expanded(
                                                  child: Text(
                                                    tableDisplay,
                                                    style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: AppColors
                                                          .textSecondary,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                          if (tableDisplay.isEmpty &&
                                              deliveryAddress.isEmpty) ...[
                                            SizedBox(height: 8.h),
                                            Row(
                                              children: [
                                                Icon(
                                                  OrderDisplayFormatter.isTakeaway(
                                                        order,
                                                      )
                                                      ? Icons
                                                            .takeout_dining_outlined
                                                      : Icons
                                                            .shopping_bag_outlined,
                                                  size: 14.w,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                                SizedBox(width: 6.w),
                                                Text(
                                                  fulfillmentTitle,
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        AppColors.textSecondary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                          if (deliveryAddress.isNotEmpty) ...[
                                            SizedBox(height: 8.h),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on_outlined,
                                                  size: 14.w,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                                SizedBox(width: 6.w),
                                                Expanded(
                                                  child: Text(
                                                    'Delivery: $deliveryAddress',
                                                    style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: AppColors
                                                          .textSecondary,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                          if (order.employee_id.isNotEmpty) ...[
                                            SizedBox(height: 8.h),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.person_outline,
                                                  size: 14.w,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                                SizedBox(width: 6.w),
                                                Text(
                                                  'Staff: ${order.employee_id}',
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        AppColors.textSecondary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                          if (order.partner_id.isNotEmpty) ...[
                                            SizedBox(height: 8.h),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.delivery_dining,
                                                  size: 14.w,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                                SizedBox(width: 6.w),
                                                Text(
                                                  'Partner: ${order.partner_id}',
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        AppColors.textSecondary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                          if (order.user != null) ...[
                                            SizedBox(height: 12.h),
                                            Divider(
                                              color: AppColors.borderGrey,
                                            ),
                                            SizedBox(height: 12.h),
                                            Text(
                                              'Customer Details',
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 8.h),
                                            Row(
                                              children: [
                                                if (order
                                                    .user!
                                                    .avatar
                                                    .isNotEmpty) ...[
                                                  CircleAvatar(
                                                    radius: 16.w,
                                                    backgroundImage:
                                                        NetworkImage(
                                                          order.user!.avatar,
                                                        ),
                                                  ),
                                                  SizedBox(width: 8.w),
                                                ] else ...[
                                                  Icon(
                                                    Icons.person,
                                                    size: 24.w,
                                                    color:
                                                        AppColors.textSecondary,
                                                  ),
                                                  SizedBox(width: 8.w),
                                                ],
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        order.user!.name,
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: AppColors
                                                              .textPrimary,
                                                        ),
                                                      ),
                                                      if (order
                                                              .user!
                                                              .phone
                                                              .isNotEmpty ||
                                                          order
                                                              .user!
                                                              .email
                                                              .isNotEmpty)
                                                        Text(
                                                          '${order.user!.phone}${order.user!.phone.isNotEmpty && order.user!.email.isNotEmpty ? ' • ' : ''}${order.user!.email}',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: AppColors
                                                                .textSecondary,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                          SizedBox(height: 12.h),
                                          Divider(color: AppColors.borderGrey),
                                          SizedBox(height: 12.h),
                                          Text(
                                            'Financial Summary',
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            'Subtotal: ${_formatAmount(order.subtotal)}',
                                            style: TextStyle(fontSize: 12.sp),
                                          ),
                                          if (order.discount_amount > 0)
                                            Text(
                                              'Discount: -${_formatAmount(order.discount_amount)}',
                                              style: TextStyle(fontSize: 12.sp),
                                            ),
                                        ],
                                      ),
                                    ),
                                    // PAID STAMP
                                    if (order.status.toUpperCase() == 'PAID')
                                      Positioned.fill(
                                        child: IgnorePointer(
                                          child: Center(
                                            child: Transform.rotate(
                                              angle: -0.42,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 20.w,
                                                  vertical: 10.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFF1B7A3E,
                                                  ).withOpacity(0.08),
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFF1B7A3E,
                                                    ).withOpacity(0.75),
                                                    width: 4.5,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        8.r,
                                                      ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color(
                                                        0xFF1B7A3E,
                                                      ).withOpacity(0.25),
                                                      blurRadius: 12,
                                                      spreadRadius: 2,
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  'PAID',
                                                  style: TextStyle(
                                                    fontSize: 48.sp,
                                                    fontWeight: FontWeight.w900,
                                                    color: const Color(
                                                      0xFF1B7A3E,
                                                    ).withOpacity(0.72),
                                                    letterSpacing: 12,
                                                    height: 1,
                                                    shadows: [
                                                      Shadow(
                                                        color: const Color(
                                                          0xFF1B7A3E,
                                                        ).withOpacity(0.35),
                                                        blurRadius: 8,
                                                        offset: const Offset(
                                                          2,
                                                          2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              if (order.notes.isNotEmpty) ...[
                                SizedBox(height: 16.h),
                                Container(
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: Colors.yellow.shade100,
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      color: Colors.yellow.shade400,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.orange.shade800,
                                        size: 20.w,
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: Text(
                                          order.notes,
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.orange.shade900,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              SizedBox(height: 24.h),
                              Text(
                                'RECEIPT',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textTertiary,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              SizedBox(height: 12.h),

                              RepaintBoundary(
                                key: _receiptKey,
                                child: Container(
                                  padding: EdgeInsets.all(20.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.pureWhite,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          SizedBox(height: 8.h),
                                          Image.asset(
                                            'assets/logo_transparent.png',
                                            width: 120.w,
                                            height: 80.h,
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            'ORDER #${order.order_no}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Courier',
                                              fontSize: 22.sp,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 2,
                                            ),
                                          ),

                                          SizedBox(height: 8.h),
                                          Text(
                                            'LadyLuck',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Courier',
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          Text(
                                            'Sweets, Fast Food & Restaurant',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Courier',
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            'RHMTB Barari, Bhagalpur, Bihar, 812003',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Courier',
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            'ORDER ID: ${order.id.toUpperCase()}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Courier',
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            'DATE: ${_formatTime(order.created_at)}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Courier',
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 16.h),
                                          _buildDashedLine(),
                                          SizedBox(height: 16.h),
                                          Text(
                                            'TYPE: ${OrderDisplayFormatter.orderTypeLabel(order.order_type)}',
                                            style: TextStyle(
                                              fontFamily: 'Courier',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          if (tableDisplay.isNotEmpty) ...[
                                            SizedBox(height: 4.h),
                                            Text(
                                              tableDisplay.toUpperCase(),
                                              style: TextStyle(
                                                fontFamily: 'Courier',
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                          if (tableDisplay.isEmpty &&
                                              deliveryAddress.isEmpty) ...[
                                            SizedBox(height: 4.h),
                                            Text(
                                              fulfillmentTitle.toUpperCase(),
                                              style: TextStyle(
                                                fontFamily: 'Courier',
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                          if (order.user != null) ...[
                                            SizedBox(height: 8.h),
                                            Text(
                                              'CUSTOMER: ${order.user!.name}',
                                              style: TextStyle(
                                                fontFamily: 'Courier',
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            if (order.user!.phone.isNotEmpty)
                                              Text(
                                                'PHONE: ${order.user!.phone}',
                                                style: TextStyle(
                                                  fontFamily: 'Courier',
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            if (order.user!.email.isNotEmpty)
                                              Text(
                                                'EMAIL: ${order.user!.email}',
                                                style: TextStyle(
                                                  fontFamily: 'Courier',
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                          ],
                                          if (deliveryAddress.isNotEmpty) ...[
                                            SizedBox(height: 8.h),
                                            Text(
                                              'ADDRESS: $deliveryAddress',
                                              style: TextStyle(
                                                fontFamily: 'Courier',
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                          SizedBox(height: 16.h),
                                          _buildDashedLine(),
                                          SizedBox(height: 16.h),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  'ITEM',
                                                  style: _headerStyle(),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  'QTY',
                                                  textAlign: TextAlign.center,
                                                  style: _headerStyle(),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  'AMT',
                                                  textAlign: TextAlign.right,
                                                  style: _headerStyle(),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8.h),
                                          ...order.items.map((item) {
                                            final itemName =
                                                item.menu_item?.display_name ??
                                                'Item ${item.menu_item_id}';
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 4.h,
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                      itemName,
                                                      style: _itemStyle(),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      OrderDisplayFormatter.quantityText(
                                                        item,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: _itemStyle(),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      item.total_price
                                                          .toStringAsFixed(2),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: _itemStyle(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                          SizedBox(height: 16.h),
                                          _buildDashedLine(),
                                          SizedBox(height: 16.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'TOTAL AMOUNT',
                                                style: _boldStyle(),
                                              ),
                                              Text(
                                                _formatAmount(
                                                  order.total_amount,
                                                ),
                                                style: _boldStyle(),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'FINAL PAYING',
                                                style: _boldStyle(),
                                              ),
                                              Text(
                                                _formatAmount(finalPayingPrice),
                                                style: _boldStyle(),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20.h),
                                          Center(
                                            child: QrImageView(
                                              data:
                                                  '${ApiConstants.BASE_URL}/pos-kds/orders/${order.id}',
                                              version: QrVersions.auto,
                                              size: 100.w,
                                              backgroundColor:
                                                  AppColors.pureWhite,
                                            ),
                                          ),
                                          SizedBox(height: 12.h),
                                          Text(
                                            'THANK YOU FOR YOUR ORDER',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Courier',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (order.status.toUpperCase() == 'PAID')
                                        Positioned.fill(
                                          child: IgnorePointer(
                                            child: Center(
                                              child: Transform.rotate(
                                                angle: -0.5,
                                                child: Text(
                                                  'PAID',
                                                  style: TextStyle(
                                                    fontSize: 80.sp,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.red
                                                        .withOpacity(0.15),
                                                    letterSpacing: 8,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              _buildPrintLogSection(state),
                            ],
                          ),
                        ),
                      ),
                      if (order.status.toUpperCase() != 'PAID')
                        Container(
                          margin: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: AppColors.pureWhite,
                            borderRadius: BorderRadius.circular(16.r),
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
                              Text(
                                'MARK AS PAID',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textTertiary,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              GestureDetector(
                                onTap: _pickPaymentProof,
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9FAFB),
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color: AppColors.borderGrey,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 18.w,
                                        color: AppColors.primaryGreen,
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: Text(
                                          'Attach payment proof (optional)',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (_paymentProofPaths.isNotEmpty) ...[
                                SizedBox(height: 10.h),
                                SizedBox(
                                  height: 58.h,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _paymentProofPaths.length,
                                    separatorBuilder: (context, index) =>
                                        SizedBox(width: 8.w),
                                    itemBuilder: (context, index) {
                                      final path = _paymentProofPaths[index];
                                      return Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              10.r,
                                            ),
                                            child: Image.file(
                                              File(path),
                                              width: 58.w,
                                              height: 58.h,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top: -6.h,
                                            right: -6.w,
                                            child: GestureDetector(
                                              onTap: () =>
                                                  _removePaymentProof(path),
                                              child: Container(
                                                width: 20.w,
                                                height: 20.w,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFEF4F5F),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.close,
                                                  color: AppColors.pureWhite,
                                                  size: 12.w,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _finalPayingPriceController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      onChanged: (_) => setState(() {}),
                                      decoration: InputDecoration(
                                        prefixText: '₹ ',
                                        prefixStyle: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.textPrimary,
                                        ),
                                        hintText: order.total_amount
                                            .toStringAsFixed(2),
                                        hintStyle: TextStyle(
                                          color: AppColors.textTertiary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 14.w,
                                          vertical: 12.h,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                          borderSide: BorderSide(
                                            color: AppColors.borderGrey,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                          borderSide: BorderSide(
                                            color: AppColors.primaryGreen,
                                            width: 1.5,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                          borderSide: BorderSide(
                                            color: AppColors.borderGrey,
                                          ),
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  SizedBox(
                                    width: 130.w,
                                    child: BlocBuilder<PosKdsCubit, PosKdsState>(
                                      builder: (context, payState) {
                                        return ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.primaryGreen,
                                            foregroundColor:
                                                AppColors.pureWhite,
                                            padding: EdgeInsets.symmetric(
                                              vertical: 14.h,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            elevation: 0,
                                          ),
                                          onPressed:
                                              payState.saveOrdersInfo.status ==
                                                  OperationStatus.loading
                                              ? null
                                              : () async {
                                                  final amount =
                                                      double.tryParse(
                                                        _finalPayingPriceController
                                                            .text
                                                            .trim(),
                                                      ) ??
                                                      order.total_amount;
                                                  final cubit = context
                                                      .read<PosKdsCubit>();
                                                  final proofUrls = await cubit
                                                      .uploadPaymentProofs(
                                                        _paymentProofPaths,
                                                      );
                                                  await cubit.payOrder(
                                                    order.id,
                                                    {
                                                      'payment_method': 'CASH',
                                                      'amount': amount,
                                                      'payment_proofs':
                                                          proofUrls,
                                                    },
                                                  );
                                                  if (mounted) {
                                                    setState(
                                                      _paymentProofPaths.clear,
                                                    );
                                                    cubit.getOrder(order.id);
                                                  }
                                                },
                                          child:
                                              payState.saveOrdersInfo.status ==
                                                  OperationStatus.loading
                                              ? SizedBox(
                                                  width: 18.w,
                                                  height: 18.w,
                                                  child:
                                                      const CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color:
                                                            AppColors.pureWhite,
                                                      ),
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .check_circle_outline,
                                                      size: 16.w,
                                                    ),
                                                    SizedBox(width: 6.w),
                                                    Text(
                                                      'Mark Paid',
                                                      style: TextStyle(
                                                        fontSize: 13.sp,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      AppBottomAction(
                        child: AppButton(
                          text: PosConstant.PRINT_BILL,
                          isLoading:
                              state.printReceiptInfo.status ==
                              OperationStatus.loading,
                          onPressed:
                              state.printReceiptInfo.status ==
                                  OperationStatus.loading
                              ? () {}
                              : () {
                                  final amount =
                                      double.tryParse(
                                        _finalPayingPriceController.text.trim(),
                                      ) ??
                                      order.total_amount;
                                  context.read<PosKdsCubit>().printOrderReceipt(
                                    order.copyWith(final_paying_price: amount),
                                  );
                                },
                        ),
                      ),
                    ],
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
