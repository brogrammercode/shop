import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/core/color.dart';
import 'package:user/features/home/_data_dummy/search_result.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final TextEditingController _searchController = TextEditingController(text: 'Sweets');
  String selectedSubCategoryId = 'sweets';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: statusBarHeight + 10.h),
          _buildSearchBar(context),
          _buildSubCategoriesRow(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDoubleRowFilters(),
                  _buildRecommendedSection(),
                  _buildAllRestaurantsSection(),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.chevron_left,
              color: AppColors.primaryGreen,
              size: 32.w,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 15.sp,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                    },
                    child: Icon(
                      Icons.close,
                      color: AppColors.textTertiary,
                      size: 18.w,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    height: 20.h,
                    width: 1.w,
                    color: AppColors.borderGrey,
                  ),
                  SizedBox(width: 12.w),
                  Icon(
                    Icons.mic,
                    color: AppColors.primaryGreen,
                    size: 22.w,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubCategoriesRow() {
    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: dummySubCategories.map((sub) {
            final isSelected = selectedSubCategoryId == sub.id;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedSubCategoryId = sub.id;
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: 20.w),
                child: Column(
                  children: [
                    Container(
                      width: 56.w,
                      height: 56.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadowColor,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                        image: DecorationImage(
                          image: NetworkImage(sub.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      sub.name,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    if (isSelected)
                      Container(
                        width: 36.w,
                        height: 3.h,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDoubleRowFilters() {
    final List<Map<String, dynamic>> row1Filters = [
      {'label': 'Filters', 'icon': Icons.tune, 'dropdown': true},
      {'label': 'New to you', 'icon': null, 'dropdown': false},
      {'label': 'Under ₹100', 'icon': null, 'dropdown': false},
      {'label': 'Pure Veg', 'icon': null, 'dropdown': false},
    ];

    final List<Map<String, dynamic>> row2Filters = [
      {'label': 'Near & Fast', 'icon': Icons.bolt, 'dropdown': false, 'iconColor': AppColors.primaryGreen},
      {'label': 'Schedule', 'icon': null, 'dropdown': true},
      {'label': 'Great offers', 'icon': null, 'dropdown': false},
      {'label': 'Rating', 'icon': null, 'dropdown': false},
    ];

    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: row1Filters.map((f) => _buildFilterChip(f)).toList(),
            ),
          ),
          SizedBox(height: 8.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: row2Filters.map((f) => _buildFilterChip(f)).toList(),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildFilterChip(Map<String, dynamic> f) {
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
            Icon(
              f['icon'] as IconData,
              size: 14.w,
              color: f['iconColor'] ?? AppColors.textSecondary,
            ),
            SizedBox(width: 4.w),
          ],
          Text(
            f['label'] as String,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          if (f['dropdown'] as bool) ...[
            SizedBox(width: 4.w),
            Icon(Icons.keyboard_arrow_down, size: 14.w, color: AppColors.textSecondary),
          ],
        ],
      ),
    );
  }

  Widget _buildRecommendedSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RECOMMENDED FOR YOU',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textTertiary,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 16.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dummySearchResultRecommended.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 0.62,
            ),
            itemBuilder: (context, index) {
              final rest = dummySearchResultRecommended[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/store');
                },
                child: _buildRestaurantCard(rest),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantCard(SearchResultRestaurant rest) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  image: DecorationImage(
                    image: NetworkImage(rest.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 6.h,
                left: 6.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    rest.promoText,
                    style: TextStyle(
                      color: AppColors.pureWhite,
                      fontSize: 7.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 6.h,
                left: 6.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    children: [
                      Text(
                        rest.rating.toString(),
                        style: TextStyle(
                          color: AppColors.pureWhite,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Icon(
                        Icons.star,
                        color: AppColors.pureWhite,
                        size: 9.w,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          rest.name,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            if (rest.isNearAndFast) ...[
              Icon(
                Icons.bolt,
                size: 11.w,
                color: AppColors.primaryGreen,
              ),
              SizedBox(width: 2.w),
              Text(
                rest.deliveryTime,
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryGreen,
                ),
              ),
            ] else ...[
              Icon(
                Icons.access_time,
                size: 11.w,
                color: AppColors.textTertiary,
              ),
              SizedBox(width: 2.w),
              Text(
                rest.deliveryTime,
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildAllRestaurantsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ALL RESTAURANTS',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textTertiary,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 16.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dummySearchResultLarge.length,
            itemBuilder: (context, index) {
              final rest = dummySearchResultLarge[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/store');
                },
                child: _buildLargeRestaurantCard(rest),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLargeRestaurantCard(SearchResultLargeRestaurant rest) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 200.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                  image: DecorationImage(
                    image: NetworkImage(rest.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 12.h,
                left: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green, width: 1.5),
                          color: AppColors.pureWhite,
                          borderRadius: BorderRadius.circular(1.r),
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          width: 4.w,
                          height: 4.w,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        rest.dishSpotlight,
                        style: TextStyle(
                          color: AppColors.pureWhite,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (rest.isAd)
                Positioned(
                  top: 12.h,
                  right: 48.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      'Ad',
                      style: TextStyle(
                        color: AppColors.pureWhite,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 12.h,
                right: 12.w,
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: const BoxDecoration(
                    color: AppColors.pureWhite,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.bookmark_border,
                    color: AppColors.textPrimary,
                    size: 18.w,
                  ),
                ),
              ),
              Positioned(
                bottom: 12.h,
                right: 12.w,
                child: Row(
                  children: List.generate(4, (i) {
                    return Container(
                      width: 5.w,
                      height: 5.w,
                      margin: EdgeInsets.symmetric(horizontal: 1.5.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == 0 ? AppColors.pureWhite : Colors.white60,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        rest.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                rest.rating.toString(),
                                style: TextStyle(
                                  color: AppColors.pureWhite,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Icon(Icons.star, color: AppColors.pureWhite, size: 10.w),
                            ],
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          rest.ratingCount,
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12.w,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${rest.deliveryTime}  •  ${rest.distance}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Container(
                  height: 1.h,
                  color: AppColors.borderGrey,
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.local_offer, color: const Color(0xFF2563EB), size: 14.w),
                    SizedBox(width: 4.w),
                    Text(
                      rest.offer,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                if (rest.isPureVeg) ...[
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.eco, color: AppColors.primaryGreen, size: 12.w),
                        SizedBox(width: 4.w),
                        Text(
                          'Pure Veg restaurant',
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
