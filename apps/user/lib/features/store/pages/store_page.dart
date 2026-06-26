import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/components/ui/button.dart';
import 'package:user/core/color.dart';
import 'package:user/features/store/_data_dummy/store_page.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  bool isSweetsExpanded = true;
  String selectedFilter = 'Filters';
  int cartItemCount = 0;
  double cartTotalPrice = 0.0;
  String? addedDishImageUrl;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: statusBarHeight + 10.h),
                _buildTopNavigation(context),
                _buildStoreDetailsBlock(),
                _buildFiltersSection(),
                _buildMenuSection(),
                SizedBox(height: cartItemCount > 0 ? 160.h : 100.h),
              ],
            ),
          ),
          _buildFloatingMenuButton(),
          if (cartItemCount > 0) _buildBottomCartBar(),
        ],
      ),
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
              child: Icon(
                Icons.chevron_left,
                color: AppColors.textPrimary,
                size: 24.w,
              ),
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
                    BoxShadow(
                      color: AppColors.shadowColor,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: AppColors.textPrimary,
                      size: 16.w,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Search',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
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
                    BoxShadow(
                      color: AppColors.shadowColor,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.more_vert,
                  color: AppColors.textPrimary,
                  size: 20.w,
                ),
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
                  dummyStoreDetails.vegStatus,
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryGreen,
                  ),
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
                      dummyStoreDetails.name,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Icon(
                      Icons.info_outline,
                      color: AppColors.textSecondary,
                      size: 18.w,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          dummyStoreDetails.rating.toString(),
                          style: TextStyle(
                            color: AppColors.pureWhite,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Icon(
                          Icons.star,
                          color: AppColors.pureWhite,
                          size: 12.w,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    dummyStoreDetails.ratingCount,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: AppColors.textSecondary,
                size: 14.w,
              ),
              SizedBox(width: 4.w),
              Text(
                '${dummyStoreDetails.distance}  •  ${dummyStoreDetails.locality}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: AppColors.textSecondary,
                size: 14.w,
              ),
              SizedBox(width: 4.w),
              Text(
                '${dummyStoreDetails.deliveryTime}  •  ${dummyStoreDetails.scheduleLabel}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textSecondary,
                size: 16.w,
              ),
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
                Icon(
                  Icons.check_circle_outline,
                  color: AppColors.primaryGreen,
                  size: 14.w,
                ),
                SizedBox(width: 6.w),
                Text(
                  dummyStoreDetails.complaintsText,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Container(height: 1.h, color: AppColors.borderGrey),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.local_offer,
                color: const Color(0xFF2563EB),
                size: 16.w,
              ),
              SizedBox(width: 6.w),
              Text(
                dummyStoreDetails.mainOffer,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                dummyStoreDetails.totalOffersText,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textTertiary,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textTertiary,
                size: 14.w,
              ),
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
      {
        'label': 'Highly reordered',
        'icon': Icons.autorenew,
        'dropdown': false,
        'iconColor': AppColors.primaryGreen,
      },
      {
        'label': 'Spicy',
        'icon': Icons.restaurant_menu,
        'dropdown': false,
        'iconColor': Colors.red,
      },
      {
        'label': "Kid's",
        'icon': Icons.face,
        'dropdown': false,
        'iconColor': Colors.orange,
      },
    ];

    return Container(
      color: AppColors.softGrey.withValues(alpha: 0.5),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: filters.map((f) {
                return Container(
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
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
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 14.w,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isSweetsExpanded = !isSweetsExpanded;
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Best in Sweets',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                Icon(
                  isSweetsExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.textPrimary,
                  size: 24.w,
                ),
              ],
            ),
          ),
        ),
        if (isSweetsExpanded)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dummyStoreDishes.length,
            itemBuilder: (context, index) {
              final dish = dummyStoreDishes[index];
              return _buildDishListItem(dish);
            },
          ),
      ],
    );
  }

  Widget _buildDishListItem(DishItem dish) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderGrey, width: 1.h),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 14.w,
                  height: 14.w,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 1.5),
                    color: AppColors.pureWhite,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  dish.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Container(
                      width: 24.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      dish.badge,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  '₹${dish.price.toInt()}',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  dish.description,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderGrey),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.bookmark_border,
                        color: AppColors.textSecondary,
                        size: 16.w,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderGrey),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.share_outlined,
                        color: AppColors.textSecondary,
                        size: 16.w,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      image: DecorationImage(
                        image: NetworkImage(dish.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -15.h,
                    child: Container(
                      width: 90.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: AppColors.primaryGreen,
                          width: 1.w,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadowColor,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: AppButton(
                        onPressed: () =>
                            _showCustomisationBottomSheet(context, dish),
                        backgroundColor: const Color(0xFFE8F5E9),
                        textColor: AppColors.primaryGreen,
                        text: 'ADD',
                        padding: EdgeInsets.zero,
                        isFullWidth: false,
                        height: 36.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ADD',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.add,
                              color: AppColors.primaryGreen,
                              size: 14.w,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Text(
                'customisable',
                style: TextStyle(
                  fontSize: 9.sp,
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingMenuButton() {
    return Positioned(
      bottom: cartItemCount > 0 ? 130.h : 24.h,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.deepOnyx,
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.restaurant_menu,
                color: AppColors.pureWhite,
                size: 16.w,
              ),
              SizedBox(width: 8.w),
              Text(
                'Menu',
                style: TextStyle(
                  color: AppColors.pureWhite,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCustomisationBottomSheet(BuildContext context, DishItem dish) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CustomisationModal(dish: dish);
      },
    );

    if (result != null) {
      setState(() {
        cartItemCount = (result['quantity'] as int);
        cartTotalPrice = (result['price'] as double);
        addedDishImageUrl = dish.imageUrl;
      });
    }
  }

  Widget _buildBottomCartBar() {
    return Positioned(
      bottom: 16.h,
      left: 16.w,
      right: 16.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE3F2FD), Color(0xFFF1F8E9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              border: const Border(
                top: BorderSide(color: Color(0xFFBBDEFB)),
                left: BorderSide(color: Color(0xFFBBDEFB)),
                right: BorderSide(color: Color(0xFFBBDEFB)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2563EB),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.percent,
                    color: AppColors.pureWhite,
                    size: 10.w,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Unlock Flat ₹40 OFF',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1E3A8A),
                        ),
                      ),
                      Text(
                        'Add items worth ₹46 or more to unlock',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_up,
                  color: const Color(0xFF1E3A8A),
                  size: 16.w,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/cart');
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.r)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (addedDishImageUrl != null)
                        Container(
                          width: 32.w,
                          height: 32.w,
                          margin: EdgeInsets.only(right: 10.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.r),
                            image: DecorationImage(
                              image: NetworkImage(addedDishImageUrl!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      Text(
                        '$cartItemCount ${cartItemCount == 1 ? "item" : "items"} added',
                        style: TextStyle(
                          color: AppColors.pureWhite,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'View cart',
                        style: TextStyle(
                          color: AppColors.pureWhite,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.chevron_right,
                        color: AppColors.pureWhite,
                        size: 16.w,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomisationModal extends StatefulWidget {
  final DishItem dish;

  const CustomisationModal({super.key, required this.dish});

  @override
  State<CustomisationModal> createState() => _CustomisationModalState();
}

class _CustomisationModalState extends State<CustomisationModal> {
  int selectedOptionIndex = 0;
  int quantityCount = 1;

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final selectedOption = widget.dish.options[selectedOptionIndex];
    final double totalPrice = selectedOption.price * quantityCount;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned(
          top: deviceHeight * 0.15,
          left: 16.w,
          right: 16.w,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CircleAvatar(
              backgroundColor: AppColors.deepOnyx,
              radius: 20.r,
              child: Icon(Icons.close, color: AppColors.pureWhite, size: 20.w),
            ),
          ),
        ),
        Container(
          height: deviceHeight * 0.76,
          decoration: BoxDecoration(
            color: AppColors.pureWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(widget.dish.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 14.w,
                            height: 14.w,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.green,
                                width: 1.5,
                              ),
                              color: AppColors.pureWhite,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                            alignment: Alignment.center,
                            child: Container(
                              width: 6.w,
                              height: 6.w,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.bookmark_border,
                                color: AppColors.textSecondary,
                                size: 20.w,
                              ),
                              SizedBox(width: 16.w),
                              Icon(
                                Icons.share_outlined,
                                color: AppColors.textSecondary,
                                size: 20.w,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        widget.dish.name,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Container(
                            width: 24.w,
                            height: 6.h,
                            decoration: BoxDecoration(
                              color: AppColors.primaryGreen,
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            widget.dish.badge,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        widget.dish.description,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Container(height: 1.h, color: AppColors.borderGrey),
                      SizedBox(height: 16.h),
                      Text(
                        'Quantity',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Required • Select any 1 option',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textTertiary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Column(
                        children: List.generate(widget.dish.options.length, (
                          index,
                        ) {
                          final opt = widget.dish.options[index];
                          final isSelected = selectedOptionIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedOptionIndex = index;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    opt.label,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: isSelected
                                          ? FontWeight.w800
                                          : FontWeight.w500,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '₹${opt.price.toInt()}',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: isSelected
                                              ? FontWeight.w800
                                              : FontWeight.w500,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Icon(
                                        isSelected
                                            ? Icons.radio_button_checked
                                            : Icons.radio_button_off,
                                        color: isSelected
                                            ? AppColors.primaryGreen
                                            : AppColors.textTertiary,
                                        size: 20.w,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  border: Border(
                    top: BorderSide(color: AppColors.borderGrey, width: 1.h),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primaryGreen),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (quantityCount > 1) {
                                setState(() {
                                  quantityCount--;
                                });
                              }
                            },
                            child: Icon(
                              Icons.remove,
                              color: AppColors.primaryGreen,
                              size: 16.w,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Text(
                            quantityCount.toString(),
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                quantityCount++;
                              });
                            },
                            child: Icon(
                              Icons.add,
                              color: AppColors.primaryGreen,
                              size: 16.w,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: SizedBox(
                        height: 48.h,
                        child: AppButton(
                          onPressed: () {
                            Navigator.pop(context, {
                              'quantity': quantityCount,
                              'price': totalPrice,
                            });
                          },
                          backgroundColor: AppColors.primaryGreen,
                          text: 'Add item ₹${totalPrice.toInt()}',
                          height: 48.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
