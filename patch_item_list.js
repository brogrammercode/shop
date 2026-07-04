const fs = require('fs');

let content = fs.readFileSync('apps/mobile/lib/features/catalog/pages/item.list.page.dart', 'utf8');

const targetBuilder = `  Widget _buildItemCard(
    BuildContext context,
    ItemModel item,
    List<ItemCategoryModel> categories,
  ) {
    final catName =
        categories.where((c) => c.id == item.category_id).firstOrNull?.name ??
        'Unknown';
    // We will show actual variant count later, for now hardcode 0 since items model doesn't embed variants directly unless joined.
    // If we want it joined, we need Prisma include, but right now let's just show it.

    return GestureDetector(
      // We will pass the item as arguments to the detail page.
      onTap: () =>
          Navigator.pushNamed(context, '/item-detail', arguments: item),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.borderGrey),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (item.images.isNotEmpty)
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  image: DecorationImage(
                    image: NetworkImage(item.images.first),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  item.name.isNotEmpty ? item.name.substring(0, 1).toUpperCase() : '?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: AppColors.primaryGreen),
                ),
              ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    catName,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFFDBEAFE),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                '0 Variants',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1D4ED8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }`;

const replacementBuilder = `  Widget _buildItemCard(BuildContext context, ItemModel item, List<ItemCategoryModel> categories) {
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
                          child: Text('Shelf Life: \${item.shelf_life_days} Days', style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w800, color: const Color(0xFF92400E))),
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
  }`;

content = content.replace(targetBuilder, replacementBuilder);

fs.writeFileSync('apps/mobile/lib/features/catalog/pages/item.list.page.dart', content);
