import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/components/ui/button.dart';
import 'package:user/core/color.dart';
import 'package:user/features/home/_data_dummy/food_page.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  late FoodPageArgs _args;
  bool _argsInitialized = false;

  int _quantity = 1;
  final Map<String, int> _subItemQty = {};

  final PageController _imageController = PageController();
  int _currentImageIndex = 0;

  double get _subItemsTotal {
    double total = 0;
    for (final sub in dummyFoodSubItems) {
      final qty = _subItemQty[sub.id] ?? 0;
      total += sub.price * qty;
    }
    return total;
  }

  double get _grandTotal => (_args.price * _quantity) + _subItemsTotal;

  bool get _isEditMode => _args.initialQuantity > 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_argsInitialized) {
      _args = ModalRoute.of(context)!.settings.arguments as FoodPageArgs;
      _quantity = _args.initialQuantity > 0 ? _args.initialQuantity : 1;
      for (final sub in _args.initialSubItems) {
        _subItemQty[sub.id] = sub.quantity;
      }
      _argsInitialized = true;
    }
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  void _incrementSub(String id) {
    setState(() {
      _subItemQty[id] = (_subItemQty[id] ?? 0) + 1;
    });
  }

  void _decrementSub(String id) {
    setState(() {
      final current = _subItemQty[id] ?? 0;
      if (current <= 1) {
        _subItemQty.remove(id);
      } else {
        _subItemQty[id] = current - 1;
      }
    });
  }

  void _confirmAndPop() {
    final selectedSubItems = dummyFoodSubItems
        .where((sub) => (_subItemQty[sub.id] ?? 0) > 0)
        .map((sub) => CartSubItem(
              id: sub.id,
              name: sub.name,
              price: sub.price,
              quantity: _subItemQty[sub.id]!,
            ))
        .toList();

    Navigator.pop(
      context,
      FoodPageResult(
        quantity: _quantity,
        subItems: selectedSubItems,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_argsInitialized) return const SizedBox.shrink();

    final double screenHeight = MediaQuery.of(context).size.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final List<String> allImages = [_args.imageUrl, ...dummyFoodExtraImages];

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(allImages, screenHeight, statusBarHeight),
                _buildFoodInfoCard(),
                SizedBox(height: 8.h),
                _buildSubItemsSection(),
                SizedBox(height: 8.h),
                _buildReviewsSection(),
                SizedBox(height: 100.h),
              ],
            ),
          ),
          _buildTopActions(statusBarHeight),
          _buildStickyBottom(),
        ],
      ),
    );
  }

  Widget _buildImageSection(List<String> images, double screenHeight, double statusBarHeight) {
    return SizedBox(
      height: screenHeight * 0.42,
      child: Stack(
        children: [
          PageView.builder(
            controller: _imageController,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Image.network(
                images[index],
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.35),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.55),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (i) {
                final isActive = i == _currentImageIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: isActive ? 18.w : 6.w,
                  height: 6.w,
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.r),
                    color: isActive
                        ? AppColors.pureWhite
                        : AppColors.pureWhite.withValues(alpha: 0.4),
                  ),
                );
              }),
            ),
          ),
          Positioned(
            bottom: 16.h,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '${_currentImageIndex + 1}/${images.length}',
                style: TextStyle(
                  color: AppColors.pureWhite,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopActions(double statusBarHeight) {
    return Positioned(
      top: statusBarHeight + 8.h,
      left: 16.w,
      right: 16.w,
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
                  BoxShadow(color: AppColors.shadowColor, blurRadius: 6, offset: Offset(0, 2)),
                ],
              ),
              child: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20.w),
            ),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: const BoxDecoration(
                  color: AppColors.pureWhite,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: AppColors.shadowColor, blurRadius: 6, offset: Offset(0, 2)),
                  ],
                ),
                child: Icon(Icons.share_outlined, color: AppColors.textPrimary, size: 20.w),
              ),
              SizedBox(width: 10.w),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: const BoxDecoration(
                  color: AppColors.pureWhite,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: AppColors.shadowColor, blurRadius: 6, offset: Offset(0, 2)),
                  ],
                ),
                child: Icon(Icons.bookmark_border, color: AppColors.textPrimary, size: 20.w),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFoodInfoCard() {
    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 4.h),
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
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  _args.name,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _args.rating.toString(),
                      style: TextStyle(
                        color: AppColors.pureWhite,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Icon(Icons.star, color: AppColors.pureWhite, size: 11.w),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '₹${_args.price.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryGreen,
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Icon(Icons.access_time, size: 13.w, color: AppColors.textSecondary),
              SizedBox(width: 4.w),
              Text(
                '30–35 mins delivery',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(width: 12.w),
              Icon(Icons.location_on_outlined, size: 13.w, color: AppColors.textSecondary),
              SizedBox(width: 4.w),
              Text(
                '5.5 km away',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(height: 1.h, color: AppColors.borderGrey),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quantity',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryGreen, width: 1.5),
                  borderRadius: BorderRadius.circular(10.r),
                  color: const Color(0xFFE8F5E9),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_quantity > 1) setState(() => _quantity--);
                      },
                      child: Icon(Icons.remove, color: AppColors.primaryGreen, size: 18.w),
                    ),
                    SizedBox(width: 20.w),
                    Text(
                      _quantity.toString(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    SizedBox(width: 20.w),
                    GestureDetector(
                      onTap: () => setState(() => _quantity++),
                      child: Icon(Icons.add, color: AppColors.primaryGreen, size: 18.w),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubItemsSection() {
    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Container(width: 3.w, height: 16.h, color: AppColors.primaryGreen),
                SizedBox(width: 8.w),
                Text(
                  'MAKE IT A MEAL',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    'Add-ons',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          SizedBox(
            height: 180.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: dummyFoodSubItems.length,
              itemBuilder: (context, index) {
                final sub = dummyFoodSubItems[index];
                final qty = _subItemQty[sub.id] ?? 0;
                return _buildSubItemCard(sub, qty);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubItemCard(FoodSubItem sub, int qty) {
    return Container(
      width: 120.w,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: qty > 0 ? AppColors.primaryGreen : AppColors.borderGrey,
          width: qty > 0 ? 1.5 : 1.0,
        ),
        boxShadow: const [
          BoxShadow(color: AppColors.shadowColor, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            child: Image.network(
              sub.imageUrl,
              height: 90.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sub.name,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  '₹${sub.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 6.h),
                qty == 0
                    ? GestureDetector(
                        onTap: () => _incrementSub(sub.id),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(color: AppColors.primaryGreen),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'ADD',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(color: AppColors.primaryGreen),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () => _decrementSub(sub.id),
                              child: Padding(
                                padding: EdgeInsets.all(4.w),
                                child: Icon(Icons.remove, color: AppColors.primaryGreen, size: 12.w),
                              ),
                            ),
                            Text(
                              qty.toString(),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _incrementSub(sub.id),
                              child: Padding(
                                padding: EdgeInsets.all(4.w),
                                child: Icon(Icons.add, color: AppColors.primaryGreen, size: 12.w),
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
    );
  }

  Widget _buildReviewsSection() {
    final double avgRating = dummyFoodReviews
            .map((r) => r.rating)
            .reduce((a, b) => a + b) /
        dummyFoodReviews.length;

    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 3.w, height: 16.h, color: AppColors.primaryGreen),
              SizedBox(width: 8.w),
              Text(
                'WHAT PEOPLE SAY',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryGreen.withValues(alpha: 0.08),
                  AppColors.primaryGreen.withValues(alpha: 0.03),
                ],
              ),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      avgRating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryGreen,
                        height: 1.0,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: List.generate(5, (i) {
                        return Icon(
                          i < avgRating.floor() ? Icons.star : Icons.star_border,
                          color: AppColors.primaryGreen,
                          size: 14.w,
                        );
                      }),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${dummyFoodReviews.length} reviews',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20.w),
                Container(width: 1.w, height: 60.h, color: AppColors.borderGrey),
                SizedBox(width: 20.w),
                Expanded(
                  child: Column(
                    children: [5, 4, 3, 2, 1].map((stars) {
                      final count = dummyFoodReviews.where((r) => r.rating.round() == stars).length;
                      final fraction = count / dummyFoodReviews.length;
                      return Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Row(
                          children: [
                            Text(
                              '$stars',
                              style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                            ),
                            SizedBox(width: 4.w),
                            Icon(Icons.star, size: 10.w, color: AppColors.primaryGreen),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4.r),
                                child: LinearProgressIndicator(
                                  value: fraction,
                                  backgroundColor: AppColors.borderGrey,
                                  color: AppColors.primaryGreen,
                                  minHeight: 6.h,
                                ),
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              '$count',
                              style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: AppColors.textTertiary),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          ...dummyFoodReviews.map((review) => _buildReviewCard(review)),
        ],
      ),
    );
  }

  Widget _buildReviewCard(FoodReview review) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: const [
          BoxShadow(color: AppColors.shadowColor, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundImage: NetworkImage(review.avatarUrl),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      review.date,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      review.rating.toString(),
                      style: TextStyle(
                        color: AppColors.pureWhite,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Icon(Icons.star, color: AppColors.pureWhite, size: 10.w),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            review.reviewText,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyBottom() {
    final int totalSubQty = _subItemQty.values.fold(0, (a, b) => a + b);
    final String buttonLabel = _isEditMode ? 'Update Cart' : 'Add to Cart';

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          border: Border(top: BorderSide(color: AppColors.borderGrey, width: 1.h)),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (totalSubQty > 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$totalSubQty add-on${totalSubQty == 1 ? '' : 's'} selected',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '+₹${_subItemsTotal.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
            ],
            AppButton(
              onPressed: _confirmAndPop,
              backgroundColor: AppColors.primaryGreen,
              text: '', // overridden by child
              height: 50.h,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹${_grandTotal.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: AppColors.pureWhite,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        '$_quantity item${_quantity == 1 ? '' : 's'} + add-ons',
                        style: TextStyle(
                          color: AppColors.pureWhite.withValues(alpha: 0.75),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        buttonLabel,
                        style: TextStyle(
                          color: AppColors.pureWhite,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(Icons.arrow_forward, color: AppColors.pureWhite, size: 16.w),
                    ],
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
