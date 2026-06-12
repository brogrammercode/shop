import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/color.dart';
import '../../../core/di.dart';
import '../../../utils/error.dart';
import '../models/product_category.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';

class CreateCategoryPage extends StatefulWidget {
  final String branchId;
  final ProductCategoryModel? categoryToEdit;
  const CreateCategoryPage({super.key, required this.branchId, this.categoryToEdit});

  @override
  State<CreateCategoryPage> createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends State<CreateCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final List<XFile> _images = [];
  List<String> _existingImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    if (widget.categoryToEdit != null) {
      _nameController.text = widget.categoryToEdit!.name;
      _descController.text = widget.categoryToEdit!.description;
      _existingImages = List.from(widget.categoryToEdit!.images);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      List<String> uploadedUrls = [];
      if (_images.isNotEmpty) {
        setState(() => _isUploading = true);
        try {
          final paths = _images.map((f) => f.path).toList();
          final response = await AppDependencies.apiClient.uploadFiles('/upload/images', paths);
          final urls = response.data['data']['urls'] as List;
          uploadedUrls = urls.cast<String>();
        } catch (e) {
          setState(() => _isUploading = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
          }
          return;
        }
        setState(() => _isUploading = false);
      }

      if (mounted) {
        final allImages = [..._existingImages, ...uploadedUrls];
        if (widget.categoryToEdit != null) {
          context.read<ProductCubit>().updateCategory(widget.categoryToEdit!.id, {
            'name': _nameController.text.trim(),
            'description': _descController.text.trim(),
            'images': allImages,
          });
        } else {
          context.read<ProductCubit>().createCategory({
            'branch_id': widget.branchId,
            'name': _nameController.text.trim(),
            'description': _descController.text.trim(),
            'images': allImages,
          });
        }
      }
    }
  }

  Future<void> _pickImages() async {
    final List<XFile> picked = await _picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _images.addAll(picked);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
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
                          label: 'Category Name',
                          controller: _nameController,
                          hint: 'Enter category name',
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
            widget.categoryToEdit != null ? 'Update Category' : 'Add Category',
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

  void _removeExistingImage(int index) {
    setState(() {
      _existingImages.removeAt(index);
    });
  }

  Widget _buildImageSelector() {
    final totalCount = 1 + _existingImages.length + _images.length;
    return SizedBox(
      height: 100.w,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: totalCount,
        itemBuilder: (context, index) {
          if (index == 0) {
            return GestureDetector(
              onTap: _pickImages,
              child: Container(
                width: 100.w,
                height: 100.w,
                margin: EdgeInsets.only(right: 12.w),
                decoration: BoxDecoration(
                  color: AppColors.softGrey,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.borderGrey),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate, color: AppColors.textTertiary, size: 32.w),
                    SizedBox(height: 8.h),
                    Text('Add Image', style: TextStyle(color: AppColors.textTertiary, fontSize: 12.sp)),
                  ],
                ),
              ),
            );
          }

          if (index <= _existingImages.length) {
            final imgUrl = _existingImages[index - 1];
            return Container(
              width: 100.w,
              height: 100.w,
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                image: DecorationImage(
                  image: NetworkImage(imgUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 4.h,
                    right: 4.w,
                    child: GestureDetector(
                      onTap: () => _removeExistingImage(index - 1),
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                        child: Icon(Icons.close, color: AppColors.pureWhite, size: 16.w),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final imageFile = _images[index - 1 - _existingImages.length];
          return Container(
            width: 100.w,
            height: 100.w,
            margin: EdgeInsets.only(right: 12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              image: DecorationImage(
                image: FileImage(File(imageFile.path)),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 4.h,
                  right: 4.w,
                  child: GestureDetector(
                    onTap: () => _removeImage(index - 1 - _existingImages.length),
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, color: AppColors.pureWhite, size: 16.w),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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
        final isLoading = state.saveInfo.status == OperationStatus.loading || _isUploading;
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: ElevatedButton(
            onPressed: isLoading ? null : _saveCategory,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              minimumSize: Size(double.infinity, 50.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: isLoading
                ? SizedBox(height: 24.w, width: 24.w, child: const CircularProgressIndicator(color: AppColors.pureWhite, strokeWidth: 2))
                : Text(
                    widget.categoryToEdit != null ? 'Update Category' : 'Save Category',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.pureWhite),
                  ),
          ),
        );
      },
    );
  }
}