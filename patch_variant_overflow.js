const fs = require('fs');

let content = fs.readFileSync('apps/mobile/lib/features/catalog/pages/item.detail.page.dart', 'utf8');

const oldCard = `  Widget _buildVariantCard(BuildContext context, ItemVariantModel variant, InventoryState state) {
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
                                color: variant.status == 'ACTIVE' ? AppColors.primaryGreen.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                variant.status, 
                                style: TextStyle(
                                  fontSize: 10.sp, 
                                  fontWeight: FontWeight.w800, 
                                  color: variant.status == 'ACTIVE' ? AppColors.primaryGreen : AppColors.error,
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

const newCard = `  Widget _buildVariantCard(BuildContext context, ItemVariantModel variant, InventoryState state) {
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
            BoxShadow(color: AppColors.shadowColor.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4)),
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
                            image: DecorationImage(image: NetworkImage(variant.images.first), fit: BoxFit.cover),
                            boxShadow: const [BoxShadow(color: AppColors.shadowColor, blurRadius: 4, offset: Offset(0, 2))],
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
                            child: Icon(Icons.inventory_2_outlined, color: AppColors.textTertiary, size: 32.w),
                          ),
                        ),
                      if (variant.images.length > 1)
                        Positioned(
                          bottom: 4.h,
                          right: 4.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppColors.deepOnyx.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.photo_library, color: AppColors.pureWhite, size: 10.w),
                                SizedBox(width: 4.w),
                                Text('\${variant.images.length}', style: TextStyle(color: AppColors.pureWhite, fontSize: 10.sp, fontWeight: FontWeight.w700)),
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
                                variant.name?.isNotEmpty == true ? variant.name! : 'Variant \${variant.sku}', 
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary, letterSpacing: -0.3), 
                                maxLines: 2, 
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: variant.status == 'ACTIVE' ? AppColors.primaryGreen.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                variant.status, 
                                style: TextStyle(
                                  fontSize: 10.sp, 
                                  fontWeight: FontWeight.w800, 
                                  color: variant.status == 'ACTIVE' ? AppColors.primaryGreen : AppColors.error,
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
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6), 
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(color: const Color(0xFFE5E7EB)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.tag, size: 12.w, color: AppColors.textSecondary),
                                  SizedBox(width: 4.w),
                                  Text(variant.sku, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            if (variant.barcode.isNotEmpty)
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6), 
                                  borderRadius: BorderRadius.circular(6.r),
                                  border: Border.all(color: const Color(0xFFE5E7EB)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.qr_code_2, size: 12.w, color: AppColors.textSecondary),
                                    SizedBox(width: 4.w),
                                    Text(variant.barcode, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
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
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
                border: Border(top: BorderSide(color: AppColors.borderGrey.withOpacity(0.5))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.payments_outlined, size: 14.w, color: AppColors.primaryGreen),
                            SizedBox(width: 4.w),
                            Text('Base Cost', style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text('₹\${variant.base_cost.toStringAsFixed(2)}', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: AppColors.primaryGreen)),
                            Text(' / $uomDesc', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: AppColors.textTertiary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1.w, height: 32.h, color: AppColors.borderGrey),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.inventory_outlined, size: 14.w, color: const Color(0xFFD97706)),
                            SizedBox(width: 4.w),
                            Text('Min Stock', style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text('\${variant.min_stock_lvl} $uomDesc', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
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
  }`;

content = content.replace(oldCard, newCard);

fs.writeFileSync('apps/mobile/lib/features/catalog/pages/item.detail.page.dart', content);
