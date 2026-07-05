import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/features/catalog/models/menu_item.model.dart';
import 'package:mobile/core/widgets/action_bottom_sheet.dart';
import 'package:mobile/features/pos_kds/controllers/pos_kds.cubit.dart';
import 'package:mobile/features/pos_kds/controllers/pos_kds.state.dart';

class MenuItemDetailPage extends StatefulWidget {
  const MenuItemDetailPage({super.key});

  @override
  State<MenuItemDetailPage> createState() => _MenuItemDetailPageState();
}

class _MenuItemDetailPageState extends State<MenuItemDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PosKdsCubit>().listOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)!.settings.arguments as MenuItemModel;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: BlocBuilder<PosKdsCubit, PosKdsState>(
        builder: (context, posState) {
          final ordersWithItem = posState.orders
              .where((o) => o.items.any((i) => i.menu_item_id == item.id))
              .toList();
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: item.images.isNotEmpty ? 240.h : 100.h,
                pinned: true,
                backgroundColor: AppColors.pureWhite,
                iconTheme: const IconThemeData(color: AppColors.textPrimary),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    item.display_name,
                    style: TextStyle(
                      color: item.images.isNotEmpty
                          ? AppColors.pureWhite
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 18.sp,
                    ),
                  ),
                  background: item.images.isNotEmpty
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(item.images.first, fit: BoxFit.cover),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.8),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : null,
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: item.images.isNotEmpty
                          ? AppColors.pureWhite
                          : AppColors.textPrimary,
                    ),
                    onPressed: () {
                      ActionBottomSheet.show(
                        context,
                        groups: [
                          BottomSheetActionGroup(
                            actions: [
                              BottomSheetAction(
                                label: 'Edit Item',
                                icon: Icons.edit,
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                    context,
                                    '/create-menu-item',
                                    arguments: item,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGreen,
                              borderRadius: BorderRadius.circular(8.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryGreen.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              'Rs${item.selling_price}',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w900,
                                color: AppColors.pureWhite,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: item.status == 'ACTIVE'
                                  ? AppColors.primaryGreen.withOpacity(0.1)
                                  : AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              item.status,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w800,
                                color: item.status == 'ACTIVE'
                                    ? AppColors.primaryGreen
                                    : AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (item.description.isNotEmpty) ...[
                        SizedBox(height: 24.h),
                        Text(
                          'DESCRIPTION',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textTertiary,
                            letterSpacing: 0.8,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          item.description,
                          style: TextStyle(
                            fontSize: 11.sp,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                      SizedBox(height: 32.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ORDERS WITH THIS ITEM',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textTertiary,
                              letterSpacing: 0.8,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.softGrey,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              '${ordersWithItem.length}',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      if (ordersWithItem.isEmpty)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.h),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.receipt_long,
                                  size: 32.w,
                                  color: AppColors.borderGrey,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'No orders contain this item',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: ordersWithItem.length,
                          separatorBuilder: (c, i) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            final order = ordersWithItem[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.orderDetail,
                                  arguments: order,
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: AppColors.pureWhite,
                                  border: Border.all(
                                    color: AppColors.borderGrey,
                                    width: 1.w,
                                  ),
                                  borderRadius: BorderRadius.circular(8.r),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppColors.shadowColor,
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 40.w,
                                          height: 40.w,
                                          decoration: BoxDecoration(
                                            color: AppColors.softGrey,
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.receipt,
                                            color: AppColors.textSecondary,
                                            size: 20.w,
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Order #${order.id.substring(0, 8)}',
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              order.order_type,
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: order.status == 'COMPLETED'
                                            ? AppColors.primaryGreen
                                                  .withOpacity(0.1)
                                            : AppColors.gold.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(
                                          6.r,
                                        ),
                                      ),
                                      child: Text(
                                        order.status,
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w900,
                                          color: order.status == 'COMPLETED'
                                              ? AppColors.primaryGreen
                                              : AppColors.goldDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
