import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/features/inventory/constants/procurement.constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/inventory/inventory.cubit.dart';
import 'package:mobile/features/inventory/inventory.state.dart';
import 'package:mobile/utils/error.dart';

class GoodsReceiptFormPage extends StatefulWidget {
  const GoodsReceiptFormPage({super.key});

  @override
  State<GoodsReceiptFormPage> createState() => _GoodsReceiptFormPageState();
}

class _GoodsReceiptFormPageState extends State<GoodsReceiptFormPage> {
  final _invoiceController = TextEditingController();

  @override
  void dispose() {
    _invoiceController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    context.read<InventoryCubit>().receivePurchaseOrder('dummy-po-id', {
      'invoice_number': _invoiceController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InventoryCubit, InventoryState>(
      listenWhen: (previous, current) => previous.receiveInfo.status != current.receiveInfo.status,
      listener: (context, state) {
        if (state.receiveInfo.status == OperationStatus.success) {
          if (Navigator.canPop(context)) Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pureWhite,
          appBar: AppBar(
            backgroundColor: AppColors.pureWhite,
            elevation: 0,
            scrolledUnderElevation: 0,
            iconTheme: const IconThemeData(color: AppColors.textPrimary),
            title: Text(ProcurementConstant.GRN_TITLE, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('PO-2026-001', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                        SizedBox(height: 4.h),
                        Text('Fresh Farms Ltd.', style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary)),
                        SizedBox(height: 24.h),
                        AppInput(hintText: ProcurementConstant.INVOICE_NUMBER, controller: _invoiceController),
                        SizedBox(height: 32.h),
                        Text(ProcurementConstant.ITEMS_SECTION, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: AppColors.textTertiary, letterSpacing: 0.8)),
                        SizedBox(height: 12.h),
                        _buildReceiveItem('Tomatoes (Grade A)', '50 kg'),
                        _buildReceiveItem('Onions', '100 kg'),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.borderGrey, width: 1.h))),
                  child: AppButton(
                    text: ProcurementConstant.CONFIRM_RECEIPT,
                    isLoading: state.receiveInfo.status == OperationStatus.loading,
                    onPressed: _onConfirm,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReceiveItem(String name, String orderedQty) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(border: Border.all(color: AppColors.borderGrey), borderRadius: BorderRadius.circular(8.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Text('Ordered: $orderedQty', style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary)),
              ),
              SizedBox(
                width: 120.w,
                child: AppInput(hintText: 'Received', keyboardType: TextInputType.number),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
