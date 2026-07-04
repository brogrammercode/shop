import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile/components/ui/loader.dart';
import 'package:mobile/features/inventory/controllers/inventory.cubit.dart';
import 'package:mobile/features/inventory/controllers/inventory.state.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryCubit>().listItemCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: BlocBuilder<InventoryCubit, InventoryState>(
                builder: (context, state) {
                  if (state.loadItemCategoriesInfo.status ==
                          OperationStatus.loading &&
                      state.itemCategories.isEmpty) {
                    return const Center(child: AppLoader());
                  }

                  if (state.itemCategories.isEmpty &&
                      state.loadItemCategoriesInfo.status !=
                          OperationStatus.loading) {
                    return Center(
                      child: Text(
                        'No categories found',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () =>
                        context.read<InventoryCubit>().listItemCategories(),
                    color: AppColors.primaryGreen,
                    child: ListView.separated(
                      padding: EdgeInsets.all(24.w),
                      itemCount: state.itemCategories.length,
                      separatorBuilder: (c, i) => SizedBox(height: 16.h),
                      itemBuilder: (context, index) {
                        final category = state.itemCategories[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.categoryDetail,
                              arguments: category,
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
                              borderRadius: BorderRadius.circular(12.r),
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
                                if (category.images.isNotEmpty)
                                  Container(
                                    width: 48.r,
                                    height: 48.r,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          category.images.first,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    width: 48.r,
                                    height: 48.r,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryGreen.withOpacity(
                                        0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      category.name.isNotEmpty
                                          ? category.name
                                                .substring(0, 1)
                                                .toUpperCase()
                                          : '?',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                        color: AppColors.primaryGreen,
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
                                        category.name,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      if (category.description != null &&
                                          category.description!.isNotEmpty) ...[
                                        SizedBox(height: 4.h),
                                        Text(
                                          category.description!,
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textSecondary,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 62.h),
        child: FloatingActionButton(
          onPressed: () =>
              Navigator.pushNamed(context, AppRoutes.createCategory),
          backgroundColor: AppColors.primaryGreen,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: AppColors.pureWhite),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Text(
            'Categories',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
