import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/bottom_action.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/features/catalog/constants/catalog.constant.dart';
import 'package:mobile/features/inventory/controllers/inventory.cubit.dart';
import 'package:mobile/features/inventory/controllers/inventory.state.dart';
import 'package:mobile/utils/error.dart';

class CreateUomPage extends StatefulWidget {
  const CreateUomPage({super.key});

  @override
  State<CreateUomPage> createState() => _CreateUomPageState();
}

class _CreateUomPageState extends State<CreateUomPage> {
  final TextEditingController _codeCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();

  @override
  void dispose() {
    _codeCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_codeCtrl.text.trim().isEmpty) return;
    context.read<InventoryCubit>().createUom({
      'code': _codeCtrl.text.trim(),
      'description': _descCtrl.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InventoryCubit, InventoryState>(
      listenWhen: (prev, curr) => prev.saveUomsInfo != curr.saveUomsInfo,
      listener: (context, state) {
        if (state.saveUomsInfo.status == OperationStatus.success) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final isLoading = state.saveUomsInfo.status == OperationStatus.loading;

        return Scaffold(
          backgroundColor: AppColors.pureWhite,
          floatingActionButton: AppBottomAction(
            child: AppButton(
              text: CatalogConstant.SAVE_UOM,
              isLoading: isLoading,
              onPressed: _onSave,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(context),
                _buildPageTitle(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppInput(
                          controller: _codeCtrl,
                          hintText: CatalogConstant.UOM_CODE,
                        ),
                        SizedBox(height: 16.h),
                        AppInput(
                          controller: _descCtrl,
                          hintText: CatalogConstant.UOM_DESC,
                        ),
                        SizedBox(height: 100.h), // space for bottom action
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Icon(
          Icons.arrow_back,
          color: AppColors.textPrimary,
          size: 24.w,
        ),
      ),
    );
  }

  Widget _buildPageTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            CatalogConstant.CREATE_UOM_TITLE,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add a new unit of measure to your catalog',
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
}
