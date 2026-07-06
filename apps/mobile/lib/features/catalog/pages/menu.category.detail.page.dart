import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/features/catalog/models/menu_category.model.dart';
import 'package:mobile/core/widgets/action_bottom_sheet.dart';
import 'package:mobile/features/catalog/controllers/catalog.cubit.dart';
import 'package:mobile/features/catalog/controllers/catalog.state.dart';

class MenuCategoryDetailPage extends StatelessWidget {
  const MenuCategoryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final category =
        ModalRoute.of(context)!.settings.arguments as MenuCategoryModel;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: BlocBuilder<CatalogCubit, CatalogState>(
        builder: (context, state) {
          final items = state.menuItems
              .where((i) => i.category_id == category.id && !i.is_deleted)
              .toList();
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: category.images.isNotEmpty ? 240.h : 100.h,
                pinned: true,
                backgroundColor: AppColors.pureWhite,
                iconTheme: const IconThemeData(color: AppColors.textPrimary),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    category.name,
                    style: TextStyle(
                      color: category.images.isNotEmpty
                          ? AppColors.pureWhite
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 18.sp,
                    ),
                  ),
                  background: category.images.isNotEmpty
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              category.images.first,
                              fit: BoxFit.cover,
                            ),
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
                      color: category.images.isNotEmpty
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
                                label: 'Edit Category',
                                icon: Icons.edit,
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                    context,
                                    '/create-menu-category',
                                    arguments: category,
                                  );
                                },
                              ),
                              BottomSheetAction(
                                label: 'Add Menu Item',
                                icon: Icons.add,
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.createMenuItem,
                                    arguments: category,
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
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.pureWhite,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: AppColors.borderGrey),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.shadowColor,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.fastfood,
                                  size: 14.w,
                                  color: AppColors.primaryGreen,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  '${items.length} Items',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: category.status == 'ACTIVE'
                                  ? AppColors.primaryGreen.withOpacity(0.1)
                                  : AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              category.status,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w800,
                                color: category.status == 'ACTIVE'
                                    ? AppColors.primaryGreen
                                    : AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (category.description.isNotEmpty) ...[
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
                          category.description,
                          style: TextStyle(
                            fontSize: 11.sp,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                      SizedBox(height: 32.h),
                      Text(
                        'MENU ITEMS',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textTertiary,
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      if (items.isEmpty)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.h),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.restaurant_menu,
                                  size: 32.w,
                                  color: AppColors.borderGrey,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'No items in this category',
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
                          itemCount: items.length,
                          separatorBuilder: (c, i) => SizedBox(height: 16.h),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.menuItemDetail,
                                  arguments: item,
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(12.w),
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
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    if (item.images.isNotEmpty)
                                      Container(
                                        width: 56.w,
                                        height: 56.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              item.images.first,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    else
                                      Container(
                                        width: 56.w,
                                        height: 56.w,
                                        decoration: BoxDecoration(
                                          color: AppColors.softGrey,
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          item.display_name.isNotEmpty
                                              ? item.display_name
                                                    .substring(0, 1)
                                                    .toUpperCase()
                                              : '?',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 18.sp,
                                            color: AppColors.textTertiary,
                                          ),
                                        ),
                                      ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.display_name,
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          if (item.description.isNotEmpty) ...[
                                            SizedBox(height: 4.h),
                                            Text(
                                              item.description,
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.textSecondary,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                          SizedBox(height: 8.h),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                              vertical: 2.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryGreen
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(6.r),
                                            ),
                                            child: Text(
                                              '₹ ${item.selling_price}',
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.primaryGreen,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: AppColors.textTertiary,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(
          context,
          AppRoutes.createMenuItem,
          arguments: category,
        ),
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.add, color: AppColors.pureWhite),
        label: Text(
          'Add Item',
          style: TextStyle(
            color: AppColors.pureWhite,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
