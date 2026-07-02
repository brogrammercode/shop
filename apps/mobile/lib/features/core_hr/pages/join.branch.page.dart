import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/features/core_hr/constants/branch.constant.dart';

class JoinBranchPage extends StatefulWidget {
  const JoinBranchPage({super.key});

  @override
  State<JoinBranchPage> createState() => _JoinBranchPageState();
}

class _JoinBranchPageState extends State<JoinBranchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    if (_searchController.text.trim().isEmpty) return;
    setState(() {
      _isSearching = true;
      _hasSearched = false;
    });
    // Dummy delay to simulate network
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _hasSearched = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                BranchConstant.SEARCH_BRANCH_HEADER,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: AppInput(
                      hintText: BranchConstant.ENTER_BRANCH_CODE,
                      controller: _searchController,
                      prefixIcon: Icon(Icons.search, color: AppColors.textTertiary),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  AppButton(
                    isFullWidth: false,
                    text: BranchConstant.SEARCH_ACTION,
                    isLoading: _isSearching,
                    onPressed: _onSearch,
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              if (_hasSearched)
                Expanded(
                  child: _buildDummyBranchCard(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDummyBranchCard() {
    // We simulate a branch found for testing navigations
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.pureWhite,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.borderGrey),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Zomato Head Office',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      'ACTIVE',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                'CODE: ZOM001',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textTertiary,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Icon(Icons.location_on, color: AppColors.primaryGreen, size: 16.w),
                  SizedBox(width: 4.w),
                  Text(
                    'Gurgaon, Haryana',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Spacer(),
        AppButton(
          text: BranchConstant.REQUEST_TO_JOIN,
          onPressed: () {
            // Navigate to home after requesting
            Navigator.pushNamed(context, '/home');
          },
        ),
      ],
    );
  }
}
