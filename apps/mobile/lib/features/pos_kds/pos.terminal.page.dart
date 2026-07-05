import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/pos_kds/constants/pos.constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/pos_kds/controllers/pos_kds.cubit.dart';
import 'package:mobile/features/pos_kds/controllers/pos_kds.state.dart';
import 'package:mobile/features/pos_kds/pos.cart.page.dart';
import 'package:mobile/features/catalog/controllers/catalog.cubit.dart';
import 'package:mobile/features/catalog/controllers/catalog.state.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile/components/ui/loader.dart';

class PosTerminalPage extends StatefulWidget {
  const PosTerminalPage({super.key});

  @override
  State<PosTerminalPage> createState() => _PosTerminalPageState();
}

class _PosTerminalPageState extends State<PosTerminalPage> {
  String _selectedCategoryId = 'all';

  @override
  void initState() {
    super.initState();
    context.read<CatalogCubit>().listMenuCategories();
    context.read<CatalogCubit>().listMenuItems();
  }

  Widget _buildCategoryBar(CatalogState state) {
    final categories = state.menuCategories
        .where((c) => !c.is_deleted)
        .toList();
    if (categories.isEmpty) return SizedBox(height: 16.h);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            _buildCategoryItem(
              id: 'all',
              name: 'All Items',
              images: [],
              isSelected: _selectedCategoryId == 'all',
            ),
            ...categories.map((cat) {
              return _buildCategoryItem(
                id: cat.id,
                name: cat.name,
                images: cat.images,
                isSelected: _selectedCategoryId == cat.id,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem({
    required String id,
    required String name,
    required List<String> images,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryId = id;
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
                image: images.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(images.first),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: images.isEmpty
                  ? Icon(
                      Icons.category,
                      color: AppColors.textTertiary,
                      size: 24.w,
                    )
                  : null,
            ),
            SizedBox(height: 8.h),
            Text(
              name,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 4.h),
            if (isSelected)
              Container(height: 3.h, width: 36.w, color: AppColors.primaryGreen)
            else
              SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsGrid(CatalogState state) {
    if (state.loadMenuItemsInfo.status == OperationStatus.loading &&
        state.menuItems.isEmpty) {
      return const Center(child: AppLoader(size: 24, strokeWidth: 2));
    }

    var items = state.menuItems.where((i) => !i.is_deleted).toList();
    if (_selectedCategoryId != 'all') {
      items = items.where((i) => i.category_id == _selectedCategoryId).toList();
    }

    if (items.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(32.w),
        child: Center(
          child: Text(
            'No items found.',
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
        bottom: 100.h,
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
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {
              context.read<PosKdsCubit>().addToCart(item.id);
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
                          image: item.images.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(item.images.first),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: item.images.isEmpty
                            ? Center(
                                child: Icon(
                                  Icons.fastfood,
                                  color: AppColors.textTertiary,
                                  size: 24.w,
                                ),
                              )
                            : null,
                      ),
                      if (item.status != 'ACTIVE')
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Not\\nAvailable',
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
                  item.display_name,
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
                  'Rs${item.selling_price.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PosKdsCubit, PosKdsState>(
          listenWhen: (previous, current) =>
              previous.saveOrdersInfo.status != current.saveOrdersInfo.status,
          listener: (context, state) {
            if (state.saveOrdersInfo.status == OperationStatus.success) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } // Close bottom sheet
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.pureWhite,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildAppBar(context),
                  Expanded(
                    child: BlocBuilder<CatalogCubit, CatalogState>(
                      builder: (context, catalogState) {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCategoryBar(catalogState),
                              Container(height: 8.h, color: AppColors.softGrey),
                              _buildProductsGrid(catalogState),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              BlocBuilder<PosKdsCubit, PosKdsState>(
                builder: (context, posState) {
                  final cartItemsCount = posState.cart.values.fold(
                    0,
                    (sum, item) => sum + item,
                  );
                  if (cartItemsCount == 0) return const SizedBox.shrink();

                  double cartTotal = 0.0;
                  String? lastAddedImageUrl;
                  final catalogState = context.read<CatalogCubit>().state;
                  posState.cart.forEach((itemId, qty) {
                    try {
                      final item = catalogState.menuItems.firstWhere(
                        (i) => i.id == itemId,
                      );
                      cartTotal += (item.selling_price * qty);
                      if (item.images.isNotEmpty) {
                        lastAddedImageUrl = item.images.first;
                      }
                    } catch (_) {}
                  });

                  return Positioned(
                    bottom: 66.h,
                    left: 16.w,
                    right: 16.w,
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PosCartPage()),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                if (lastAddedImageUrl != null)
                                  Container(
                                    width: 32.w,
                                    height: 32.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: NetworkImage(lastAddedImageUrl!),
                                        fit: BoxFit.cover,
                                      ),
                                      border: Border.all(
                                        color: AppColors.pureWhite,
                                        width: 1.w,
                                      ),
                                    ),
                                  ),
                                if (lastAddedImageUrl != null)
                                  SizedBox(width: 8.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '$cartItemsCount ITEM${cartItemsCount > 1 ? 'S' : ''}',
                                      style: TextStyle(
                                        color: AppColors.pureWhite,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Text(
                                      'Rs${cartTotal.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        color: AppColors.pureWhite,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'View Order',
                                  style: TextStyle(
                                    color: AppColors.pureWhite,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Icon(
                                  Icons.chevron_right,
                                  color: AppColors.pureWhite,
                                  size: 16.w,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
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
                PosConstant.POS_TITLE,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
