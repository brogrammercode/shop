import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/core/color.dart';
import 'package:user/features/home/_data_dummy/home_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategoryId = 'all';
  bool isVegMode = false;
  bool showTooltip = true;
  final PageController _bannerController = PageController();
  int _currentBannerIndex = 0;

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(statusBarHeight),
                  _buildCategoriesSection(),
                  _buildFiltersSection(),
                  _buildRecommendedSection(),
                  _buildExploreMoreSection(),
                  _buildLargeRestaurantsSection(),
                  SizedBox(height: 140.h),
                ],
              ),
            ),
          ),
          if (showTooltip) _buildFloatingTooltip(),
          _buildBottomFloatingNavigationBar(),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(double statusBarHeight) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFF5D1),
            AppColors.pureWhite,
          ],
          stops: [0.3, 1.0],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: statusBarHeight + 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppColors.textPrimary,
                            size: 20.w,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Home',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.textPrimary,
                            size: 20.w,
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: Text(
                          'Barari High School, Housing Board...',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.pureWhite,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: const Color(0xFFF1C40F),
                          width: 1.5,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadowColor,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'GOLD',
                            style: TextStyle(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFD4AC0D),
                              letterSpacing: 0.5,
                              height: 1.0,
                               ),
                          ),
                          Text(
                            '₹1',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFD4AC0D),
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9E6),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.borderGrey,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.wallet_giftcard,
                        color: AppColors.gold,
                        size: 18.w,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/setting'),
                      child: Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.borderGrey,
                            width: 1,
                          ),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=100',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/search');
                    },
                    child: Container(
                      height: 48.h,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: AppColors.pureWhite,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadowColor,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: AppColors.primaryGreen,
                            size: 22.w,
                          ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'Search "comfort food"',
                            style: TextStyle(
                              color: AppColors.textTertiary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Container(
                          height: 24.h,
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
              ),
              SizedBox(width: 16.w),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'VEG MODE',
                      style: TextStyle(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    SizedBox(
                      width: 36.w,
                      height: 20.h,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Switch(
                          value: isVegMode,
                          onChanged: (val) {
                            setState(() {
                              isVegMode = val;
                            });
                          },
                          activeThumbColor: AppColors.pureWhite,
                          activeTrackColor: AppColors.primaryGreen,
                          inactiveThumbColor: AppColors.textTertiary,
                          inactiveTrackColor: AppColors.softGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          _buildFullWidthPromoBanners(),
        ],
      ),
    );
  }

  Widget _buildFullWidthPromoBanners() {
    return Column(
      children: [
        SizedBox(
          height: 180.h,
          child: PageView.builder(
            controller: _bannerController,
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
            itemCount: dummyBanners.length,
            itemBuilder: (context, index) {
              final banner = dummyBanners[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadowColor,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                  image: DecorationImage(
                    image: NetworkImage(banner.imageUrl),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withValues(alpha: 0.2),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            banner.title,
                            style: TextStyle(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColors.pureWhite,
                              shadows: const [
                                Shadow(
                                  color: Colors.black38,
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            banner.subtitle,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.pureWhite,
                              shadows: const [
                                Shadow(
                                  color: Colors.black38,
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.pureWhite,
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Text(
                          banner.buttonText,
                          style: TextStyle(
                            color: AppColors.deepOnyx,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Container(
              width: 6.w,
              height: 6.w,
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index == _currentBannerIndex
                    ? AppColors.gold
                    : AppColors.borderGrey,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: dummyCategories.map((cat) {
            final isSelected = selectedCategoryId == cat.id;
            if (cat.isSpecialCard) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategoryId = cat.id;
                  });
                },
                child: Container(
                  width: 72.w,
                  height: 72.w,
                  margin: EdgeInsets.only(right: 20.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFE0F2FE),
                        Color(0xFFBAE6FD),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: const Color(0xFF0284C7),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        cat.name,
                        style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF0369A1),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '₹250',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF0369A1),
                        ),
                      ),
                      Text(
                        'Explore >',
                        style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0369A1),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategoryId = cat.id;
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: 20.w),
                child: Column(
                  children: [
                    Container(
                      width: 64.w,
                      height: 64.w,
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
                          image: NetworkImage(cat.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      cat.name,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    if (isSelected)
                      Container(
                        width: 40.w,
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

  Widget _buildFiltersSection() {
    final List<Map<String, dynamic>> filters = [
      {'label': 'Filters', 'icon': Icons.tune, 'dropdown': true},
      {'label': 'Near & Fast', 'icon': Icons.bolt, 'dropdown': false, 'iconColor': AppColors.primaryGreen},
      {'label': 'New to you', 'icon': null, 'dropdown': false},
      {'label': 'Schedule', 'icon': null, 'dropdown': true},
    ];

    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.only(bottom: 16.h),
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
          }).toList(),
        ),
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
            itemCount: dummyRestaurants.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 0.62,
            ),
            itemBuilder: (context, index) {
              final rest = dummyRestaurants[index];
              return _buildRestaurantCard(rest);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantCard(RestaurantItem rest) {
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
                'Near & Fast',
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

  Widget _buildExploreMoreSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EXPLORE MORE',
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
            itemCount: dummyExploreMore.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8.w,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              final item = dummyExploreMore[index];
              return Container(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _getExploreMoreIcon(item.iconType),
                    SizedBox(height: 8.h),
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _getExploreMoreIcon(String iconType) {
    switch (iconType) {
      case 'offers':
        return Container(
          padding: EdgeInsets.all(8.w),
          decoration: const BoxDecoration(
            color: Color(0xFFEFF6FF),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.local_offer, color: const Color(0xFF2563EB), size: 20.w),
        );
      case 'play_win':
        return Container(
          padding: EdgeInsets.all(8.w),
          decoration: const BoxDecoration(
            color: Color(0xFFFEF2F2),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.sports_cricket, color: const Color(0xFFEF4444), size: 20.w),
        );
      case 'train':
        return Container(
          padding: EdgeInsets.all(8.w),
          decoration: const BoxDecoration(
            color: Color(0xFFF0FDF4),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.train, color: const Color(0xFF22C55E), size: 20.w),
        );
      case 'collections':
        return Container(
          padding: EdgeInsets.all(8.w),
          decoration: const BoxDecoration(
            color: Color(0xFFFDF4FF),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.restaurant, color: const Color(0xFFA855F7), size: 20.w),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildLargeRestaurantsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '226 RESTAURANTS DELIVERING TO YOU',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textTertiary,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Featured',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dummyLargeRestaurants.length,
            itemBuilder: (context, index) {
              final rest = dummyLargeRestaurants[index];
              return _buildLargeRestaurantCard(rest);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLargeRestaurantCard(LargeRestaurantItem rest) {
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
                  children: rest.tags.map((tag) {
                    return Container(
                      margin: EdgeInsets.only(right: 8.w),
                      child: Row(
                        children: [
                          Icon(Icons.bolt, color: AppColors.primaryGreen, size: 12.w),
                          SizedBox(width: 2.w),
                          Text(
                            tag,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
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
                      rest.offers[0],
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.star_purple500_sharp, color: const Color(0xFFD4AC0D), size: 14.w),
                    SizedBox(width: 4.w),
                    Text(
                      rest.offers[1],
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingTooltip() {
    return Positioned(
      bottom: 84.h,
      left: 24.w,
      right: 24.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFF212121),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE0B2),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: const Color(0xFFE65100),
                    size: 16.w,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'Find meals under ₹250',
                    style: TextStyle(
                      color: AppColors.pureWhite,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showTooltip = false;
                    });
                  },
                  child: Icon(
                    Icons.close,
                    color: AppColors.pureWhite,
                    size: 16.w,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 140.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CustomPaint(
                size: Size(16.w, 8.h),
                painter: TrianglePainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomFloatingNavigationBar() {
    return Positioned(
      bottom: 16.h,
      left: 24.w,
      right: 24.w,
      child: Container(
        height: 58.h,
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.delivery_dining,
                    color: AppColors.primaryGreen,
                    size: 20.w,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Delivery',
                    style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.local_offer_outlined,
                  color: AppColors.textTertiary,
                  size: 20.w,
                ),
                SizedBox(width: 6.w),
                Text(
                  'Under ₹250',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.restaurant_menu,
                  color: AppColors.textTertiary,
                  size: 20.w,
                ),
                SizedBox(width: 6.w),
                Text(
                  'Dining',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF212121)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
