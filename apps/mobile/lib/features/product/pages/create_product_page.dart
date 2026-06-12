import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/color.dart';
import '../../../utils/error.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';

class CreateProductPage extends StatefulWidget {
  final String branchId;
  const CreateProductPage({super.key, required this.branchId});

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  
  String? _selectedCategoryId;
  String? _selectedSubCategoryId;
  bool _isVeg = false;
  bool _isAvailable = true;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      context.read<ProductCubit>().createProduct({
        'branch_id': widget.branchId,
        'name': _nameController.text.trim(),
        'description': _descController.text.trim(),
        'price': num.tryParse(_priceController.text) ?? 0,
        'stock': num.tryParse(_stockController.text) ?? 0,
        'category_id': _selectedCategoryId,
        'sub_category_id': _selectedSubCategoryId,
        'is_veg': _isVeg,
        'is_available': _isAvailable,
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
                          label: 'Product Name',
                          controller: _nameController,
                          hint: 'Enter product name',
                          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInputField(
                                label: 'Price',
                                controller: _priceController,
                                hint: '0.00',
                                keyboardType: TextInputType.number,
                                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: _buildInputField(
                                label: 'Stock',
                                controller: _stockController,
                                hint: '0',
                                keyboardType: TextInputType.number,
                                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        _buildCategoryDropdowns(),
                        SizedBox(height: 16.h),
                        _buildInputField(
                          label: 'Description',
                          controller: _descController,
                          hint: 'Enter description (optional)',
                          maxLines: 4,
                        ),
                        SizedBox(height: 16.h),
                        SwitchListTile(
                          title: Text('Is Vegetarian', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700)),
                          value: _isVeg,
                          activeColor: AppColors.primaryGreen,
                          onChanged: (val) => setState(() => _isVeg = val),
                          contentPadding: EdgeInsets.zero,
                        ),
                        SwitchListTile(
                          title: Text('Is Available', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700)),
                          value: _isAvailable,
                          activeColor: AppColors.primaryGreen,
                          onChanged: (val) => setState(() => _isAvailable = val),
                          contentPadding: EdgeInsets.zero,
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
            'Add Product',
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
    return Container(
      height: 100.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.softGrey,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.textTertiary.withOpacity(0.3), width: 1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate, color: AppColors.textTertiary, size: 32.w),
            SizedBox(height: 8.h),
            Text('Add Images', style: TextStyle(color: AppColors.textTertiary, fontSize: 12.sp)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
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
          keyboardType: keyboardType,
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

  Widget _buildCategoryDropdowns() {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
            ),
            SizedBox(height: 8.h),
            DropdownButtonFormField<String>(
              value: _selectedCategoryId,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.softGrey,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              ),
              items: state.categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedCategoryId = val;
                  _selectedSubCategoryId = null;
                });
              },
            ),
            if (_selectedCategoryId != null) ...[
              SizedBox(height: 16.h),
              Text(
                'Sub-Category',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
              ),
              SizedBox(height: 8.h),
              DropdownButtonFormField<String>(
                value: _selectedSubCategoryId,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.softGrey,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                ),
                items: state.subCategories
                    .where((s) => s.category_id == _selectedCategoryId)
                    .map((s) => DropdownMenuItem(value: s.id, child: Text(s.name)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedSubCategoryId = val),
              ),
            ]
          ],
        );
      },
    );
  }

  Widget _buildBottomButton() {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        final isLoading = state.saveInfo.status == OperationStatus.loading;
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: ElevatedButton(
            onPressed: isLoading ? null : _saveProduct,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              minimumSize: Size(double.infinity, 50.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: isLoading
                ? SizedBox(height: 24.w, width: 24.w, child: const CircularProgressIndicator(color: AppColors.pureWhite, strokeWidth: 2))
                : Text(
                    'Save Product',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.pureWhite),
                  ),
          ),
        );
      },
    );
  }
}