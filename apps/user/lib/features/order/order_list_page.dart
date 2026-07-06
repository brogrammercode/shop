import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/components/ui/button.dart';
import 'package:user/core/color.dart';
import 'package:user/features/order/order.model.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final List<OrderModel> _dummyOrders = [
    OrderModel(
      id: 'ord_123',
      code: '8294',
      status: 'Delivered',
      date: '2026-07-01 19:30',
      totalAmount: 499.0,
      restaurantName: 'Adarsh Jalpan',
      restaurantImageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=200',
      itemSummaries: ['1x Veg Pizza', '2x Coke'],
    ),
    OrderModel(
      id: 'ord_124',
      code: '4112',
      status: 'Preparing',
      date: '2026-07-05 20:15',
      totalAmount: 249.0,
      restaurantName: 'Kwality Walls',
      restaurantImageUrl: 'https://images.unsplash.com/photo-1559703248-dcaaec9fab78?w=200',
      itemSummaries: ['1x Chocolate Ice Cream', '1x Vanilla Scoop'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Column(
        children: [
          SizedBox(height: statusBarHeight),
          _buildAppBar(context),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              itemCount: _dummyOrders.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(context, _dummyOrders[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
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
          Text(
            'Your Orders',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    final bool isDelivered = order.status.toLowerCase() == 'delivered';
    
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/order-detail', arguments: order);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(16.r),
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
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      image: DecorationImage(
                        image: NetworkImage(order.restaurantImageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                order.restaurantName,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: isDelivered ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                order.status,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w800,
                                  color: isDelivered ? AppColors.primaryGreen : Colors.orange[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '₹${order.totalAmount.toStringAsFixed(0)} • ${order.date}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Code: ${order.code}', // Displaying the code as requested
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 1.h, color: AppColors.borderGrey),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ITEMS',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    order.itemSummaries.join(', '),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          onPressed: () {}, // Dummy reorder functionality
                          backgroundColor: const Color(0xFFF5F5F5),
                          textColor: AppColors.textPrimary,
                          text: 'REORDER',
                          height: 40.h,
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
    );
  }
}
