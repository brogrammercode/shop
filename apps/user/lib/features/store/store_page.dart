import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/components/ui/button.dart';
import 'package:user/core/color.dart';
import 'package:user/core/di.dart';
import 'package:user/utils/error.dart';
import 'store.cubit.dart';
import 'store.state.dart';
import 'menu.model.dart';
import 'store_details_header.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppDependencies.storeCubit..fetchMenu(),
      child: const _StorePageView(),
    );
  }
}

class _StorePageView extends StatefulWidget {
  const _StorePageView();

  @override
  State<_StorePageView> createState() => _StorePageViewState();
}

class _StorePageViewState extends State<_StorePageView> {
  int cartItemCount = 0;
  double cartTotalPrice = 0.0;
  String? addedDishImageUrl;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: statusBarHeight + 10.h),
                const StoreDetailsHeader(),
                BlocBuilder<StoreCubit, StoreState>(
                  builder: (context, state) {
                    if (state.loadMenuInfo.status == OperationStatus.loading) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.h),
                          child: const CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (state.loadMenuInfo.status == OperationStatus.error) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.h),
                          child: const Text('Failed to load menu'),
                        ),
                      );
                    }
                    
                    if (state.menuCategories.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.h),
                          child: const Text('Menu is empty'),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: state.menuCategories.map((category) {
                        return _MenuCategorySection(
                          category: category,
                          onItemAdded: (qty, price, imageUrl) {
                            setState(() {
                              cartItemCount = qty;
                              cartTotalPrice = price;
                              addedDishImageUrl = imageUrl;
                            });
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
                SizedBox(height: cartItemCount > 0 ? 160.h : 100.h),
              ],
            ),
          ),
          _buildFloatingMenuButton(),
          if (cartItemCount > 0) _buildBottomCartBar(),
        ],
      ),
    );
  }

  Widget _buildFloatingMenuButton() {
    return Positioned(
      bottom: cartItemCount > 0 ? 130.h : 24.h,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.deepOnyx,
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.restaurant_menu, color: AppColors.pureWhite, size: 16.w),
              SizedBox(width: 8.w),
              Text(
                'Menu',
                style: TextStyle(color: AppColors.pureWhite, fontSize: 13.sp, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomCartBar() {
    return Positioned(
      bottom: 16.h,
      left: 16.w,
      right: 16.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE3F2FD), Color(0xFFF1F8E9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              border: const Border(
                top: BorderSide(color: Color(0xFFBBDEFB)),
                left: BorderSide(color: Color(0xFFBBDEFB)),
                right: BorderSide(color: Color(0xFFBBDEFB)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: const BoxDecoration(color: Color(0xFF2563EB), shape: BoxShape.circle),
                  child: Icon(Icons.percent, color: AppColors.pureWhite, size: 10.w),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Unlock Flat ₹40 OFF',
                        style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w800, color: const Color(0xFF1E3A8A)),
                      ),
                      Text(
                        'Add items worth ₹46 or more to unlock',
                        style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.keyboard_arrow_up, color: const Color(0xFF1E3A8A), size: 16.w),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/cart');
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.r)),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (addedDishImageUrl != null)
                        Container(
                          width: 32.w,
                          height: 32.w,
                          margin: EdgeInsets.only(right: 10.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.r),
                            image: DecorationImage(image: NetworkImage(addedDishImageUrl!), fit: BoxFit.cover),
                          ),
                        ),
                      Text(
                        '$cartItemCount ${cartItemCount == 1 ? "item" : "items"} added',
                        style: TextStyle(color: AppColors.pureWhite, fontSize: 13.sp, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'View cart',
                        style: TextStyle(color: AppColors.pureWhite, fontSize: 13.sp, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(width: 4.w),
                      Icon(Icons.chevron_right, color: AppColors.pureWhite, size: 16.w),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuCategorySection extends StatefulWidget {
  final MenuCategory category;
  final void Function(int qty, double price, String? imageUrl) onItemAdded;

  const _MenuCategorySection({required this.category, required this.onItemAdded});

  @override
  State<_MenuCategorySection> createState() => _MenuCategorySectionState();
}

class _MenuCategorySectionState extends State<_MenuCategorySection> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    if (widget.category.items.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.category.name,
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.textPrimary,
                  size: 24.w,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.category.items.length,
            itemBuilder: (context, index) {
              final item = widget.category.items[index];
              return _MenuItemListItem(item: item, onItemAdded: widget.onItemAdded);
            },
          ),
      ],
    );
  }
}

class _MenuItemListItem extends StatelessWidget {
  final MenuItem item;
  final void Function(int qty, double price, String? imageUrl) onItemAdded;

  const _MenuItemListItem({required this.item, required this.onItemAdded});

  void _showAddDialog(BuildContext context) {
    // Simple add mock for the refactored code without customization modal.
    onItemAdded(1, item.selling_price.toDouble(), item.image_url);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderGrey, width: 1.h)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 14.w,
                  height: 14.w,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 1.5),
                    color: AppColors.pureWhite,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  item.display_name,
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                SizedBox(height: 8.h),
                Text(
                  '₹${item.selling_price}',
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                if (item.description != null && item.description!.isNotEmpty) ...[
                  SizedBox(height: 6.h),
                  Text(
                    item.description!,
                    style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary, height: 1.4),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 16.w),
          Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      color: AppColors.softGrey,
                      borderRadius: BorderRadius.circular(16.r),
                      image: item.image_url != null
                          ? DecorationImage(image: NetworkImage(item.image_url!), fit: BoxFit.cover)
                          : null,
                    ),
                    child: item.image_url == null
                        ? Icon(Icons.fastfood, color: AppColors.textSecondary, size: 40.w)
                        : null,
                  ),
                  Positioned(
                    bottom: -15.h,
                    child: Container(
                      width: 90.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: AppColors.primaryGreen, width: 1.w),
                        boxShadow: const [
                          BoxShadow(color: AppColors.shadowColor, blurRadius: 4, offset: Offset(0, 2)),
                        ],
                      ),
                      child: AppButton(
                        onPressed: () => _showAddDialog(context),
                        backgroundColor: const Color(0xFFE8F5E9),
                        textColor: AppColors.primaryGreen,
                        text: 'ADD',
                        padding: EdgeInsets.zero,
                        isFullWidth: false,
                        height: 36.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ADD',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(Icons.add, color: AppColors.primaryGreen, size: 14.w),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ],
      ),
    );
  }
}
