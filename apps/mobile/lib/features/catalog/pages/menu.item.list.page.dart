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

class MenuItemListPage extends StatefulWidget {
  const MenuItemListPage({super.key});

  @override
  State<MenuItemListPage> createState() => _MenuItemListPageState();
}

class _MenuItemListPageState extends State<MenuItemListPage> {
  String _selectedCategoryId = 'all';

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
            _buildCategoryTabs(),
            Expanded(
              child: _buildItemList(),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 62.h),
        child: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.createMenuItem),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Menu Items',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return BlocBuilder<CatalogCubit, CatalogState>(
      builder: (context, state) {
        if (state.menuCategories.isEmpty) return const SizedBox.shrink();
        final categories = state.menuCategories.where((c) => !c.is_deleted).toList();
        
        return Container(
          height: 40.h,
          margin: EdgeInsets.only(bottom: 8.h),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            children: [
              _buildFilterPill('All Items', _selectedCategoryId == 'all', () {
                setState(() => _selectedCategoryId = 'all');
              }),
              SizedBox(width: 8.w),
              ...categories.map((cat) => Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: _buildFilterPill(cat.name, _selectedCategoryId == cat.id, () {
                  setState(() => _selectedCategoryId = cat.id);
                }),
              )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterPill(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.deepOnyx : AppColors.pureWhite,
          border: Border.all(color: isSelected ? AppColors.deepOnyx : AppColors.borderGrey, width: 1.w),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.pureWhite : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildItemList() {
    return BlocBuilder<CatalogCubit, CatalogState>(
      builder: (context, state) {
        if (state.loadMenuItemsInfo.status == OperationStatus.loading &&
            state.menuItems.isEmpty) {
          return const Center(child: AppLoader(size: 24, strokeWidth: 2));
        }

        var items = state.menuItems.where((i) => !i.is_deleted).toList();
        if (_selectedCategoryId != 'all') {
          items = items.where((i) => i.category_id == _selectedCategoryId).toList();
        }

        if (items.isEmpty) {
          return Center(
            child: Text(
              'No items found',
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
            context.read<CatalogCubit>().listMenuItems();
          },
          child: ListView.separated(
            padding: EdgeInsets.all(24.w),
            itemCount: items.length,
            separatorBuilder: (c, i) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final item = items[index];

              return GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.menuItemDetail, arguments: item),
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
                        backgroundImage: item.images.isNotEmpty ? NetworkImage(item.images.first) : null,
                        child: item.images.isEmpty
                            ? Text(
                                item.display_name.isNotEmpty ? item.display_name[0].toUpperCase() : 'I',
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
                              item.display_name,
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
                                    color: item.status == 'ACTIVE' ? AppColors.primaryGreen.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Text(
                                    item.status,
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: item.status == 'ACTIVE' ? AppColors.primaryGreen : AppColors.error,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    'Rs${item.selling_price.toStringAsFixed(0)}',
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
                            if (item.description.isNotEmpty) ...[
                              SizedBox(height: 4.h),
                              Text(
                                item.description,
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
