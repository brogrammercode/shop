import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/color.dart';
import '../../../core/widgets/action_bottom_sheet.dart';
import '../../../utils/error.dart';
import '../models/product.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

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
              final product = state.products.firstWhere(
                (p) => p.id == productId,
                orElse: () => throw Exception('Product not found'),
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
                            label: 'Edit Product',
                            onTap: () {
                              Navigator.pushNamed(context, '/create-product', arguments: {
                                'branchId': product.branch_id,
                                'product': product,
                              });
                            },
                          ),
                          BottomSheetAction(
                            icon: Icons.add_circle_outline,
                            label: 'Add Sub-Product',
                            onTap: () {
                              _showSubProductSelector(context, product);
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
          final product = state.products.firstWhere(
            (p) => p.id == productId,
            orElse: () => throw Exception('Product not found'),
          );

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
                          _buildHeroImage(product),
                          SizedBox(height: 32.h),
                          _buildTitleAndDescription(product),
                          SizedBox(height: 24.h),
                          _buildMetricsRow(product),
                          SizedBox(height: 32.h),
                          _buildIngredientsSection(context, product),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildBottomButton(context, product),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroImage(ProductModel product) {
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
          child: product.images.isNotEmpty
              ? Image.network(
                  product.images.first,
                  fit: BoxFit.cover,
                )
              : Container(
                  color: const Color(0xFFF0F0F0),
                  child: Center(
                    child: Icon(Icons.fastfood, color: AppColors.textTertiary, size: 80.w),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTitleAndDescription(ProductModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          product.name,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        if (product.description.isNotEmpty) ...[
          SizedBox(height: 12.h),
          Text(
            product.description,
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

  Widget _buildMetricsRow(ProductModel product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMetricItem(
          icon: Icons.star,
          iconColor: const Color(0xFFFFB020),
          text: '4.5',
        ),
        _buildMetricItem(
          icon: Icons.local_fire_department,
          iconColor: const Color(0xFFFF5252),
          text: '${product.stock} Left',
        ),
        _buildMetricItem(
          icon: Icons.monetization_on,
          iconColor: const Color(0xFF4CAF50),
          text: '₹${product.price}',
        ),
      ],
    );
  }

  Widget _buildMetricItem({required IconData icon, required Color iconColor, required String text}) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20.w),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsSection(BuildContext context, ProductModel product) {
    if (product.supported_sub_products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingredients',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: product.supported_sub_products.map((sp) {
              return GestureDetector(
                onTap: () {
                  ActionBottomSheet.show(
                    context,
                    groups: [
                      BottomSheetActionGroup(
                        actions: [
                          BottomSheetAction(
                            icon: Icons.edit,
                            label: 'Edit Sub-Product',
                            onTap: () {
                              Navigator.pushNamed(context, '/create-product', arguments: {
                                'branchId': sp.branch_id,
                                'product': sp,
                                'isSubProduct': true,
                              });
                            },
                          ),
                          BottomSheetAction(
                            icon: Icons.link_off,
                            label: 'Remove from Product',
                            onTap: () {
                              final updatedLinked = product.supported_sub_products
                                  .map((e) => e.id)
                                  .where((id) => id != sp.id)
                                  .toList();
                              context.read<ProductCubit>().updateProduct(product.id, {'supported_sub_products': updatedLinked});
                            },
                          ),
                        ],
                      )
                    ],
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(right: 12.w),
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Center(
                    child: sp.images.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.network(sp.images.first, width: 40.w, height: 40.w, fit: BoxFit.cover),
                          )
                        : Icon(Icons.fastfood, color: AppColors.textTertiary, size: 28.w),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context, ProductModel product) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, MediaQuery.of(context).padding.bottom + 16.h),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-product', arguments: {
            'branchId': product.branch_id,
            'product': product,
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
              'Edit Product',
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

  void _showSubProductSelector(BuildContext context, ProductModel product) {
    context.read<ProductCubit>().loadSubProducts(product.branch_id);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.pureWhite,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 24.h),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Select Sub-Product',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: BlocBuilder<ProductCubit, ProductState>(
                  builder: (context, state) {
                    if (state.loadSubProductsInfo.status == OperationStatus.loading) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen));
                    }
                    if (state.subProducts.isEmpty) {
                      return Center(
                        child: Text(
                          'No existing sub-products found.',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: state.subProducts.length,
                      separatorBuilder: (ctx, idx) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final sp = state.subProducts[index];
                        final isAlreadyLinked = product.supported_sub_products.any((element) => element.id == sp.id);
                        return ListTile(
                          title: Text(sp.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                          subtitle: Text('₹${sp.price}/${sp.unit}', style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp)),
                          trailing: isAlreadyLinked
                              ? const Icon(Icons.check_circle, color: AppColors.primaryGreen)
                              : ElevatedButton(
                                  onPressed: () {
                                    final updatedLinked = product.supported_sub_products.map((e) => e.id).toList()..add(sp.id);
                                    context.read<ProductCubit>().updateProduct(product.id, {'supported_sub_products': updatedLinked});
                                    Navigator.pop(ctx);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryGreen,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                  ),
                                  child: Text('Add', style: TextStyle(color: AppColors.pureWhite, fontWeight: FontWeight.bold, fontSize: 12.sp)),
                                ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushNamed(context, '/create-product', arguments: {
                    'branchId': product.branch_id,
                    'isSubProduct': true,
                    'parentProductId': product.id,
                    'parentProductLinkedIds': product.supported_sub_products.map((e) => e.id).toList(),
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textPrimary,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text(
                  'Create New Sub-Product',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pureWhite,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}