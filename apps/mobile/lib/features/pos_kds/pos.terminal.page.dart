import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/features/pos_kds/constants/pos.constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/pos_kds/pos_kds.cubit.dart';
import 'package:mobile/features/pos_kds/pos_kds.state.dart';
import 'package:mobile/utils/error.dart';

class PosTerminalPage extends StatefulWidget {
  const PosTerminalPage({super.key});

  @override
  State<PosTerminalPage> createState() => _PosTerminalPageState();
}

class _PosTerminalPageState extends State<PosTerminalPage> {
  int _cartItems = 0;
  double _cartTotal = 0.0;

  void _addToCart(double price) {
    setState(() {
      _cartItems++;
      _cartTotal += price;
    });
  }

  void _showCartBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: AppColors.pureWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 12.h, bottom: 24.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.borderGrey,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Text(PosConstant.CART_TAB, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900)),
              SizedBox(height: 16.h),
              
              // Order Context
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.table_restaurant, color: AppColors.primaryGreen),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order: Table (Dine-in)', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                        Text('Table 2 - Chair 2', style: TextStyle(fontSize: 13.sp, color: AppColors.primaryGreen, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 24.h),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  children: [
                    _buildCartItem('2x Samosa', '\$4.00'),
                    _buildCartItem('1x Tea', '\$1.50'),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900)),
                        Text('\$${_cartTotal.toStringAsFixed(2)}', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900, color: AppColors.primaryGreen)),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            text: PosConstant.SEND_TO_KITCHEN,
                            backgroundColor: Colors.orange,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: BlocBuilder<PosKdsCubit, PosKdsState>(
                            builder: (context, state) {
                              return AppButton(
                                text: 'Pay',
                                backgroundColor: AppColors.primaryGreen,
                                isLoading: state.saveOrdersInfo.status == OperationStatus.loading,
                                onPressed: () {
                                  context.read<PosKdsCubit>().createOrder({
                                    'order_type': 'DINE_IN',
                                    'total_amount': _cartTotal,
                                    'items': [],
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildCartItem(String name, String price) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          Text(price, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalog = [
      {'name': 'Samosa', 'price': 2.0},
      {'name': 'Kaju Katli', 'price': 15.0},
      {'name': 'Rasgulla', 'price': 8.0},
      {'name': 'Masala Tea', 'price': 1.5},
      {'name': 'Coffee', 'price': 3.0},
      {'name': 'Lassi', 'price': 4.0},
    ];

    return BlocListener<PosKdsCubit, PosKdsState>(
      listenWhen: (previous, current) => previous.saveOrdersInfo.status != current.saveOrdersInfo.status,
      listener: (context, state) {
        if (state.saveOrdersInfo.status == OperationStatus.success) {
          if (Navigator.canPop(context)) Navigator.pop(context); // Close bottom sheet
          setState(() {
            _cartItems = 0;
            _cartTotal = 0.0;
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.softGrey,
        appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Column(
          children: [
            Text(PosConstant.POS_TITLE, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
            Text('Table 2 - Chair 2', style: TextStyle(fontSize: 12.sp, color: AppColors.primaryGreen, fontWeight: FontWeight.w800)),
          ],
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GridView.builder(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 0.85,
            ),
            itemCount: catalog.length,
            itemBuilder: (context, index) {
              final item = catalog[index];
              return InkWell(
                onTap: () => _addToCart(item['price'] as double),
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.pureWhite,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(color: const Color(0xFFF3F4F6), shape: BoxShape.circle),
                        child: Icon(Icons.fastfood, color: AppColors.primaryGreen, size: 32.w),
                      ),
                      SizedBox(height: 16.h),
                      Text(item['name'] as String, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900)),
                      SizedBox(height: 4.h),
                      Text('\$${(item['price'] as double).toStringAsFixed(2)}', style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Floating Bottom Cart Bar
          if (_cartItems > 0)
            Positioned(
              bottom: 24.h,
              left: 16.w,
              right: 16.w,
              child: GestureDetector(
                onTap: _showCartBottomSheet,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(32.r),
                    boxShadow: const [BoxShadow(color: Color(0x664CAF50), blurRadius: 16, offset: Offset(0, 8))],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                            child: Text('$_cartItems', style: TextStyle(color: AppColors.pureWhite, fontWeight: FontWeight.w900)),
                          ),
                          SizedBox(width: 12.w),
                          Text('View Order', style: TextStyle(color: AppColors.pureWhite, fontSize: 16.sp, fontWeight: FontWeight.w800)),
                        ],
                      ),
                      Text('\$${_cartTotal.toStringAsFixed(2)}', style: TextStyle(color: AppColors.pureWhite, fontSize: 18.sp, fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      ),
    );
  }
}
