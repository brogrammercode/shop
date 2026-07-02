import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/core/color.dart';

class StoreDetailsHeader extends StatelessWidget {
  const StoreDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopNavigation(context),
        _buildStoreDetailsBlock(),
        _buildFiltersSection(),
      ],
    );
  }

  Widget _buildTopNavigation(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: const [
                    BoxShadow(color: AppColors.shadowColor, blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: AppColors.textPrimary, size: 16.w),
                    SizedBox(width: 6.w),
                    Text(
                      'Search',
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Container(
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoreDetailsBlock() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(6.r)),
            child: Row(
               mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.eco, color: AppColors.primaryGreen, size: 12.w),
                SizedBox(width: 4.w),
                Text(
                  'Pure Veg',
                  style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w700, color: AppColors.primaryGreen),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'The Sweets Store',
                      style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                    ),
                    SizedBox(width: 6.w),
                    Icon(Icons.info_outline, color: AppColors.textSecondary, size: 18.w),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(color: AppColors.primaryGreen, borderRadius: BorderRadius.circular(8.r)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '4.3',
                          style: TextStyle(color: AppColors.pureWhite, fontSize: 12.sp, fontWeight: FontWeight.w900),
                        ),
                        SizedBox(width: 2.w),
                        Icon(Icons.star, color: AppColors.pureWhite, size: 12.w),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '10K+ ratings',
                    style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: AppColors.textTertiary),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: AppColors.textSecondary, size: 14.w),
              SizedBox(width: 4.w),
              Text(
                '3.5 km  •  Downtown Area',
                style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(Icons.access_time, color: AppColors.textSecondary, size: 14.w),
              SizedBox(width: 4.w),
              Text(
                '35-40 mins  •  Standard Delivery',
                style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
              ),
              Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 16.w),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.borderGrey),
            ),
            child: Row(
               mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_outline, color: AppColors.primaryGreen, size: 14.w),
                SizedBox(width: 6.w),
                Text(
                  'FSSAI Registered',
                  style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Container(height: 1.h, color: AppColors.borderGrey),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.local_offer, color: const Color(0xFF2563EB), size: 16.w),
              SizedBox(width: 6.w),
              Text(
                '20% OFF up to ₹50',
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: AppColors.textSecondary),
              ),
              const Spacer(),
              Text(
                '3 offers',
                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: AppColors.textTertiary),
              ),
              Icon(Icons.keyboard_arrow_down, color: AppColors.textTertiary, size: 14.w),
            ],
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    final List<Map<String, dynamic>> filters = [
      {'label': 'Filters', 'icon': Icons.tune, 'dropdown': true},
      {'label': 'Highly reordered', 'icon': Icons.autorenew, 'dropdown': false, 'iconColor': AppColors.primaryGreen},
      {'label': 'Spicy', 'icon': Icons.restaurant_menu, 'dropdown': false, 'iconColor': Colors.red},
      {'label': "Kid's", 'icon': Icons.face, 'dropdown': false, 'iconColor': Colors.orange},
    ];

    return Container(
      color: AppColors.softGrey.withValues(alpha: 0.5),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: filters.map((f) {
            return Container(
              margin: EdgeInsets.only(right: 8.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.borderGrey),
              ),
              child: Row(
                children: [
                  if (f['icon'] != null) ...[
                    Icon(f['icon'] as IconData, size: 14.w, color: f['iconColor'] ?? AppColors.textSecondary),
                    SizedBox(width: 4.w),
                  ],
                  Text(
                    f['label'] as String,
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  if (f['dropdown'] as bool) ...[
                    SizedBox(width: 4.w),
                    Icon(Icons.keyboard_arrow_down, size: 14.w, color: AppColors.textSecondary),
                  ],
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
