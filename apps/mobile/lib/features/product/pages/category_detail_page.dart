import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/color.dart';
import '../../../core/widgets/action_bottom_sheet.dart';
import '../models/product_category.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';

class CategoryDetailPage extends StatefulWidget {
  final String categoryId;

  const CategoryDetailPage({super.key, required this.categoryId});

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().loadSubCategories(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          behavior: HitTestBehavior.opaque,
          child: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24.w),
        ),
        title: Text(
          'Details',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              final category = state.categories.firstWhere(
                (c) => c.id == widget.categoryId,
                orElse: () => throw Exception('Category not found'),
              );
              return GestureDetector(
                onTap: () {
                  ActionBottomSheet.show(
                    context,
                    groups: [
                      BottomSheetActionGroup(
                        actions: [
                          BottomSheetAction(
                            icon: Icons.edit,
                            label: 'Edit Category',
                            onTap: () {
                              Navigator.pushNamed(context, '/create-category', arguments: {
                                'branchId': category.branch_id,
                                'category': category,
                              });
                            },
                          ),
                          BottomSheetAction(
                            icon: Icons.add_circle_outline,
                            label: 'Add Sub-Category',
                            onTap: () {
                              Navigator.pushNamed(context, '/create-sub-category', arguments: widget.categoryId);
                            },
                          ),
                        ],
                      )
                    ],
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: Icon(Icons.more_vert, color: AppColors.textPrimary, size: 24.w),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          final category = state.categories.firstWhere(
            (c) => c.id == widget.categoryId,
            orElse: () => throw Exception('Category not found'),
          );
          
          final subCategories = state.subCategories
              .where((sub) => sub.category_id == widget.categoryId)
              .toList();

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 24.h),
                          _buildHeroImage(category),
                          SizedBox(height: 32.h),
                          _buildTitleAndDescription(category),
                          SizedBox(height: 32.h),
                          _buildSubCategoriesSection(context, subCategories),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildBottomButton(context, category),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroImage(ProductCategoryModel category) {
    return Center(
      child: Container(
        width: 200.w,
        height: 200.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: ClipOval(
          child: category.images.isNotEmpty
              ? Image.network(
                  category.images.first,
                  fit: BoxFit.cover,
                )
              : Container(
                  color: const Color(0xFFF0F0F0),
                  child: Center(
                    child: Icon(Icons.category, color: AppColors.textTertiary, size: 80.w),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTitleAndDescription(ProductCategoryModel category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          category.name,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        if (category.description.isNotEmpty) ...[
          SizedBox(height: 12.h),
          Text(
            category.description,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.normal,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildSubCategoriesSection(BuildContext context, List<dynamic> subCategories) {
    if (subCategories.isEmpty) {
      return Center(
        child: Text(
          'No sub-categories yet.',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textTertiary,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SUB-CATEGORIES',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textTertiary,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 0.75,
          ),
          itemCount: subCategories.length,
          itemBuilder: (context, index) {
            final sub = subCategories[index];
            return GestureDetector(
              onTap: () {
                ActionBottomSheet.show(
                  context,
                  groups: [
                    BottomSheetActionGroup(
                      actions: [
                        BottomSheetAction(
                          icon: Icons.edit,
                          label: 'Edit Sub-Category',
                          onTap: () {
                            Navigator.pushNamed(context, '/create-sub-category', arguments: {
                              'categoryId': widget.categoryId,
                              'subCategory': sub,
                            });
                          },
                        ),
                      ],
                    )
                  ],
                );
              },
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            sub.name,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.more_vert,
                          color: AppColors.textPrimary,
                          size: 18.w,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Center(
                        child: sub.images.isNotEmpty
                            ? Image.network(
                                sub.images.first,
                                fit: BoxFit.contain,
                              )
                            : Icon(Icons.category, color: AppColors.textTertiary, size: 48.w),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.local_fire_department, color: const Color(0xFFFF7A45), size: 14.w),
                            SizedBox(width: 4.w),
                            Text(
                              '100 Kal',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '\$20.00',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFFFFD54F),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context, ProductCategoryModel category) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, MediaQuery.of(context).padding.bottom + 16.h),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-category', arguments: {
            'branchId': category.branch_id,
            'category': category,
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF111111),
          padding: EdgeInsets.symmetric(vertical: 20.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Edit Category',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.pureWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}