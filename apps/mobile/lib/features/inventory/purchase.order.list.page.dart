import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/features/inventory/constants/procurement.constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/inventory/inventory.cubit.dart';
import 'package:mobile/features/inventory/inventory.state.dart';
import 'package:mobile/features/inventory/purchase_order.model.dart';
import 'package:mobile/utils/error.dart';

class PurchaseOrderListPage extends StatefulWidget {
  const PurchaseOrderListPage({super.key});

  @override
  State<PurchaseOrderListPage> createState() => _PurchaseOrderListPageState();
}

class _PurchaseOrderListPageState extends State<PurchaseOrderListPage> {
  @override
  void initState() {
    super.initState();
    context.read<InventoryCubit>().listPurchaseOrders();
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
                    hintText: ProcurementConstant.SEARCH_PO,
                    prefixIcon: Icon(Icons.search, color: AppColors.textTertiary),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                _buildFilterChip('All', true),
                _buildFilterChip('Pending', false),
                _buildFilterChip('Approved', false),
                _buildFilterChip('Completed', false),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<InventoryCubit, InventoryState>(
              builder: (context, state) {
                if (state.loadPOInfo.status == OperationStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                final pos = state.purchaseOrders;
                if (pos.isEmpty) {
                  return Center(child: Text('No purchase orders found', style: TextStyle(color: AppColors.textSecondary)));
                }
                return ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: pos.length,
                  separatorBuilder: (c, i) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) => _buildPOCard(context, pos[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/create-po'),
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.add, color: AppColors.pureWhite),
        label: Text(ProcurementConstant.CREATE_PO, style: TextStyle(color: AppColors.pureWhite, fontWeight: FontWeight.w800)),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryGreen : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: isSelected ? AppColors.primaryGreen : AppColors.borderGrey),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          color: isSelected ? AppColors.pureWhite : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildPOCard(BuildContext context, PurchaseOrderModel po) {
    Color statusColor;
    switch (po.status) {
      case 'PENDING':
        statusColor = const Color(0xFFF59E0B);
        break;
      case 'RECEIVED':
      case 'COMPLETED':
        statusColor = AppColors.primaryGreen;
        break;
      case 'SENT':
        statusColor = const Color(0xFF3B82F6);
        break;
      default:
        statusColor = AppColors.textSecondary;
    }
    
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/po-detail'),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.borderGrey),
          boxShadow: const [BoxShadow(color: AppColors.shadowColor, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(po.id, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6.r)),
                  child: Text(po.status, style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w800, color: statusColor)),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text('Supplier: ${po.supplier_id}', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(po.created_at.split('T').first, style: TextStyle(fontSize: 12.sp, color: AppColors.textTertiary)),
                Text('₹${po.total_amount}', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
