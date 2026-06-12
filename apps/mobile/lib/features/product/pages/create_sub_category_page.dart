import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/color.dart';
import '../../../utils/error.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';

class CreateSubCategoryPage extends StatefulWidget {
  final String categoryId;
  const CreateSubCategoryPage({super.key, required this.categoryId});

  @override
  State<CreateSubCategoryPage> createState() => _CreateSubCategoryPageState();
}

class _CreateSubCategoryPageState extends State<CreateSubCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _saveSubCategory() {
    if (_formKey.currentState!.validate()) {
      context.read<ProductCubit>().createSubCategory({
        'category_id': widget.categoryId,
        'name': _nameController.text.trim(),
        'description': _descController.text.trim(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductCubit, ProductState>(
      listenWhen: (previous, current) => previous.saveInfo != current.saveInfo,
      listener: (context, state) {
        if (state.saveInfo.status == OperationStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Success')),
          );
          Navigator.pop(context);
        } else if (state.saveInfo.status == OperationStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.saveInfo.error?.message ?? 'Failed')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.pureWhite,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImageSelector(),
                        SizedBox(height: 24.h),
                        _buildInputField(
                          label: 'Sub-Category Name',
                          controller: _nameController,
                          hint: 'Enter sub-category name',
                          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                        ),
                        SizedBox(height: 16.h),
                        _buildInputField(
                          label: 'Description',
                          controller: _descController,
                          hint: 'Enter description (optional)',
                          maxLines: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _buildBottomButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(
                color: AppColors.pureWhite,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: AppColors.shadowColor, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: Icon(Icons.chevron_left, color: AppColors.textPrimary, size: 24.w),
            ),
          ),
          SizedBox(width: 16.w),
          Text(
            'Add Sub-Category',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSelector() {
    return Center(
      child: Container(
        width: 100.w,
        height: 100.w,
        decoration: BoxDecoration(
          color: AppColors.softGrey,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.textTertiary.withOpacity(0.3), width: 1),
        ),
        child: Icon(Icons.add_a_photo, color: AppColors.textTertiary, size: 32.w),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.textTertiary, fontSize: 14.sp),
            filled: true,
            fillColor: AppColors.softGrey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        final isLoading = state.saveInfo.status == OperationStatus.loading;
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: ElevatedButton(
            onPressed: isLoading ? null : _saveSubCategory,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              minimumSize: Size(double.infinity, 50.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: isLoading
                ? SizedBox(height: 24.w, width: 24.w, child: const CircularProgressIndicator(color: AppColors.pureWhite, strokeWidth: 2))
                : Text(
                    'Save Sub-Category',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.pureWhite),
                  ),
          ),
        );
      },
    );
  }
}
