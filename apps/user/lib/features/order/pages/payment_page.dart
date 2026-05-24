import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/core/color.dart';
import 'package:user/features/order/_data_dummy/cart_page.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double billTotal = (ModalRoute.of(context)?.settings.arguments as double?) ?? 375.99;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Column(
        children: [
          SizedBox(height: statusBarHeight),
          _buildAppBar(context, billTotal),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection('RECOMMENDED'),
                  _buildPaymentMethodsList(context, ['paytm', 'gpay', 'navi']),
                  _buildHeaderSection('CARDS'),
                  _buildCardOptions(),
                  _buildHeaderSection('PAY BY ANY UPI APP'),
                  _buildPaymentMethodsList(context, ['whatsapp']),
                  _buildHeaderSection('WALLETS'),
                  _buildWalletOptions(context),
                  _buildHeaderSection('PAY LATER'),
                  _buildPayLaterOptions(),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, double total) {
    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24.w),
          ),
          SizedBox(width: 16.w),
          Text(
            'Bill total: ₹${total.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 20.h, bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.textTertiary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsList(BuildContext context, List<String> ids) {
    final list = dummyPaymentMethods.where((m) => ids.contains(m.id)).toList();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        children: List.generate(list.length, (index) {
          final method = list[index];
          return Container(
            decoration: BoxDecoration(
              border: index < list.length - 1
                  ? Border(bottom: BorderSide(color: AppColors.borderGrey, width: 1.h))
                  : null,
            ),
            child: ListTile(
              leading: _buildMethodIcon(method.iconType),
              title: Text(
                method.name,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 18.w),
              onTap: () {
                Navigator.pop(context, method);
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCardOptions() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.credit_card, color: AppColors.textSecondary, size: 22.w),
            title: Text(
              'Add credit or debit cards',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            trailing: Icon(Icons.add, color: AppColors.primaryGreen, size: 18.w),
            onTap: () {},
          ),
          Container(height: 1.h, color: AppColors.borderGrey),
          ListTile(
            leading: Icon(Icons.badge, color: AppColors.textSecondary, size: 22.w),
            title: Text(
              'Add Pluxee',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            trailing: Icon(Icons.add, color: AppColors.primaryGreen, size: 18.w),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildWalletOptions(BuildContext context) {
    final list = dummyPaymentMethods.where((m) => ['amazon', 'mobikwik'].contains(m.id)).toList();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        children: List.generate(list.length, (index) {
          final method = list[index];
          return Container(
            decoration: BoxDecoration(
              border: index < list.length - 1
                  ? Border(bottom: BorderSide(color: AppColors.borderGrey, width: 1.h))
                  : null,
            ),
            child: ListTile(
              leading: _buildMethodIcon(method.iconType),
              title: Text(
                method.name,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              trailing: Icon(Icons.add, color: AppColors.primaryGreen, size: 18.w),
              onTap: () {
                Navigator.pop(context, method);
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPayLaterOptions() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: ListTile(
        leading: Icon(Icons.timer_outlined, color: AppColors.textSecondary, size: 22.w),
        title: Text(
          'Simple / LazyPay',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 18.w),
        onTap: () {},
      ),
    );
  }

  Widget _buildMethodIcon(String type) {
    Color bg = AppColors.softGrey;
    String label = '';
    Color txtColor = AppColors.textPrimary;

    switch (type) {
      case 'paytm':
        bg = const Color(0xFFE0F2FE);
        label = 'Paytm';
        txtColor = const Color(0xFF0369A1);
        break;
      case 'gpay':
        bg = const Color(0xFFFFF3CD);
        label = 'GPay';
        txtColor = const Color(0xFF856404);
        break;
      case 'navi':
        bg = const Color(0xFFF3E5F5);
        label = 'Navi';
        txtColor = const Color(0xFF7B1FA2);
        break;
      case 'whatsapp':
        bg = const Color(0xFFE8F5E9);
        label = 'WA';
        txtColor = const Color(0xFF2E7D32);
        break;
      case 'amazon':
        bg = const Color(0xFFFFECE0);
        label = 'APay';
        txtColor = const Color(0xFFD84315);
        break;
      case 'mobikwik':
        bg = const Color(0xFFE1F5FE);
        label = 'Mobi';
        txtColor = const Color(0xFF0277BD);
        break;
    }

    return Container(
      width: 40.w,
      height: 28.h,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6.r),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.w900,
          color: txtColor,
        ),
      ),
    );
  }
}
