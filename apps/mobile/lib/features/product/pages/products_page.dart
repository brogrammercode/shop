import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/color.dart';
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
                        _buildSubCategoryBar(state),
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
                      BoxShadow(color: AppColors.shadowColor, blurRadius: 4, offset: Offset(0, 2)),
                    ],
                  ),
                  child: Icon(Icons.chevron_left, color: AppColors.textPrimary, size: 24.w),
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
          PopupMenuButton<String>(
            icon: Container(
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
            offset: Offset(0, 40.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            onSelected: (value) {
              if (value == 'categories') {
                Navigator.pushNamed(context, '/categories', arguments: _branchId);
              } else if (value == 'product') {
                Navigator.pushNamed(context, '/create-product', arguments: _branchId);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'categories',
                child: Text('Manage Categories', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700)),
              ),
              PopupMenuItem(
                value: 'product',
                child: Text('Add Product', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
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
                            ? DecorationImage(image: NetworkImage(sub.images.first), fit: BoxFit.cover)
                            : null,
                      ),
                      child: sub.images.isEmpty
                          ? Icon(Icons.category, color: AppColors.textTertiary, size: 24.w)
                          : null,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      sub.name,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
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
    final filteredProducts = _selectedSubCategoryId == null
        ? state.products
        : state.products.where((p) => p.sub_category_id == _selectedSubCategoryId).toList();

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
      padding: EdgeInsets.all(16.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
        ),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return Container(
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: const [
                BoxShadow(color: AppColors.shadowColor, blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.softGrey,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                      image: product.images.isNotEmpty
                          ? DecorationImage(image: NetworkImage(product.images.first), fit: BoxFit.cover)
                          : null,
                    ),
                    child: product.images.isEmpty
                        ? Center(child: Icon(Icons.fastfood, color: AppColors.textTertiary, size: 32.w))
                        : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '₹${product.price}',
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.primaryGreen),
                      ),
                    ],
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
