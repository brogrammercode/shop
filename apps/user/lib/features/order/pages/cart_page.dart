import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/core/color.dart';
import 'package:user/features/order/_data_dummy/cart_page.dart';
import 'package:user/features/home/_data_dummy/food_page.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String sizeInfo;
  final bool isVeg;
  int quantity;
  List<CartSubItem> subItems;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.sizeInfo,
    required this.isVeg,
    required this.quantity,
    this.subItems = const [],
  });
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<CartItem> cartItems;
  late CartAddress activeAddress;
  bool jioSaavnAdded = false;
  bool goldApplied = false;
  PaymentMethod selectedPaymentMethod = dummyPaymentMethods[2];

  @override
  void initState() {
    super.initState();
    cartItems = [
      CartItem(
        id: 'sohan_papdi',
        name: 'Sohan Papdi',
        price: 53,
        imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=500',
        sizeInfo: '2 Pieces',
        isVeg: true,
        quantity: 1,
        subItems: [],
      ),
    ];
    activeAddress = dummyAddresses[0];
  }

  double _calculateItemTotal() {
    double total = 0;
    for (var item in cartItems) {
      total += item.price * item.quantity;
      for (var sub in item.subItems) {
        total += sub.price * sub.quantity;
      }
    }
    return total;
  }

  double get taxesAndCharges {
    final double total = _calculateItemTotal();
    if (total >= 300) {
      return 27.99;
    }
    return 33.04;
  }

  double get deliveryCharge {
    if (goldApplied) {
      return 0.0;
    }
    return 42.0;
  }

  double get grandTotal {
    return _calculateItemTotal() + deliveryCharge + taxesAndCharges;
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Column(
        children: [
          SizedBox(height: statusBarHeight),
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildJioSaavnPromo(),
                  _buildCartItemsList(),
                  _buildHorizontalOptions(),
                  _buildDiscountChip(),
                  _buildSuggestionsCarousel(),
                  _buildGoldBanner(),
                  _buildZomatoMoney(),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
          _buildStickyFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Adarsh Jalpan',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: _showAddressBottomSheet,
                  child: Row(
                    children: [
                      Text(
                        '30-35 mins to ${activeAddress.title}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          ' | ${activeAddress.fullAddress}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 16.w),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.share_outlined, color: AppColors.textPrimary, size: 20.w),
        ],
      ),
    );
  }

  Widget _buildJioSaavnPromo() {
    final double itemTotal = _calculateItemTotal();
    final bool isUnlocked = itemTotal >= 99;
    final double neededAmount = 99 - itemTotal;

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFFFD1D1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Special offer for you',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFD32F2F),
                ),
              ),
              Icon(Icons.card_giftcard, color: const Color(0xFFD32F2F), size: 18.w),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF0F766E),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  'Jio',
                  style: TextStyle(
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w900,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Get FREE JioSaavn Pro for 30 days & enjoy ad-free music',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    if (!isUnlocked && !jioSaavnAdded)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          'Add items worth ₹${neededAmount.toInt()} more to unlock',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: const Color(0xFF2563EB),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    else if (jioSaavnAdded)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          'Claim voucher after order is placed',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: const Color(0xFF2563EB),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                children: [
                  GestureDetector(
                    onTap: isUnlocked
                        ? () {
                            setState(() {
                              jioSaavnAdded = !jioSaavnAdded;
                            });
                          }
                        : null,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: jioSaavnAdded ? const Color(0xFFE8F5E9) : AppColors.pureWhite,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: jioSaavnAdded
                              ? AppColors.primaryGreen
                              : (isUnlocked ? AppColors.textPrimary : AppColors.borderGrey),
                        ),
                      ),
                      child: jioSaavnAdded
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'ADDED',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primaryGreen,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Icon(Icons.close, color: AppColors.primaryGreen, size: 10.w),
                              ],
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!isUnlocked)
                                  Icon(Icons.lock_outline, color: AppColors.textTertiary, size: 11.w),
                                if (!isUnlocked) SizedBox(width: 4.w),
                                Text(
                                  'ADD',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w900,
                                    color: isUnlocked ? AppColors.textPrimary : AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '₹199 FREE',
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemsList() {
    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        children: [
          Column(
            children: List.generate(cartItems.length, (index) {
              final item = cartItems[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Row(
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
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            item.sizeInfo,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (item.subItems.isNotEmpty) ...
                            item.subItems.map((sub) => Padding(
                              padding: EdgeInsets.only(top: 4.h),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8.w,
                                    height: 8.w,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.green, width: 1),
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
                                    '${sub.name} × ${sub.quantity}',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '₹${(sub.price * sub.quantity).toInt()}',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: AppColors.textTertiary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          SizedBox(height: 6.h),
                          GestureDetector(
                            onTap: () async {
                              final result = await Navigator.pushNamed(
                                context,
                                '/food',
                                arguments: FoodPageArgs(
                                  id: item.id,
                                  name: item.name,
                                  price: item.price,
                                  imageUrl: item.imageUrl,
                                  rating: 4.3,
                                  isVeg: item.isVeg,
                                  initialQuantity: item.quantity,
                                  initialSubItems: item.subItems,
                                ),
                              ) as FoodPageResult?;
                              if (result != null) {
                                setState(() {
                                  item.quantity = result.quantity;
                                  item.subItems = result.subItems;
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryGreen,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Icon(Icons.arrow_right, color: AppColors.primaryGreen, size: 14.w),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primaryGreen),
                            borderRadius: BorderRadius.circular(8.r),
                            color: const Color(0xFFE8F5E9),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (item.quantity > 1) {
                                      item.quantity--;
                                    } else {
                                      cartItems.removeAt(index);
                                    }
                                  });
                                },
                                child: Icon(Icons.remove, color: AppColors.primaryGreen, size: 14.w),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                item.quantity.toString(),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    item.quantity++;
                                  });
                                },
                                child: Icon(Icons.add, color: AppColors.primaryGreen, size: 14.w),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          '₹${(item.price * item.quantity).toInt()}',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: [
                Icon(Icons.add_circle_outline, color: AppColors.primaryGreen, size: 18.w),
                SizedBox(width: 8.w),
                Text(
                  'Add more items',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalOptions() {
    final options = [
      {'label': 'Add a note for the restaurant', 'icon': Icons.description_outlined},
      {'label': "Don't send cutlery", 'icon': Icons.restaurant_menu_outlined},
      {'label': 'Avoid calling', 'icon': Icons.phone_android_outlined},
    ];

    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: options.map((opt) {
            return Container(
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.borderGrey),
              ),
              child: Row(
                children: [
                  Icon(opt['icon'] as IconData, size: 14.w, color: AppColors.textSecondary),
                  SizedBox(width: 6.w),
                  Text(
                    opt['label'] as String,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDiscountChip() {
    final double itemTotal = _calculateItemTotal();
    if (itemTotal >= 299) {
      return const SizedBox.shrink();
    }
    final double needed = 299 - itemTotal;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: const BoxDecoration(
              color: Color(0xFFE0F2FE),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.percent,
              color: const Color(0xFF0284C7),
              size: 14.w,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unlock FLAT ₹125 OFF',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Add items worth ₹${needed.toInt()} or more to unlock',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF0284C7),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsCarousel() {
    final double itemTotal = _calculateItemTotal();
    final String title = itemTotal >= 299 ? 'Want to add more items?' : 'You will love pairing it with';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(
          height: 140.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            itemCount: dummyPairingDishes.length,
            itemBuilder: (context, index) {
              final dish = dummyPairingDishes[index];
              return Container(
                width: 110.w,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.borderGrey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                          child: Image.network(
                            dish.imageUrl,
                            width: 110.w,
                            height: 70.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 6.w,
                          bottom: 6.h,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                final existingIndex = cartItems.indexWhere(
                                  (item) => item.name == dish.name,
                                );
                                if (existingIndex != -1) {
                                  cartItems[existingIndex].quantity++;
                                } else {
                                  cartItems.add(CartItem(
                                    id: dish.name.toLowerCase().replaceAll(' ', '_'),
                                    name: dish.name,
                                    price: dish.price,
                                    imageUrl: dish.imageUrl,
                                    sizeInfo: dish.sizeInfo,
                                    isVeg: dish.isVeg,
                                    quantity: 1,
                                    subItems: [],
                                  ));
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: const BoxDecoration(
                                color: Color(0xFFE8F5E9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.add, color: AppColors.primaryGreen, size: 14.w),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(6.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dish.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '₹${dish.price.toInt()}',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGoldBanner() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFFEF3C7)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.workspace_premium, color: AppColors.gold, size: 16.w),
                    SizedBox(width: 4.w),
                    Text(
                      goldApplied
                          ? 'Saved ₹42 with free delivery'
                          : 'Save ₹42 with free delivery',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  'Renew Gold at ₹1 for 3 months. Learn More ▶',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 90.w,
            height: 36.h,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  goldApplied = !goldApplied;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: goldApplied ? const Color(0xFFE8F5E9) : AppColors.pureWhite,
                elevation: 0,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  side: BorderSide(
                    color: AppColors.primaryGreen,
                    width: 1.w,
                  ),
                ),
              ),
              child: Text(
                goldApplied ? 'APPLIED' : 'APPLY',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZomatoMoney() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFF43F5E),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(Icons.wallet, color: AppColors.pureWhite, size: 14.w),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Zomato Money',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Single tap payments. Zero failures.',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 18.w),
        ],
      ),
    );
  }

  Widget _buildStickyFooter() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        border: Border(top: BorderSide(color: AppColors.borderGrey, width: 1.h)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _selectPaymentMethod,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'PAY USING',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textTertiary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Icon(Icons.arrow_drop_up, color: AppColors.textTertiary, size: 14.w),
                  ],
                ),
                Text(
                  selectedPaymentMethod.name,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 48.h,
              child: Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: ElevatedButton(
                  onPressed: () {
                    _showAddressBottomSheet();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹${grandTotal.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: AppColors.pureWhite,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'TOTAL',
                            style: TextStyle(
                              color: AppColors.pureWhite.withValues(alpha: 0.8),
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Place Order',
                            style: TextStyle(
                              color: AppColors.pureWhite,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(Icons.arrow_right, color: AppColors.pureWhite, size: 18.w),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectPaymentMethod() async {
    final result = await Navigator.pushNamed(context, '/payment') as PaymentMethod?;
    if (result != null) {
      setState(() {
        selectedPaymentMethod = result;
      });
    }
  }

  void _showAddressBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final double deviceHeight = MediaQuery.of(context).size.height;
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned(
                  top: deviceHeight * 0.18,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: CircleAvatar(
                        backgroundColor: AppColors.deepOnyx,
                        radius: 20.r,
                        child: Icon(Icons.close, color: AppColors.pureWhite, size: 20.w),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: deviceHeight * 0.72,
                  decoration: BoxDecoration(
                    color: AppColors.pureWhite,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Text(
                          'Select an address',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Container(height: 1.h, color: AppColors.borderGrey),
                      ListTile(
                        leading: Icon(Icons.add, color: AppColors.primaryGreen, size: 20.w),
                        title: Text(
                          'Add Address',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 18.w),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD54F),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'blinkit',
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        title: Text(
                          'Import addresses from Blinkit',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 18.w),
                        onTap: () {},
                      ),
                      Container(height: 8.h, color: AppColors.softGrey),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SAVED ADDRESSES',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textTertiary,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              _buildAddressSection(true, setModalState),
                              SizedBox(height: 24.h),
                              _buildAddressSection(false, setModalState),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildAddressSection(bool delivers, StateSetter setModalState) {
    final list = dummyAddresses.where((a) => a.deliversTo == delivers).toList();
    if (list.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          delivers ? 'DELIVERS TO' : 'DOES NOT DELIVER TO',
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w900,
            color: delivers ? const Color(0xFF2563EB) : const Color(0xFFEF4444),
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 12.h),
        Column(
          children: list.map((addr) {
            return GestureDetector(
              onTap: delivers
                  ? () {
                      setState(() {
                        activeAddress = addr;
                      });
                      Navigator.pop(context);
                    }
                  : null,
              child: Container(
                margin: EdgeInsets.only(bottom: 16.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.home_outlined,
                      color: delivers ? AppColors.textSecondary : AppColors.textTertiary,
                      size: 20.w,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                addr.title,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w800,
                                  color: delivers ? AppColors.textPrimary : AppColors.textTertiary,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                delivers ? '0 m' : '94 km',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            addr.fullAddress,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: delivers ? AppColors.textSecondary : AppColors.textTertiary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Phone number: ${addr.phoneNumber}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textTertiary,
                              fontWeight: FontWeight.w500,
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
                                child: Icon(Icons.more_horiz, size: 14.w, color: AppColors.textSecondary),
                              ),
                              SizedBox(width: 12.w),
                              Container(
                                padding: EdgeInsets.all(6.w),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.borderGrey),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.share_outlined, size: 14.w, color: AppColors.textSecondary),
                              ),
                              SizedBox(width: 12.w),
                              Container(
                                padding: EdgeInsets.all(6.w),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.borderGrey),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.camera_alt_outlined, size: 14.w, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
