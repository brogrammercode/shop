import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/features/business/cubit/business_cubit.dart';
import 'package:mobile/features/product/constants/product.dart';
import 'package:mobile/features/product/cubit/product_cubit.dart';
import 'package:mobile/features/product/cubit/product_state.dart';
import 'package:mobile/features/product/models/product_model.dart';
import 'package:mobile/utils/error.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProducts());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductCubit, ProductState>(
      listenWhen: (previous, current) =>
          previous.deleteInfo.status != current.deleteInfo.status,
      listener: (context, state) {
        if (state.deleteInfo.status == OperationStatus.error) {
          _showMessage(state.deleteInfo.error?.message ?? '');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.pureWhite,
        appBar: AppBar(
          backgroundColor: AppColors.pureWhite,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.deepOnyx),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            ProductConstants.productsTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: AppColors.primaryIndigo),
              onPressed: _openCreateProduct,
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              children: [
                AppInput(
                  hintText: ProductConstants.searchHint,
                  controller: _searchController,
                  onChanged: (_) => _loadProducts(),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.primaryIndigo,
                  ),
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: BlocBuilder<ProductCubit, ProductState>(
                    builder: (context, state) {
                      if (state.listInfo.status == OperationStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.products.isEmpty) {
                        return Center(
                          child: Text(
                            ProductConstants.emptyProducts,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: state.products.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          return _ProductTile(
                            product: state.products[index],
                            onTap: () =>
                                _openEditProduct(state.products[index]),
                            onDelete: () => context.read<ProductCubit>().delete(
                              state.products[index].id,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _loadProducts() {
    final branchId = context.read<BusinessCubit>().state.context?.branch.id;
    if (branchId == null || branchId.isEmpty) {
      return;
    }

    context.read<ProductCubit>().getList(
      branchId,
      search: _searchController.text,
    );
  }

  Future<void> _openCreateProduct() async {
    final result = await Navigator.pushNamed(context, AppRoutes.productForm);
    if (result == true && mounted) {
      _loadProducts();
    }
  }

  Future<void> _openEditProduct(ProductModel product) async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.productForm,
      arguments: product,
    );
    if (result == true && mounted) {
      _loadProducts();
    }
  }

  void _showMessage(String message) {
    if (message.isEmpty) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ProductTile extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ProductTile({
    required this.product,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final stockColor = product.stock <= product.low_stock_alert
        ? AppColors.googleRed
        : AppColors.statusGreen;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.softGrey,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: AppColors.primaryIndigo,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                color: AppColors.pureWhite,
                size: 24.w,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${ProductConstants.currencySymbol} ${product.price.toStringAsFixed(2)} · ${product.category}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  product.stock.toString(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: stockColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: AppColors.deepOnyx,
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
