import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/color.dart';
import '../../../core/widgets/action_bottom_sheet.dart';
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
      backgroundColor: AppColors.softGrey,
      body: SafeArea(
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            final category = state.categories.firstWhere(
              (c) => c.id == widget.categoryId,
              orElse: () => throw Exception('Category not found'),
            );
            
            final subCategories = state.subCategories
                .where((sub) => sub.category_id == widget.categoryId)
                .toList();

            return Column(
              children: [
                _buildAppBar(context, category.name),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (category.images.isNotEmpty)
                          Image.network(
                            category.images.first,
                            height: 200.h,
                            fit: BoxFit.cover,
                          ),
                        Container(
                          color: AppColors.pureWhite,
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.name,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              if (category.description.isNotEmpty)
                                Text(
                                  category.description,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          color: AppColors.pureWhite,
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sub-Categories',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              if (subCategories.isEmpty)
                                Text(
                                  'No sub-categories added yet.',
                                  style: TextStyle(color: AppColors.textTertiary, fontSize: 14.sp),
                                )
                              else
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 0.8,
                                    crossAxisSpacing: 16.w,
                                    mainAxisSpacing: 16.h,
                                  ),
                                  itemCount: subCategories.length,
                                  itemBuilder: (context, index) {
                                    final sub = subCategories[index];
                                    return GestureDetector(
                                      onTap: () {
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 72.w,
                                            height: 72.w,
                                            decoration: BoxDecoration(
                                              color: AppColors.pureWhite,
                                              shape: BoxShape.circle,
                                              boxShadow: const [
                                                BoxShadow(color: AppColors.shadowColor, blurRadius: 4, offset: Offset(0, 2)),
                                              ],
                                              image: sub.images.isNotEmpty
                                                  ? DecorationImage(image: NetworkImage(sub.images.first), fit: BoxFit.cover)
                                                  : null,
                                            ),
                                            child: sub.images.isEmpty
                                                ? Icon(Icons.category, color: AppColors.textTertiary, size: 32.w)
                                                : null,
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            sub.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.textPrimary,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, String title) {
    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(
                color: AppColors.pureWhite,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: AppColors.shadowColor, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: Icon(Icons.chevron_left, color: AppColors.textPrimary, size: 24.w),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () {
              ActionBottomSheet.show(
                context,
                title: 'Category Options',
                subtitle: 'Manage this category',
                actions: [
                  BottomSheetAction(
                    icon: Icons.add_circle_outline,
                    label: 'Add Sub-Category',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/create-sub-category', arguments: widget.categoryId);
                    },
                  ),
                ],
              );
            },
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(
                color: AppColors.pureWhite,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: AppColors.shadowColor, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: Icon(Icons.more_vert, color: AppColors.textPrimary, size: 20.w),
            ),
          ),
        ],
      ),
    );
  }
}