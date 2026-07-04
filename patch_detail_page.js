const fs = require('fs');

let content = fs.readFileSync('apps/mobile/lib/features/catalog/pages/item.detail.page.dart', 'utf8');

// 1. Add AppLoader import if missing
if (!content.includes("import 'package:mobile/components/ui/loader.dart';")) {
  content = content.replace(
    "import 'package:mobile/components/ui/input.dart';",
    "import 'package:mobile/components/ui/input.dart';\nimport 'package:mobile/components/ui/loader.dart';"
  );
}

// 2. Replace CircularProgressIndicator with AppLoader
content = content.replace(
  "const Padding(\n                      padding: EdgeInsets.symmetric(vertical: 24.0),\n                      child: Center(child: CircularProgressIndicator()),\n                    )",
  "const Padding(\n                      padding: EdgeInsets.symmetric(vertical: 24.0),\n                      child: Center(child: AppLoader()),\n                    )"
);

// 3. Replace _buildVariantCard with richer version
const targetCard = `  Widget _buildVariantCard(BuildContext context, ItemVariantModel variant, InventoryState state) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: AppColors.pureWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
          builder: (_) => _EditVariantSheet(variant: variant, item: _item!, uoms: state.uoms),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(color: AppColors.pureWhite, border: Border.all(color: AppColors.borderGrey), borderRadius: BorderRadius.circular(12.r), boxShadow: const [BoxShadow(color: AppColors.shadowColor, blurRadius: 4, offset: Offset(0, 2))]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  if (variant.images.isNotEmpty)
                    Container(
                      width: 48.w,
                      height: 48.w,
                      margin: EdgeInsets.only(right: 12.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        image: DecorationImage(image: NetworkImage(variant.images.first), fit: BoxFit.cover),
                      ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(variant.name?.isNotEmpty == true ? variant.name! : variant.sku, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                        SizedBox(height: 4.h),
                        Text(variant.name?.isNotEmpty == true ? 'SKU: \${variant.sku} • Cost: ₹\${variant.base_cost}' : 'Cost: ₹\${variant.base_cost}', style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }`;

const richCard = `  Widget _buildVariantCard(BuildContext context, ItemVariantModel variant, InventoryState state) {
    final uom = state.uoms.where((u) => u.id == variant.uom_id).firstOrNull;
    final uomDesc = uom != null ? uom.code : 'Unit';
    
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: AppColors.pureWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
          builder: (_) => _EditVariantSheet(variant: variant, item: _item!, uoms: state.uoms),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: AppColors.pureWhite, 
          border: Border.all(color: AppColors.borderGrey.withOpacity(0.5)), 
          borderRadius: BorderRadius.circular(16.r), 
          boxShadow: [
            BoxShadow(color: AppColors.shadowColor.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
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
                  if (variant.images.isNotEmpty)
                    Container(
                      width: 72.w,
                      height: 72.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        image: DecorationImage(image: NetworkImage(variant.images.first), fit: BoxFit.cover),
                        boxShadow: const [BoxShadow(color: AppColors.shadowColor, blurRadius: 4, offset: Offset(0, 2))],
                      ),
                    )
                  else
                    Container(
                      width: 72.w,
                      height: 72.w,
                      decoration: BoxDecoration(
                        color: AppColors.softGrey,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.borderGrey),
                      ),
                      child: Center(
                        child: Icon(Icons.image_not_supported_outlined, color: AppColors.textTertiary, size: 24.w),
                      ),
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
                                variant.name?.isNotEmpty == true ? variant.name! : 'Variant \${variant.sku}', 
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary, letterSpacing: -0.3), 
                                maxLines: 2, 
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: variant.status == 'ACTIVE' ? AppColors.primaryGreen.withOpacity(0.1) : AppColors.errorRed.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                variant.status, 
                                style: TextStyle(
                                  fontSize: 10.sp, 
                                  fontWeight: FontWeight.w800, 
                                  color: variant.status == 'ACTIVE' ? AppColors.primaryGreen : AppColors.errorRed,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(4.r)),
                              child: Text('SKU: \${variant.sku}', style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                            ),
                            if (variant.barcode.isNotEmpty) ...[
                              SizedBox(width: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(4.r)),
                                child: Row(
                                  children: [
                                    Icon(Icons.qr_code_2, size: 12.w, color: AppColors.textSecondary),
                                    SizedBox(width: 4.w),
                                    Text(variant.barcode, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                            ],
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
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
                border: Border(top: BorderSide(color: AppColors.borderGrey.withOpacity(0.5))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Base Cost', style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: AppColors.textTertiary)),
                      SizedBox(height: 2.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text('₹\${variant.base_cost.toStringAsFixed(2)}', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.primaryGreen)),
                          Text(' / $uomDesc', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Min Stock', style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: AppColors.textTertiary)),
                      SizedBox(height: 2.h),
                      Text('\${variant.min_stock_lvl} $uomDesc', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }`;

content = content.replace(targetCard, richCard);

fs.writeFileSync('apps/mobile/lib/features/catalog/pages/item.detail.page.dart', content);
