import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/color.dart';
import '../../../core/widgets/action_bottom_sheet.dart';
import '../../../services/json_cache.dart';
import '../../business/models/business_context.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String? _selectedCategoryId;
  String? _selectedSubCategoryId;
  String _branchId = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await JsonCache().getBusinessContext();
    if (data != null && mounted) {
      final contextModel = BusinessContextModel.fromJson(data);
      _branchId = contextModel.branch.id;
      context.read<ProductCubit>().loadCategories(_branchId);
      context.read<ProductCubit>().loadProducts(_branchId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCategoryBar(state),
                        if (_selectedCategoryId != null &&
                            state.subCategories.isNotEmpty) ...[
                          Container(height: 1.h, color: AppColors.borderGrey),
                          _buildSubCategoryBar(state),
                        ],
                        Container(height: 8.h, color: AppColors.softGrey),
                        _buildProductsGrid(state),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: const BoxDecoration(
                    color: AppColors.pureWhite,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowColor,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.chevron_left,
                    color: AppColors.textPrimary,
                    size: 24.w,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Products',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              ActionBottomSheet.show(
                context,
                title: 'Product Options',
                subtitle: 'Manage categories and products',
                actions: [
                  BottomSheetAction(
                    icon: Icons.category,
                    label: 'Manage Categories',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        '/categories',
                        arguments: _branchId,
                      );
                    },
                  ),
                  BottomSheetAction(
                    icon: Icons.add_box,
                    label: 'Add Product',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        '/create-product',
                        arguments: _branchId,
                      );
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
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.more_vert,
                color: AppColors.textPrimary,
                size: 20.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBar(ProductState state) {
    if (state.categories.isEmpty) {
      return SizedBox(height: 16.h);
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: state.categories.map((cat) {
            final isSelected = _selectedCategoryId == cat.id;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategoryId = cat.id;
                  _selectedSubCategoryId = null;
                });
                context.read<ProductCubit>().loadSubCategories(cat.id);
              },
              child: Container(
                margin: EdgeInsets.only(right: 16.w),
                child: Column(
                  children: [
                    Container(
                      width: 56.w,
                      height: 56.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.softGrey,
                        image: cat.images.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(cat.images.first),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: cat.images.isEmpty
                          ? Icon(
                              Icons.category,
                              color: AppColors.textTertiary,
                              size: 24.w,
                            )
                          : null,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      cat.name,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: isSelected
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    if (isSelected)
                      Container(
                        height: 3.h,
                        width: 36.w,
                        color: AppColors.primaryGreen,
                      )
                    else
                      SizedBox(height: 3.h),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSubCategoryBar(ProductState state) {
    if (state.subCategories.isEmpty) {
      return SizedBox(height: 16.h);
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: state.subCategories.map((sub) {
            final isSelected = _selectedSubCategoryId == sub.id;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedSubCategoryId = sub.id;
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: 16.w),
                child: Column(
                  children: [
                    Container(
                      width: 56.w,
                      height: 56.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.softGrey,
                        image: sub.images.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(sub.images.first),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: sub.images.isEmpty
                          ? Icon(
                              Icons.category,
                              color: AppColors.textTertiary,
                              size: 24.w,
                            )
                          : null,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      sub.name,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: isSelected
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    if (isSelected)
                      Container(
                        height: 3.h,
                        width: 36.w,
                        color: AppColors.primaryGreen,
                      )
                    else
                      SizedBox(height: 3.h),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildProductsGrid(ProductState state) {
    var filteredProducts = state.products;

    if (_selectedCategoryId != null) {
      filteredProducts = filteredProducts
          .where((p) => p.category_id == _selectedCategoryId)
          .toList();
    }

    if (_selectedSubCategoryId != null) {
      filteredProducts = filteredProducts
          .where((p) => p.sub_category_id == _selectedSubCategoryId)
          .toList();
    }

    if (filteredProducts.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(32.w),
        child: Center(
          child: Text(
            'No products found.',
            style: TextStyle(fontSize: 14.sp, color: AppColors.textTertiary),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 12.h,
        bottom: 16.h,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.62,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 16.h,
        ),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/product-detail',
                arguments: product.id,
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.softGrey,
                          borderRadius: BorderRadius.circular(12.r),
                          image: product.images.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(product.images.first),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: product.images.isEmpty
                            ? Center(
                                child: Icon(
                                  Icons.fastfood,
                                  color: AppColors.textTertiary,
                                  size: 24.w,
                                ),
                              )
                            : null,
                      ),
                      if (product.is_veg)
                        Positioned(
                          top: 6.h,
                          left: 6.w,
                          child: Container(
                            width: 14.w,
                            height: 14.w,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.green,
                                width: 1.5,
                              ),
                              color: AppColors.pureWhite,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                            alignment: Alignment.center,
                            child: Container(
                              width: 6.w,
                              height: 6.w,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      if (!product.is_available)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Out of\nStock',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.pureWhite,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '₹${product.price}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryGreen,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Stock: ${product.stock}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
