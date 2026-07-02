import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/core_hr/constants/branch.constant.dart';
import 'package:mobile/features/core_hr/models/branch.model.dart';
import 'package:mobile/features/core_hr/models/address.model.dart';
import 'package:mobile/features/finance/bank_detail.model.dart';

class BranchDetailPage extends StatelessWidget {
  final BranchModel? branch;

  const BranchDetailPage({super.key, this.branch});

  @override
  Widget build(BuildContext context) {
    // Dummy data for UI visualization if not passed
    final displayBranch =
        branch ??
        BranchModel(
          id: '123',
          name: 'Zomato Head Office',
          code: 'ZOM001',
          is_hq: true,
          status: 'ACTIVE',
          created_at: '2026-06-28',
          updated_at: '2026-06-28',
          created_by: 'Admin',
          updated_by: 'Admin',
          is_deleted: false,
          franchise: 'Direct',
          addresses: [
            const AddressModel(
              id: 'addr1',
              entity_type: 'BRANCH',
              entity_id: '123',
              lat: 0.0,
              long: 0.0,
              area: 'DLF Phase 5',
              locality: 'Sector 43',
              city: 'Gurgaon',
              state: 'Haryana',
              country: 'India',
              pin_code: '122002',
              created_at: '',
              updated_at: '',
            ),
          ],
          bank_details: [
            const BankDetailModel(
              id: 'bank1',
              entity_type: 'BRANCH',
              entity_id: '123',
              bank_name: 'HDFC Bank',
              account_name: 'Zomato Ltd',
              account_number: '50100230000000',
              ifsc_code: 'HDFC0001234',
              swift_code: '',
              branch_name: 'DLF Cyber City',
              is_primary: true,
              created_at: '',
              updated_at: '',
            ),
          ],
        );

    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          BranchConstant.BRANCH_DETAIL_HEADER,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64.w,
                    height: 64.w,
                    decoration: BoxDecoration(
                      color: AppColors.softGrey,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.borderGrey),
                    ),
                    child: Icon(
                      Icons.storefront,
                      size: 32.w,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayBranch.name,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${BranchConstant.BRANCH_CODE_LABEL}: ${displayBranch.code}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // Badges Section
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  _buildBadge(
                    displayBranch.status,
                    displayBranch.status.toUpperCase() == 'ACTIVE'
                        ? AppColors.primaryGreen
                        : AppColors.textSecondary,
                  ),
                  if (displayBranch.is_hq) _buildBadge('HQ', AppColors.gold),
                  if (displayBranch.franchise.isNotEmpty)
                    _buildBadge(
                      displayBranch.franchise,
                      const Color(0xFF0075D4),
                    ),
                ],
              ),

              SizedBox(height: 32.h),
              _buildSectionHeader(BranchConstant.ADDRESS_SECTION),
              SizedBox(height: 12.h),
              if (displayBranch.addresses.isNotEmpty)
                ...displayBranch.addresses.map(
                  (addr) => _buildAddressCard(addr),
                )
              else
                _buildEmptyState(),

              SizedBox(height: 32.h),
              _buildSectionHeader(BranchConstant.BANK_SECTION),
              SizedBox(height: 12.h),
              if (displayBranch.bank_details.isNotEmpty)
                ...displayBranch.bank_details.map(
                  (bank) => _buildBankCard(bank),
                )
              else
                _buildEmptyState(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textTertiary,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildAddressCard(AddressModel address) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: AppColors.textSecondary,
                size: 18.w,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  '${address.area}, ${address.locality}',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.only(left: 26.w),
            child: Text(
              '${address.city}, ${address.state} - ${address.pin_code}\n${address.country}',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankCard(BankDetailModel bank) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_balance,
                    color: AppColors.textSecondary,
                    size: 18.w,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    bank.bank_name,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              if (bank.is_primary)
                _buildBadge(
                  BranchConstant.PRIMARY_BANK_LABEL,
                  const Color(0xFF0075D4),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.only(left: 26.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  BranchConstant.ACCOUNT_NAME_LABEL,
                  bank.account_name,
                ),
                SizedBox(height: 6.h),
                _buildInfoRow(
                  BranchConstant.ACCOUNT_NUMBER_LABEL,
                  bank.account_number,
                ),
                SizedBox(height: 6.h),
                _buildInfoRow(BranchConstant.IFSC_CODE_LABEL, bank.ifsc_code),
                if (bank.branch_name.isNotEmpty) ...[
                  SizedBox(height: 6.h),
                  _buildInfoRow(
                    BranchConstant.BANK_BRANCH_LABEL,
                    bank.branch_name,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textTertiary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Text(
        'No details added yet.',
        style: TextStyle(
          fontSize: 14.sp,
          fontStyle: FontStyle.italic,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}
