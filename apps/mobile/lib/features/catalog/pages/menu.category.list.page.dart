import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/app_refresher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/catalog/controllers/catalog.cubit.dart';
import 'package:mobile/features/catalog/controllers/catalog.state.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile/components/ui/loader.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/features/catalog/constants/catalog.constant.dart';

class MenuCategoryListPage extends StatefulWidget {
  const MenuCategoryListPage({super.key});

  @override
  State<MenuCategoryListPage> createState() => _MenuCategoryListPageState();
}

class _MenuCategoryListPageState extends State<MenuCategoryListPage> {
  bool _showInactive = false;

  @override
  void initState() {
    super.initState();
    context.read<CatalogCubit>().listMenuCategories();
    context.read<CatalogCubit>().listMenuItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(context),
            _buildPageTitle(),
            Expanded(
              child: _buildCategoryList(),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 62.h),
        child: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.createMenuCategory),
          backgroundColor: AppColors.primaryGreen,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: AppColors.pureWhite),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Icon(
          Icons.arrow_back,
          color: AppColors.textPrimary,
          size: 24.w,
        ),
      ),
    );
  }

  Widget _buildPageTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Menu Categories',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Manage your menu categories',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('Show Inactive', style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
              SizedBox(width: 8.w),
              Switch(
                value: _showInactive,
                onChanged: (val) => setState(() => _showInactive = val),
                activeColor: AppColors.primaryGreen,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return BlocBuilder<CatalogCubit, CatalogState>(
      builder: (context, state) {
        if (state.loadMenuCategoriesInfo.status == OperationStatus.loading &&
            state.menuCategories.isEmpty) {
          return const Center(child: AppLoader(size: 24, strokeWidth: 2));
        }

        final categories = state.menuCategories.where((c) => !c.is_deleted && (_showInactive || c.status == CatalogConstant.ACTIVE)).toList();

        if (categories.isEmpty) {
          return Center(
            child: Text(
              'No categories found',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        return AppRefresher(
          onRefresh: () async {
            context.read<CatalogCubit>().listMenuCategories();
            context.read<CatalogCubit>().listMenuItems();
          },
          child: ListView.separated(
            padding: EdgeInsets.all(24.w),
            itemCount: categories.length,
            separatorBuilder: (c, i) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final category = categories[index];
              final itemsCount = state.menuItems.where((i) => i.category_id == category.id && !i.is_deleted).length;

              return GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.menuCategoryDetail, arguments: category),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                  decoration: BoxDecoration(
                    color: AppColors.pureWhite,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.borderGrey, width: 1.w),
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
                      CircleAvatar(
                        radius: 24.r,
                        backgroundColor: AppColors.primaryGreen.withOpacity(0.2),
                        backgroundImage: category.images.isNotEmpty ? NetworkImage(category.images.first) : null,
                        child: category.images.isEmpty
                            ? Text(
                                category.name.isNotEmpty ? category.name[0].toUpperCase() : 'C',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp,
                                ),
                              )
                            : null,
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.name,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: category.status == 'ACTIVE' ? AppColors.primaryGreen.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Text(
                                    category.status,
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: category.status == 'ACTIVE' ? AppColors.primaryGreen : AppColors.error,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    '$itemsCount Items',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.right,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            if (category.description.isNotEmpty) ...[
                              SizedBox(height: 4.h),
                              Text(
                                category.description,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.chevron_right,
                        color: AppColors.textTertiary,
                        size: 18.w,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
