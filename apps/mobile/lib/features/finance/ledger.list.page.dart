import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/finance/constants/finance.constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/finance/finance.cubit.dart';
import 'package:mobile/features/finance/finance.state.dart';
import 'package:mobile/utils/error.dart';

class LedgerListPage extends StatefulWidget {
  const LedgerListPage({super.key});

  @override
  State<LedgerListPage> createState() => _LedgerListPageState();
}

class _LedgerListPageState extends State<LedgerListPage> {
  @override
  void initState() {
    super.initState();
    context.read<FinanceCubit>().listTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softGrey,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          _buildAppBar(context),
          Expanded(
            child: BlocBuilder<FinanceCubit, FinanceState>(
              builder: (context, state) {
                if (state.loadTransactionsInfo.status == OperationStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                final entries = state.transactions;
                if (entries.isEmpty) {
                  return Center(child: Text('No ledger entries found', style: TextStyle(color: AppColors.textSecondary)));
                }
                return ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: entries.length,
                  separatorBuilder: (_, i) => SizedBox(height: 12.h),
                  itemBuilder: (context, i) {
                    final e = entries[i];
                    final isCredit = e.credit > 0;
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/finance-ledger-form'),
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.pureWhite,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: const [BoxShadow(color: AppColors.shadowColor, blurRadius: 8, offset: Offset(0, 4))],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            color: isCredit ? const Color(0xFFE8F5E9) : const Color(0xFFFEF2F2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                              color: isCredit ? AppColors.primaryGreen : const Color(0xFFEF4444), size: 22.w),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.reference_id, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                              SizedBox(height: 4.h),
                              Text('${e.account_id} • ${e.created_at.split('T').first}', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              isCredit ? '+ ₹${e.credit}' : '- ₹${e.debit}',
                              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w900, color: isCredit ? AppColors.primaryGreen : const Color(0xFFEF4444)),
                            ),
                            SizedBox(height: 4.h),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(color: AppColors.softGrey, borderRadius: BorderRadius.circular(6.r)),
                              child: Text(e.reference_type, style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                            ),
                          ],
                        ),
                      ],
                    ),
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
        onPressed: () => Navigator.pushNamed(context, '/finance-ledger-form'),
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.add, color: AppColors.pureWhite),
        label: Text(FinanceConstant.BTN_ADD_ENTRY, style: TextStyle(color: AppColors.pureWhite, fontSize: 14.sp, fontWeight: FontWeight.w800)),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24.w)),
          SizedBox(width: 12.w),
          Expanded(child: Text(FinanceConstant.LEDGER_ENTRY_LIST_TITLE, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary))),
        ],
      ),
    );
  }
}
