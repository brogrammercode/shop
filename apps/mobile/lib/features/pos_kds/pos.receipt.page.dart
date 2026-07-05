import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/button.dart';
import 'controllers/pos_kds.cubit.dart';
import 'controllers/pos_kds.state.dart';

class PosReceiptPage extends StatelessWidget {
  const PosReceiptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosKdsCubit, PosKdsState>(
      builder: (context, state) {
        final order = state.lastPlacedOrder;

        if (order == null) {
          return const Scaffold(body: Center(child: Text('No order found')));
        }
        final finalPayingPrice = order.final_paying_price > 0
            ? order.final_paying_price
            : order.total_amount;

        return Scaffold(
          backgroundColor: const Color(0xFFF3F4F6),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24.w),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'ORDER RECEIPT',
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
                            'ORDER ID: ${order.id.toUpperCase()}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Courier',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "DATE: ${DateTime.parse(order.created_at).toLocal().toString().substring(0, 16)}",
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'TYPE: ${order.order_type}',
                                style: TextStyle(
                                  fontFamily: 'Courier',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              if (order.table_id.isNotEmpty)
                                Text(
                                  'TABLE: ${order.table_id}',
                                  style: TextStyle(
                                    fontFamily: 'Courier',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                            ],
                          ),
                          if (order.delivery_address_id.isNotEmpty) ...[
                            SizedBox(height: 8.h),
                            Text(
                              'ADDRESS: ${order.delivery_address_id}',
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
                                child: Text('ITEM', style: _headerStyle()),
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
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.h),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Item ${item.menu_item_id}',
                                      style: _itemStyle(),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      '${item.qty}',
                                      textAlign: TextAlign.center,
                                      style: _itemStyle(),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      item.total_price.toStringAsFixed(2),
                                      textAlign: TextAlign.right,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('TOTAL AMOUNT', style: _boldStyle()),
                              Text(
                                'Rs${order.total_amount.toStringAsFixed(2)}',
                                style: _boldStyle(),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('FINAL PAYING', style: _boldStyle()),
                              Text(
                                'Rs${finalPayingPrice.toStringAsFixed(2)}',
                                style: _boldStyle(),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
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
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.pureWhite,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            side: BorderSide(color: AppColors.textPrimary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'New Order',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: AppButton(
                          text: 'Print Receipt',
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Printing receipt...'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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

  TextStyle _headerStyle() {
    return TextStyle(
      fontFamily: 'Courier',
      fontSize: 14.sp,
      fontWeight: FontWeight.w800,
    );
  }

  TextStyle _itemStyle() {
    return TextStyle(
      fontFamily: 'Courier',
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle _boldStyle() {
    return TextStyle(
      fontFamily: 'Courier',
      fontSize: 16.sp,
      fontWeight: FontWeight.w900,
    );
  }
}
