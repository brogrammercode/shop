const fs = require('fs');

let content = fs.readFileSync('apps/mobile/lib/features/catalog/pages/item.detail.page.dart', 'utf8');

// Fix 1: Wrap Column in _EditVariantSheet with SingleChildScrollView
const editVariantTarget = `            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(`;

const editVariantReplacement = `            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(`;

content = content.replace(editVariantTarget, editVariantReplacement);

// Fix 2: Wrap Variant list card text with Expanded to prevent overflow
// First, find the Inner Row that has the thumbnail and Column
const innerRowTarget = `                                Row(
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
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                    Text(variant.name?.isNotEmpty == true ? variant.name! : variant.sku, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                                    SizedBox(height: 4.h),
                                    Text(variant.name?.isNotEmpty == true ? 'SKU: \${variant.sku} • Cost: ₹\${variant.base_cost}' : 'Cost: ₹\${variant.base_cost}', style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary)),
                                  ],
                                ),
                                  ],
                                    ),`;

const innerRowReplacement = `                                Expanded(
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
                                            Text(variant.name?.isNotEmpty == true ? variant.name! : variant.sku, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                                            SizedBox(height: 4.h),
                                            Text(variant.name?.isNotEmpty == true ? 'SKU: \${variant.sku} • Cost: ₹\${variant.base_cost}' : 'Cost: ₹\${variant.base_cost}', style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),`;

content = content.replace(innerRowTarget, innerRowReplacement);

// Fix the closing bracket of the SingleChildScrollView for _EditVariantSheet
// We need to add one more parenthesis or bracket at the end of _EditVariantSheet.
// The end of _EditVariantSheet is:
//               ],
//             ),
//           ),
//         );
//       },
//     );

const endEditVariantTarget = `              ],
            ),
          ),
        );
      },
    );
  }
}`;

const endEditVariantReplacement = `              ],
              ),
            ),
          ),
        );
      },
    );
  }
}`;

content = content.replace(endEditVariantTarget, endEditVariantReplacement);


fs.writeFileSync('apps/mobile/lib/features/catalog/pages/item.detail.page.dart', content);
