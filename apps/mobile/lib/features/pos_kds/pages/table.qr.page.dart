import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/pos_kds/models/table.model.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TableQrPage extends StatelessWidget {
  final TableModel table;

  const TableQrPage({super.key, required this.table});

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
          Text(
            'Table ${table.table_number} QR Codes',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(width: 40.w), // Balance for centering
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sides = table.side_labels;
    
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: sides.isEmpty
                  ? Center(
                      child: Text(
                        'No sides generated for this table.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.all(24.w),
                      itemCount: sides.length,
                      separatorBuilder: (context, index) => SizedBox(height: 32.h),
                      itemBuilder: (context, index) {
                        final side = sides[index];
                        // In a real app, this URL should point to your web app ordering page
                        // e.g. https://my-web-app.com/order?branch=123&table=456&side=A1
                        final qrData = 'https://web.app/order?b=${table.branch_id}&t=${table.id}&s=$side';
                        
                        return Container(
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: AppColors.pureWhite,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Side: $side',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: AppColors.pureWhite,
                                  border: Border.all(color: AppColors.borderGrey),
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: QrImageView(
                                  data: qrData,
                                  version: QrVersions.auto,
                                  size: 200.w,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'Scan to order',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
