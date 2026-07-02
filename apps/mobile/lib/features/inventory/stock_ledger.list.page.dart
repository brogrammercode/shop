import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/features/manufacturing/constants/production.constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/inventory/inventory.cubit.dart';
import 'package:mobile/features/inventory/inventory.state.dart';
import 'package:mobile/utils/error.dart';

class StockLedgerListPage extends StatefulWidget {
  const StockLedgerListPage({super.key});

  @override
  State<StockLedgerListPage> createState() => _StockLedgerListPageState();
}

class _StockLedgerListPageState extends State<StockLedgerListPage> {
  @override
  void initState() {
    super.initState();
    context.read<InventoryCubit>().getStockLedger();
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
                    hintText: ProductionConstant.SEARCH_STOCK,
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
                _buildFilterChip('All Locations', true),
                _buildFilterChip('Main Store', false),
                _buildFilterChip('Kitchen', false),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<InventoryCubit, InventoryState>(
              builder: (context, state) {
                if (state.stockInfo.status == OperationStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                final ledger = state.stockLedger;
                if (ledger.isEmpty) {
                  return Center(child: Text('No stock movements found', style: TextStyle(color: AppColors.textSecondary)));
                }
                return ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: ledger.length,
                  separatorBuilder: (c, i) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final item = ledger[index];
                    final isPositive = item.quantity_change > 0;
                    return Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(border: Border.all(color: AppColors.borderGrey), borderRadius: BorderRadius.circular(12.r)),
                      child: Row(
                        children: [
                          CircleAvatar(backgroundColor: const Color(0xFFF3F4F6), child: Icon(Icons.inventory_2, color: AppColors.textSecondary)),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Variant: ${item.variant_id}', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                                SizedBox(height: 4.h),
                                Text(item.transaction_type, style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${isPositive ? '+' : ''}${item.quantity_change}', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w900, color: isPositive ? AppColors.primaryGreen : Colors.redAccent)),
                              Text('Bal: ${item.running_balance}', style: TextStyle(fontSize: 12.sp, color: AppColors.textTertiary)),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/create-stock-transfer'),
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.swap_horiz, color: AppColors.pureWhite),
        label: Text(ProductionConstant.TRANSFER_STOCK, style: TextStyle(color: AppColors.pureWhite, fontWeight: FontWeight.w800)),
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
      child: Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600, color: isSelected ? AppColors.pureWhite : AppColors.textPrimary)),
    );
  }
}
