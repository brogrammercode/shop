import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/pos_kds/constants/pos.constant.dart';

class KdsTerminalPage extends StatelessWidget {
  const KdsTerminalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFF121212), // High contrast dark mode for kitchen
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E1E1E),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(PosConstant.kdsTitle, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: Colors.white)),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: AppColors.primaryGreen,
            indicatorWeight: 4,
            labelColor: AppColors.primaryGreen,
            unselectedLabelColor: Colors.white54,
            labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900),
            tabs: const [
              Tab(text: 'NEW (2)'),
              Tab(text: 'PREPARING (1)'),
              Tab(text: 'READY (0)'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // NEW TAB
            ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                _buildModernKotCard('Table 2 (Chair 1)', 'Ordered 2 mins ago', ['2x Samosa', '1x Tea (No Sugar)'], Colors.redAccent, 'Start Preparing'),
                _buildModernKotCard('Online (Swiggy)', 'Ordered 5 mins ago', ['1KG Kaju Katli', '500g Rasgulla'], Colors.blueAccent, 'Start Preparing'),
              ],
            ),
            // PREPARING TAB
            ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                _buildModernKotCard('Takeaway', 'Preparing for 10 mins', ['5x Masala Tea', '10x Samosa'], Colors.orangeAccent, 'Mark Ready'),
              ],
            ),
            // READY TAB
            Center(
              child: Text('No orders waiting for pickup.', style: TextStyle(color: Colors.white54, fontSize: 16.sp, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernKotCard(String orderContext, String timeStr, List<String> items, Color accentColor, String actionText) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              border: Border(bottom: BorderSide(color: accentColor.withOpacity(0.3))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(orderContext, style: TextStyle(color: accentColor, fontSize: 18.sp, fontWeight: FontWeight.w900)),
                Row(
                  children: [
                    Icon(Icons.timer, color: Colors.white54, size: 16.w),
                    SizedBox(width: 4.w),
                    Text(timeStr, style: TextStyle(color: Colors.white54, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          // Items
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((e) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('•', style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w900)),
                    SizedBox(width: 12.w),
                    Expanded(child: Text(e, style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w800))),
                  ],
                ),
              )).toList(),
            ),
          ),
          // Action Button
          Padding(
            padding: EdgeInsets.all(16.w),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text(actionText, style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w900)),
            ),
          )
        ],
      ),
    );
  }
}
