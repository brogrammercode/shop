import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/pos_kds/constants/pos.constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/pos_kds/pos_kds.cubit.dart';
import 'package:mobile/features/pos_kds/pos_kds.state.dart';
import 'package:mobile/utils/error.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  @override
  void initState() {
    super.initState();
    context.read<PosKdsCubit>().listOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(PosConstant.ORDER_LIST_TITLE, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: BlocBuilder<PosKdsCubit, PosKdsState>(
        builder: (context, state) {
          if (state.loadOrdersInfo.status == OperationStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders = state.orders;
          if (orders.isEmpty) {
            return Center(child: Text('No orders found', style: TextStyle(color: AppColors.textSecondary)));
          }
          return ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: orders.length,
            separatorBuilder: (c, i) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final order = orders[index];
              return GestureDetector(
                onTap: () {
                  context.read<PosKdsCubit>().getOrder(order.id);
                  Navigator.pushNamed(context, '/order-detail');
                },
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(border: Border.all(color: AppColors.borderGrey), borderRadius: BorderRadius.circular(12.r)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('#${order.id.length > 8 ? order.id.substring(order.id.length - 8) : order.id}', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                          Text('\$${order.total_amount}', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w900, color: AppColors.primaryGreen)),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(order.order_type, style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
