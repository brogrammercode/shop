import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/features/inventory/constants/procurement.constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/inventory/inventory.cubit.dart';
import 'package:mobile/features/inventory/inventory.state.dart';
import 'package:mobile/features/inventory/supplier.model.dart';
import 'package:mobile/utils/error.dart';

class SupplierListPage extends StatefulWidget {
  const SupplierListPage({super.key});

  @override
  State<SupplierListPage> createState() => _SupplierListPageState();
}

class _SupplierListPageState extends State<SupplierListPage> {
  @override
  void initState() {
    super.initState();
    context.read<InventoryCubit>().listSuppliers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: const BoxDecoration(
                      color: AppColors.pureWhite,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 4, offset: Offset(0, 2))],
                    ),
                    child: Icon(Icons.chevron_left, color: AppColors.textPrimary, size: 24.w),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: AppInput(
                    hintText: ProcurementConstant.SEARCH_SUPPLIER,
                    prefixIcon: Icon(Icons.search, color: AppColors.textTertiary),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<InventoryCubit, InventoryState>(
              builder: (context, state) {
                if (state.loadSuppliersInfo.status == OperationStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                final suppliers = state.suppliers;
                if (suppliers.isEmpty) {
                  return Center(child: Text('No suppliers found', style: TextStyle(color: AppColors.textSecondary)));
                }
                return ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: suppliers.length,
                  separatorBuilder: (c, i) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) => _buildSupplierCard(context, suppliers[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/create-supplier'),
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.add, color: AppColors.pureWhite),
        label: Text(ProcurementConstant.ADD_SUPPLIER, style: TextStyle(color: AppColors.pureWhite, fontWeight: FontWeight.w800)),
      ),
    );
  }

  Widget _buildSupplierCard(BuildContext context, SupplierModel supplier) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/supplier-detail'),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.borderGrey),
          boxShadow: const [BoxShadow(color: AppColors.shadowColor, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundColor: const Color(0xFFE8F5E9),
              child: Icon(Icons.local_shipping, color: AppColors.primaryGreen, size: 24.w),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(supplier.name, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  SizedBox(height: 4.h),
                  Text(supplier.contact_phone, style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(6.r)),
              child: Text(ProcurementConstant.ACTIVE, style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w800, color: AppColors.primaryGreen)),
            ),
          ],
        ),
      ),
    );
  }
}
