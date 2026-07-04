import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/catalog/constants/catalog.constant.dart';
import 'package:mobile/features/inventory/controllers/inventory.cubit.dart';
import 'package:mobile/features/inventory/controllers/inventory.state.dart';
import 'package:mobile/components/ui/app_refresher.dart';
import 'package:mobile/components/ui/loader.dart';
import 'package:mobile/utils/error.dart';

class UomListPage extends StatefulWidget {
  const UomListPage({super.key});

  @override
  State<UomListPage> createState() => _UomListPageState();
}

class _UomListPageState extends State<UomListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryCubit>().listUoms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPageTitle(),
            Expanded(
              child: BlocBuilder<InventoryCubit, InventoryState>(
                builder: (context, state) {
                  if (state.loadUomsInfo.status == OperationStatus.loading &&
                      state.uoms.isEmpty) {
                    return const Center(child: AppLoader());
                  }

                  if (state.loadUomsInfo.status == OperationStatus.error &&
                      state.uoms.isEmpty) {
                    return Center(
                      child: Text(
                        'Failed to load units of measure',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                        ),
                      ),
                    );
                  }

                  if (state.uoms.isEmpty) {
                    return Center(
                      child: Text(
                        'No units of measure found',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                        ),
                      ),
                    );
                  }

                  return AppRefresher(
                    onRefresh: () => context.read<InventoryCubit>().listUoms(),
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 16.h,
                      ),
                      itemCount: state.uoms.length,
                      separatorBuilder: (c, i) => SizedBox(height: 16.h),
                      itemBuilder: (context, index) {
                        final uom = state.uoms[index];
                        return GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/uom-detail', arguments: uom),
                          child: _buildUomCard(uom.code, uom.description),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 62.h),
        child: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/create-uom'),
          backgroundColor: AppColors.primaryGreen,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: AppColors.pureWhite),
        ),
      ),
    );
  }

  Widget _buildPageTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            CatalogConstant.UOM_LIST_TITLE,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            'Manage and organize your units of measure',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUomCard(String code, String desc) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderGrey, width: 1.w),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
            child: Text(
              code.length > 3 ? code.substring(0, 3) : code,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
                color: AppColors.primaryGreen,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Code: $code',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 20.w),
        ],
      ),
    );
  }
}
