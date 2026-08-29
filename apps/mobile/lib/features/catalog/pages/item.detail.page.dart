import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/components/ui/loader.dart';
import 'package:mobile/components/ui/app_refresher.dart';
import 'package:mobile/components/ui/dialog.dart';
import 'package:mobile/features/catalog/constants/catalog.constant.dart';
import 'package:mobile/features/inventory/controllers/inventory.cubit.dart';
import 'package:mobile/features/inventory/controllers/inventory.state.dart';
import 'package:mobile/features/inventory/models/item.model.dart';
import 'package:mobile/features/inventory/models/item_category.model.dart';
import 'package:mobile/features/inventory/models/item_variant.model.dart';
import 'package:mobile/features/inventory/models/unit_of_measure.model.dart';

class ItemDetailPage extends StatefulWidget {
  const ItemDetailPage({super.key});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  ItemModel? _item;
  ItemCategoryModel? _category;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_item == null) {
      _item = ModalRoute.of(context)!.settings.arguments as ItemModel;
      context.read<InventoryCubit>().listVariants(_item!.id);

      final state = context.read<InventoryCubit>().state;
      _category = state.itemCategories
          .where((c) => c.id == _item!.category_id)
          .firstOrNull;

      if (state.uoms.isEmpty) {
        context.read<InventoryCubit>().listUoms();
      }
    }
  }

  Future<void> _confirmDeleteItem(BuildContext context) async {
    final cubit = context.read<InventoryCubit>();
    final confirmed = await AppDialog.showConfirmation(
      context: context,
      title: CatalogConstant.DELETE_ITEM_TITLE,
      message: CatalogConstant.DELETE_ITEM_MESSAGE,
      confirmText: CatalogConstant.DELETE_ITEM_CONFIRM,
      isDestructive: true,
    );
    if (confirmed != true || !mounted) return;
    cubit.deleteItem(_item!.id);
  }

  @override
  Widget build(BuildContext context) {
    if (_item == null) return const Scaffold();

    return BlocListener<InventoryCubit, InventoryState>(
      listenWhen: (previous, current) =>
          previous.deleteItemInfo.status != current.deleteItemInfo.status,
      listener: (context, state) {
        if (state.deleteItemInfo.status == OperationStatus.success) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.pureWhite,
        appBar: AppBar(
          backgroundColor: AppColors.pureWhite,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
          title: Text(
            CatalogConstant.ITEM_DETAIL_TITLE,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          centerTitle: true,
          actions: [
            BlocBuilder<InventoryCubit, InventoryState>(
              buildWhen: (previous, current) =>
                  previous.deleteItemInfo.status !=
                  current.deleteItemInfo.status,
              builder: (context, state) {
                final isDeleting =
                    state.deleteItemInfo.status == OperationStatus.loading;
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: isDeleting
                      ? Padding(
                          padding: EdgeInsets.all(12.w),
                          child: SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.error,
                            ),
                          ),
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
                            size: 22.w,
                          ),
                          onPressed: () => _confirmDeleteItem(context),
                        ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<InventoryCubit, InventoryState>(
          builder: (context, state) {
            final variants = state.variants;

            return AppRefresher(
              onRefresh: () async {
                context.read<InventoryCubit>().listVariants(_item!.id);
                context.read<InventoryCubit>().listUoms();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_item!.images.isNotEmpty)
                          Container(
                            width: 100.w,
                            height: 100.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              image: DecorationImage(
                                image: NetworkImage(_item!.images.first),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.shadowColor,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            width: 100.w,
                            height: 100.w,
                            decoration: BoxDecoration(
                              color: AppColors.primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Center(
                              child: Text(
                                _item!.name.substring(0, 1).toUpperCase(),
                                style: TextStyle(
                                  fontSize: 40.sp,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                            ),
                          ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _item!.name,
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.category_outlined,
                                    size: 14.w,
                                    color: AppColors.textSecondary,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    _category?.name ?? 'Unknown',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              Wrap(
                                spacing: 8.w,
                                runSpacing: 6.h,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Text(
                                      _item!.item_type,
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primaryGreen,
                                      ),
                                    ),
                                  ),
                                  if (_item!.shelf_life_days != null &&
                                      _item!.shelf_life_days! > 0)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEF3C7),
                                        borderRadius: BorderRadius.circular(
                                          6.r,
                                        ),
                                      ),
                                      child: Text(
                                        'Shelf Life: ${_item!.shelf_life_days} Days',
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xFF92400E),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (_item!.description != null &&
                        _item!.description!.isNotEmpty) ...[
                      SizedBox(height: 24.h),
                      Container(
                        padding: EdgeInsets.all(12.w),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.softGrey,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textTertiary,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              _item!.description!,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textPrimary,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    SizedBox(height: 32.h),
                    Text(
                      CatalogConstant.VARIANTS_SECTION,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textTertiary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    if (state.loadVariantsInfo.status ==
                        OperationStatus.loading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(child: AppLoader()),
                      )
                    else if (variants.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Text(
                          'No variants added yet.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13.sp,
                          ),
                        ),
                      )
                    else
                      ...variants.map(
                        (v) => _buildVariantCard(context, v, state),
                      ),
                    SizedBox(height: 24.h),
                    AppButton(
                      text: CatalogConstant.ADD_VARIANT,
                      backgroundColor: AppColors.softGrey,
                      textColor: AppColors.textPrimary,
                      icon: Icon(
                        Icons.add,
                        color: AppColors.textPrimary,
                        size: 20.w,
                      ),
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/create-variant',
                        arguments: _item,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVariantCard(
    BuildContext context,
    ItemVariantModel variant,
    InventoryState state,
  ) {
    final uom = state.uoms.where((u) => u.id == variant.uom_id).firstOrNull;
    final uomDesc = uom != null ? uom.code : 'Unit';

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: AppColors.pureWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          builder: (_) => _EditVariantSheet(
            variant: variant,
            item: _item!,
            uoms: state.uoms,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          border: Border.all(color: AppColors.borderGrey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top Section
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      if (variant.images.isNotEmpty)
                        Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.r),
                            image: DecorationImage(
                              image: NetworkImage(variant.images.first),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.shadowColor,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            color: AppColors.softGrey,
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(color: AppColors.borderGrey),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.inventory_2_outlined,
                              color: AppColors.textTertiary,
                              size: 32.w,
                            ),
                          ),
                        ),
                      if (variant.images.length > 1)
                        Positioned(
                          bottom: 4.h,
                          right: 4.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.deepOnyx.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.photo_library,
                                  color: AppColors.pureWhite,
                                  size: 10.w,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '${variant.images.length}',
                                  style: TextStyle(
                                    color: AppColors.pureWhite,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                variant.name?.isNotEmpty == true
                                    ? variant.name!
                                    : 'Variant ${variant.sku}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: variant.status == 'ACTIVE'
                                    ? AppColors.primaryGreen.withOpacity(0.1)
                                    : AppColors.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                variant.status,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w800,
                                  color: variant.status == 'ACTIVE'
                                      ? AppColors.primaryGreen
                                      : AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 6.h,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.tag,
                                    size: 12.w,
                                    color: AppColors.textSecondary,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    variant.sku,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (variant.barcode.isNotEmpty)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(6.r),
                                  border: Border.all(
                                    color: const Color(0xFFE5E7EB),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.qr_code_2,
                                      size: 12.w,
                                      color: AppColors.textSecondary,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      variant.barcode,
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Section (Price & Stock)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16.r),
                ),
                border: Border(
                  top: BorderSide(color: AppColors.borderGrey.withOpacity(0.5)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.payments_outlined,
                              size: 14.w,
                              color: AppColors.primaryGreen,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Base Cost',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '₹${variant.base_cost.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                            Text(
                              ' / $uomDesc',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1.w,
                    height: 32.h,
                    color: AppColors.borderGrey,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.inventory_outlined,
                              size: 14.w,
                              color: const Color(0xFFD97706),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Min Stock',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${variant.min_stock_lvl} $uomDesc',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditVariantSheet extends StatefulWidget {
  final ItemVariantModel variant;
  final ItemModel item;
  final List<UnitOfMeasureModel> uoms;

  const _EditVariantSheet({
    required this.variant,
    required this.item,
    required this.uoms,
  });

  @override
  State<_EditVariantSheet> createState() => _EditVariantSheetState();
}

class _EditVariantSheetState extends State<_EditVariantSheet> {
  late final TextEditingController _baseCostCtrl;
  late final TextEditingController _minStockCtrl;
  late final TextEditingController _nameCtrl;
  late UnitOfMeasureModel? _selectedUom;
  List<String> _existingImages = [];
  final List<String> _localImages = [];
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _baseCostCtrl = TextEditingController(
      text: widget.variant.base_cost.toString(),
    );
    _minStockCtrl = TextEditingController(
      text: widget.variant.min_stock_lvl.toString(),
    );
    _nameCtrl = TextEditingController(text: widget.variant.name ?? '');
    _selectedUom = widget.uoms
        .where((u) => u.id == widget.variant.uom_id)
        .firstOrNull;
    _existingImages = List.from(widget.variant.images);
  }

  @override
  void dispose() {
    _baseCostCtrl.dispose();
    _minStockCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (mounted) {
        setState(() {
          _localImages.add(pickedFile.path);
        });
      }
    }
  }

  void _onUpdate() async {
    if (_selectedUom == null) return;
    if (mounted) setState(() => _isUploading = true);

    List<String> uploadedUrls = [];
    for (String path in _localImages) {
      final url = await context.read<InventoryCubit>().uploadImage(path);
      if (url != null) {
        uploadedUrls.add(url);
      }
    }

    if (mounted) setState(() => _isUploading = false);

    final finalImages = [..._existingImages, ...uploadedUrls];
    final baseCost = double.tryParse(_baseCostCtrl.text.trim()) ?? 0.0;
    final minStock = double.tryParse(_minStockCtrl.text.trim()) ?? 0.0;

    if (mounted) {
      context
          .read<InventoryCubit>()
          .updateVariant(widget.variant.id, widget.item.id, {
            'uom_id': _selectedUom!.id,
            'name': _nameCtrl.text.isNotEmpty ? _nameCtrl.text.trim() : null,
            'images': finalImages,
            'base_cost': baseCost,
            'min_stock_lvl': minStock,
            'status': widget.variant.status,
          });
    }
  }

  void _showUomSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.pureWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Unit (UOM)',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16.h),
                if (widget.uoms.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: Center(
                      child: Text(
                        'No units found.',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: widget.uoms.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final uom = widget.uoms[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedUom = uom);
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 16.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.pureWhite,
                              border: Border.all(
                                color: AppColors.borderGrey,
                                width: 1.w,
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  uom.description,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  uom.code,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDeleteVariant(BuildContext context) async {
    final cubit = context.read<InventoryCubit>();
    final confirmed = await AppDialog.showConfirmation(
      context: context,
      title: CatalogConstant.DELETE_VARIANT_TITLE,
      message: CatalogConstant.DELETE_VARIANT_MESSAGE,
      confirmText: CatalogConstant.DELETE_VARIANT_CONFIRM,
      isDestructive: true,
    );
    if (confirmed != true || !mounted) return;
    cubit.deleteVariant(widget.variant.id, widget.item.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InventoryCubit, InventoryState>(
      listenWhen: (previous, current) =>
          previous.saveVariantsInfo.status != current.saveVariantsInfo.status ||
          previous.deleteVariantInfo.status != current.deleteVariantInfo.status,
      listener: (context, state) {
        if (state.saveVariantsInfo.status == OperationStatus.success ||
            state.deleteVariantInfo.status == OperationStatus.success) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final isLoading =
            state.saveVariantsInfo.status == OperationStatus.loading;
        final isDeleting =
            state.deleteVariantInfo.status == OperationStatus.loading;

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 24.w,
              right: 24.w,
              top: 24.h,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Edit Variant',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: AppColors.textSecondary),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.softGrey,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SKU: ${widget.variant.sku}',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (widget.variant.barcode.isNotEmpty) ...[
                          SizedBox(height: 4.h),
                          Text(
                            'Barcode: ${widget.variant.barcode}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  AppInput(
                    controller: _nameCtrl,
                    hintText: 'Variant Name (Optional)',
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Images',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    children: [
                      ..._existingImages.map(
                        (url) => Stack(
                          children: [
                            Container(
                              width: 80.r,
                              height: 80.r,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                image: DecorationImage(
                                  image: NetworkImage(url),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: -4,
                              right: -4,
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _existingImages.remove(url)),
                                child: Container(
                                  padding: EdgeInsets.all(4.r),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 12.r,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ..._localImages.map(
                        (path) => Stack(
                          children: [
                            Container(
                              width: 80.r,
                              height: 80.r,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                image: DecorationImage(
                                  image: FileImage(File(path)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: -4,
                              right: -4,
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _localImages.remove(path)),
                                child: Container(
                                  padding: EdgeInsets.all(4.r),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 12.r,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: _isUploading ? null : _pickImage,
                        child: Container(
                          width: 80.r,
                          height: 80.r,
                          decoration: BoxDecoration(
                            color: AppColors.softGrey,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: AppColors.borderGrey),
                          ),
                          child: _isUploading
                              ? Center(child: AppLoader())
                              : Icon(
                                  Icons.add_photo_alternate,
                                  color: AppColors.textTertiary,
                                ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: () => _showUomSelector(context),
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderGrey),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedUom?.description ?? 'Select Unit',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: _selectedUom != null
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                              fontWeight: _selectedUom != null
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: AppInput(
                          controller: _baseCostCtrl,
                          hintText: CatalogConstant.BASE_COST,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: AppInput(
                          controller: _minStockCtrl,
                          hintText: CatalogConstant.MIN_STOCK,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  AppButton(
                    text: 'Update Variant',
                    onPressed: _onUpdate,
                    isLoading: isLoading || _isUploading,
                  ),
                  SizedBox(height: 12.h),
                  AppButton(
                    text: CatalogConstant.DELETE_VARIANT_CONFIRM,
                    onPressed: () => _confirmDeleteVariant(context),
                    isLoading: isDeleting,
                    backgroundColor: AppColors.error.withOpacity(0.08),
                    textColor: AppColors.error,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
