import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/core/color.dart';
import 'package:user/features/order/order.model.dart';
import 'package:user/features/order/components/receipt_widget.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderModel order = ModalRoute.of(context)!.settings.arguments as OrderModel;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Column(
        children: [
          SizedBox(height: statusBarHeight),
          _buildAppBar(context, order),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusHeader(order),
                  SizedBox(height: 16.h),
                  ReceiptWidget(order: order),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, OrderModel order) {
    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              'Order ${order.id}',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusHeader(OrderModel order) {
    return Container(
      width: double.infinity,
      color: AppColors.pureWhite,
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Icon(
            Icons.check_circle,
            color: AppColors.primaryGreen,
            size: 64.w,
          ),
          SizedBox(height: 16.h),
          Text(
            order.status,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Restaurant: ${order.restaurantName}',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
