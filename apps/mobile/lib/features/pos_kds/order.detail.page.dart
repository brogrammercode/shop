import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/features/pos_kds/constants/pos.constant.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(PosConstant.orderDetailTitle, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text('RECEIPT', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
            ),
            SizedBox(height: 16.h),
            Text('Order: ORD-001', style: TextStyle(fontSize: 14.sp)),
            Text('Type: Table (Chair 2)', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('2x Samosa', style: TextStyle(fontSize: 14.sp)),
                Text('\$4.00', style: TextStyle(fontSize: 14.sp)),
              ],
            ),
            Divider(color: AppColors.borderGrey, height: 32.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Paid', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900)),
                Text('\$4.00', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: AppColors.primaryGreen)),
              ],
            ),
            Spacer(),
            AppButton(text: PosConstant.printBill, onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
