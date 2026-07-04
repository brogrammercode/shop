import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/components/ui/app_refresher.dart';
import 'package:mobile/components/ui/loader.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile/features/catalog/constants/catalog.constant.dart';
import 'package:mobile/features/inventory/controllers/inventory.cubit.dart';
import 'package:mobile/features/inventory/controllers/inventory.state.dart';
import 'package:mobile/features/inventory/models/item.model.dart';
import 'package:mobile/features/inventory/models/item_category.model.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryCubit>().listItems();
      context.read<InventoryCubit>().listItemCategories();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryCubit, InventoryState>(
      builder: (context, state) {
        final categories = state.itemCategories;

        // Filter items
        final searchTerm = _searchCtrl.text.toLowerCase();
        final filteredItems = state.items.where((item) {
          final matchesSearch = item.name.toLowerCase().contains(searchTerm);
          final matchesCategory =
              _selectedCategoryId == null ||
              item.category_id == _selectedCategoryId;
          return matchesSearch && matchesCategory;
        }).toList();

        return Scaffold(
          backgroundColor: AppColors.pureWhite,
          body: SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: AppInput(
                    controller: _searchCtrl,
                    hintText: CatalogConstant.SEARCH_ITEM,
                    prefixIcon: Icon(Icons.search, color: AppColors.textTertiary),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  children: [
                    _buildFilterChip('All', _selectedCategoryId == null, null),
                    ...categories.map(
                      (cat) => _buildFilterChip(
                        cat.name,
                        _selectedCategoryId == cat.id,
                        cat.id,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: state.loadItemsInfo.status == OperationStatus.loading && state.items.isEmpty
                  ? const Center(child: AppLoader())
                  : filteredItems.isEmpty
                    ? AppRefresher(
                        onRefresh: () async {
                          context.read<InventoryCubit>().listItems();
                          context.read<InventoryCubit>().listItemCategories();
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            alignment: Alignment.center,
                            child: Text(
                              'No items found',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      )
                    : AppRefresher(
                        onRefresh: () async {
                          context.read<InventoryCubit>().listItems();
                          context.read<InventoryCubit>().listItemCategories();
                        },
                        child: ListView.separated(
                          padding: EdgeInsets.all(24.w),
                          itemCount: filteredItems.length,
                          separatorBuilder: (c, i) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) => _buildItemCard(
                            context,
                            filteredItems[index],
                            categories,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 62.h),
            child: FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/create-item'),
              backgroundColor: AppColors.primaryGreen,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: AppColors.pureWhite),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
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
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.chevron_left, color: AppColors.textPrimary, size: 24.w),
            ),
          ),
          SizedBox(width: 16.w),
          Text(
            'Items',
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

  Widget _buildFilterChip(String label, bool isSelected, String? categoryId) {
    return GestureDetector(
      onTap: () => setState(() => _selectedCategoryId = categoryId),
      child: Container(
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : AppColors.pureWhite,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.borderGrey,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? AppColors.pureWhite : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, ItemModel item, List<ItemCategoryModel> categories) {
    final catName = categories.where((c) => c.id == item.category_id).firstOrNull?.name ?? 'Unknown';

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/item-detail', arguments: item),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.borderGrey),
          boxShadow: const [BoxShadow(color: AppColors.shadowColor, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.images.isNotEmpty)
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  image: DecorationImage(image: NetworkImage(item.images.first), fit: BoxFit.cover),
                ),
              )
            else
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(color: AppColors.primaryGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(12.r)),
                alignment: Alignment.center,
                child: Text(item.name.isNotEmpty ? item.name.substring(0, 1).toUpperCase() : '?', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28.sp, color: AppColors.primaryGreen)),
              ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.category_outlined, size: 12.w, color: AppColors.textSecondary),
                      SizedBox(width: 4.w),
                      Text(catName, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 4.h,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(6.r)),
                        child: Text(item.item_type, style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w800, color: AppColors.primaryGreen)),
                      ),
                      if (item.shelf_life_days != null && item.shelf_life_days! > 0)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(6.r)),
                          child: Text('Shelf Life: ${item.shelf_life_days} Days', style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w800, color: const Color(0xFF92400E))),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
