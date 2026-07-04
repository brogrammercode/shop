const fs = require('fs');

let content = fs.readFileSync('apps/mobile/lib/features/catalog/pages/item.detail.page.dart', 'utf8');

// Add imports
content = content.replace(
  "import 'package:mobile/utils/error.dart';",
  "import 'package:mobile/utils/error.dart';\nimport 'package:mobile/components/ui/app_refresher.dart';\nimport 'package:mobile/features/inventory/models/item_variant.model.dart';\nimport 'package:mobile/features/inventory/models/unit_of_measure.model.dart';"
);

// Add the EditVariantSheet class at the end
content += `

class _EditVariantSheet extends StatefulWidget {
  final ItemVariantModel variant;
  final ItemModel item;
  final List<UnitOfMeasureModel> uoms;

  const _EditVariantSheet({required this.variant, required this.item, required this.uoms});

  @override
  State<_EditVariantSheet> createState() => _EditVariantSheetState();
}

class _EditVariantSheetState extends State<_EditVariantSheet> {
  late final TextEditingController _baseCostCtrl;
  late final TextEditingController _minStockCtrl;
  late UnitOfMeasureModel? _selectedUom;

  @override
  void initState() {
    super.initState();
    _baseCostCtrl = TextEditingController(text: widget.variant.base_cost.toString());
    _minStockCtrl = TextEditingController(text: widget.variant.min_stock_lvl.toString());
    _selectedUom = widget.uoms.where((u) => u.id == widget.variant.uom_id).firstOrNull;
  }

  @override
  void dispose() {
    _baseCostCtrl.dispose();
    _minStockCtrl.dispose();
    super.dispose();
  }

  void _onUpdate() {
    if (_selectedUom == null) return;
    final baseCost = double.tryParse(_baseCostCtrl.text.trim()) ?? 0.0;
    final minStock = double.tryParse(_minStockCtrl.text.trim()) ?? 0.0;

    context.read<InventoryCubit>().updateVariant(
      widget.variant.id,
      widget.item.id,
      {
        'uom_id': _selectedUom!.id,
        'base_cost': baseCost,
        'min_stock_lvl': minStock,
        'status': widget.variant.status,
      },
    );
  }

  void _showUomSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.pureWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Unit (UOM)', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                SizedBox(height: 16.h),
                if (widget.uoms.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: Center(child: Text('No units found.', style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary))),
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
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                            decoration: BoxDecoration(
                              color: AppColors.pureWhite,
                              border: Border.all(color: AppColors.borderGrey, width: 1.w),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(uom.description, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                                Text(uom.code, style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary)),
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InventoryCubit, InventoryState>(
      listenWhen: (previous, current) => previous.saveVariantsInfo.status != current.saveVariantsInfo.status,
      listener: (context, state) {
        if (state.saveVariantsInfo.status == OperationStatus.success) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final isLoading = state.saveVariantsInfo.status == OperationStatus.loading;
        
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 24.w,
              right: 24.w,
              top: 24.h,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Edit Variant', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    IconButton(icon: Icon(Icons.close, color: AppColors.textSecondary), onPressed: () => Navigator.pop(context)),
                  ],
                ),
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(color: AppColors.softGrey, borderRadius: BorderRadius.circular(8.r)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SKU: \${widget.variant.sku}', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      if (widget.variant.barcode != null && widget.variant.barcode!.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text('Barcode: \${widget.variant.barcode}', style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                GestureDetector(
                  onTap: () => _showUomSelector(context),
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(border: Border.all(color: AppColors.borderGrey), borderRadius: BorderRadius.circular(10.r)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_selectedUom?.description ?? 'Select Unit', style: TextStyle(fontSize: 15.sp, color: _selectedUom != null ? AppColors.textPrimary : AppColors.textSecondary, fontWeight: _selectedUom != null ? FontWeight.w600 : FontWeight.w400)),
                        Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
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
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: AppInput(
                        controller: _minStockCtrl,
                        hintText: CatalogConstant.MIN_STOCK,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                AppButton(
                  text: 'Update Variant',
                  onPressed: _onUpdate,
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
`;

// Replace the SingleChildScrollView with AppRefresher and update the variants section
const replaceRegex = /body: SingleChildScrollView\([\s\S]*?\/\/ Variants are not yet fully wired to backend in UI, keep static or empty[\s\S]*?AppButton\([\s\S]*?\/\/ TODO pass itemId[\s\S]*?\),[\s\n]*\],[\s\n]*\),[\s\n]*\),[\s\n]*\);/;

const replacement = `body: AppRefresher(
            onRefresh: () async {
              context.read<InventoryCubit>().listItems();
              context.read<InventoryCubit>().listVariants(currentItem.id);
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (currentItem.images.isNotEmpty)
                        Container(
                          width: 64.w,
                          height: 64.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            image: DecorationImage(image: NetworkImage(currentItem.images.first), fit: BoxFit.cover),
                          ),
                        )
                      else
                        Container(
                          width: 64.w,
                          height: 64.w,
                          decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12.r)),
                          child: Center(child: Icon(Icons.fastfood, color: AppColors.textSecondary, size: 32.w)),
                        ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(currentItem.name, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                            SizedBox(height: 4.h),
                            Text('Category: $catName', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                            SizedBox(height: 4.h),
                            Text('Type: \${currentItem.item_type.replaceAll('_', ' ')} • Shelf Life: \${currentItem.shelf_life_days ?? '-'} Days', style: TextStyle(fontSize: 12.sp, color: AppColors.textTertiary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (currentItem.description != null && currentItem.description!.isNotEmpty) ...[
                    SizedBox(height: 24.h),
                    Text('Description', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    SizedBox(height: 8.h),
                    Text(
                      currentItem.description!,
                      style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary, height: 1.5),
                    ),
                  ],
                  if (currentItem.images.length > 1) ...[
                    SizedBox(height: 24.h),
                    Text('More Images', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    SizedBox(height: 12.h),
                    Wrap(
                      spacing: 12.w,
                      runSpacing: 12.h,
                      children: currentItem.images.skip(1).map((url) => Container(
                        width: 80.r,
                        height: 80.r,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
                        ),
                      )).toList(),
                    ),
                  ],
                  SizedBox(height: 32.h),
                  Text(CatalogConstant.VARIANTS_SECTION, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: AppColors.textTertiary, letterSpacing: 0.8)),
                  SizedBox(height: 12.h),
                  
                  if (state.variants.isNotEmpty)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.variants.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final variant = state.variants[index];
                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: AppColors.pureWhite,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
                              builder: (_) => _EditVariantSheet(variant: variant, item: currentItem, uoms: state.uoms),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.borderGrey),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(variant.sku, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                                    SizedBox(height: 4.h),
                                    Text('Cost: ₹\${variant.base_cost}', style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary)),
                                  ],
                                ),
                                Icon(Icons.chevron_right, color: AppColors.textSecondary),
                              ],
                            ),
                          ),
                        );
                      }
                    )
                  else
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: Text(
                          state.loadVariantsInfo.status == OperationStatus.loading ? 'Loading variants...' : 'No variants found', 
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp)
                        ),
                      ),
                    ),
                  
                  SizedBox(height: 24.h),
                  AppButton(
                    text: CatalogConstant.ADD_VARIANT,
                    backgroundColor: AppColors.softGrey,
                    textColor: AppColors.textPrimary,
                    icon: Icon(Icons.add, color: AppColors.textPrimary, size: 20.w),
                    onPressed: () => Navigator.pushNamed(context, '/create-variant', arguments: currentItem),
                  ),
                ],
              ),
            ),
          );`;

content = content.replace(replaceRegex, replacement);

fs.writeFileSync('apps/mobile/lib/features/catalog/pages/item.detail.page.dart', content);
