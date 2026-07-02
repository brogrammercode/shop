import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/constants/country.constant.dart';
import 'package:mobile/features/core_hr/constants/hr.constant.dart';

class CountryPickerBottomSheet {
  static void show({
    required BuildContext context,
    required CountryModel selectedCountry,
    required ValueChanged<CountryModel> onCountrySelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4F4),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 12.h),
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCDCDC),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    HrConstant.SELECT_COUNTRY,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    itemCount: CountryConstant.COUNTRIES.length,
                    separatorBuilder: (_, _) => Container(
                      height: 1.h,
                      color: AppColors.borderGrey,
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                    ),
                    itemBuilder: (ctx, index) {
                      final country = CountryConstant.COUNTRIES[index];
                      final isSelected = country.dialCode == selectedCountry.dialCode &&
                          country.name == selectedCountry.name;
                      return InkWell(
                        onTap: () {
                          onCountrySelected(country);
                          Navigator.pop(ctx);
                        },
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFE8F5E9)
                                : AppColors.pureWhite,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Text(
                                country.flag,
                                style: TextStyle(fontSize: 22.sp),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  country.name,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              Text(
                                country.dialCode,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? AppColors.primaryGreen
                                      : AppColors.textSecondary,
                                ),
                              ),
                              if (isSelected) ...[
                                SizedBox(width: 8.w),
                                Icon(
                                  Icons.check_circle,
                                  color: AppColors.primaryGreen,
                                  size: 18.w,
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
