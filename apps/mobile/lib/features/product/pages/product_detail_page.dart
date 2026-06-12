import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/color.dart';
import '../../../core/widgets/action_bottom_sheet.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softGrey,
      body: SafeArea(
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            final product = state.products.firstWhere(
              (p) => p.id == productId,
              orElse: () => throw Exception('Product not found'),
            );

            return Column(
              children: [
                _buildAppBar(context, product.name),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (product.images.isNotEmpty)
                          SizedBox(
                            height: 250.h,
                            child: PageView.builder(
                              itemCount: product.images.length,
                              itemBuilder: (context, index) {
                                return Image.network(
                                  product.images[index],
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          )
                        else
                          Container(
                            height: 200.h,
                            color: AppColors.pureWhite,
                            child: Icon(Icons.fastfood, color: AppColors.textTertiary, size: 64.w),
                          ),
                        Container(
                          color: AppColors.pureWhite,
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      product.name,
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  if (product.is_veg)
                                    Container(
                                      padding: EdgeInsets.all(4.w),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.green),
                                        borderRadius: BorderRadius.circular(4.r),
                                      ),
                                      child: Icon(Icons.circle, color: Colors.green, size: 12.w),
                                    ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                '₹${product.price}',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                children: [
                                  _buildInfoChip('Stock: ${product.stock}'),
                                  SizedBox(width: 8.w),
                                  _buildInfoChip(product.is_available ? 'Available' : 'Unavailable', 
                                      color: product.is_available ? AppColors.primaryGreen : Colors.red),
                                ],
                              ),
                              SizedBox(height: 16.h),
                              if (product.description.isNotEmpty) ...[
                                Text(
                                  'Description',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  product.description,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.textSecondary,
                                    height: 1.5,
                                  ),
                                ),
                              ],
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

  Widget _buildInfoChip(String label, {Color color = AppColors.textSecondary}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.softGrey,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: color),
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
                title: 'Product Options',
                subtitle: 'Manage this product',
                actions: [
                  BottomSheetAction(
                    icon: Icons.edit,
                    label: 'Edit Product',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to edit product page
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