import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/core/color.dart';
import 'dart:io';
import 'package:mobile/components/ui/bottom_action.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/features/catalog/constants/catalog.constant.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile/features/inventory/controllers/inventory.cubit.dart';
import 'package:mobile/features/inventory/controllers/inventory.state.dart';

class CreateCategoryPage extends StatefulWidget {
  const CreateCategoryPage({super.key});

  @override
  State<CreateCategoryPage> createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends State<CreateCategoryPage> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final List<String> _localImages = [];
  bool _isUploading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (mounted) {
        setState(() {
          _localImages.add(pickedFile.path);
        });
      }
    }
  }

  void _onSave() async {
    if (_nameCtrl.text.isEmpty) return;
    if (mounted) setState(() => _isUploading = true);
    
    List<String> uploadedUrls = [];
    for (String path in _localImages) {
      final url = await context.read<InventoryCubit>().uploadImage(path);
      if (url != null) {
        uploadedUrls.add(url);
      }
    }
    
    if (mounted) setState(() => _isUploading = false);
    
    if (mounted) {
      context.read<InventoryCubit>().createItemCategory({
        'name': _nameCtrl.text.trim(),
        'description': _descCtrl.text.trim(),
        'images': uploadedUrls,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InventoryCubit, InventoryState>(
      listenWhen: (prev, curr) => prev.saveItemCategoriesInfo != curr.saveItemCategoriesInfo,
      listener: (context, state) {
        if (state.saveItemCategoriesInfo.status == OperationStatus.success) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final isLoading = state.saveItemCategoriesInfo.status == OperationStatus.loading;

        return Scaffold(
          backgroundColor: AppColors.pureWhite,
          body: SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Category Name',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        AppInput(
                          controller: _nameCtrl,
                          hintText: CatalogConstant.CATEGORY_NAME,
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        AppInput(
                          controller: _descCtrl,
                          hintText: CatalogConstant.CATEGORY_DESC,
                          maxLines: 4,
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'Images',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Wrap(
                          spacing: 12.w,
                          runSpacing: 12.h,
                          children: [
                            ..._localImages.map((path) => Stack(
                                  children: [
                                    Container(
                                      width: 80.r,
                                      height: 80.r,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                        image: DecorationImage(
                                          image: FileImage(File(path)),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -4,
                                      right: -4,
                                      child: GestureDetector(
                                        onTap: () => setState(() => _localImages.remove(path)),
                                        child: Container(
                                          padding: EdgeInsets.all(4.r),
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.close, size: 12.r, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            GestureDetector(
                              onTap: _isUploading ? null : _pickImage,
                              child: Container(
                                width: 80.r,
                                height: 80.r,
                                decoration: BoxDecoration(
                                  color: AppColors.softGrey,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(color: AppColors.borderGrey),
                                ),
                                child: _isUploading
                                    ? Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryGreen))
                                    : Icon(Icons.add_photo_alternate, color: AppColors.textTertiary),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: AppBottomAction(
            child: AppButton(
              text: CatalogConstant.SAVE_CATEGORY,
              isLoading: isLoading,
              onPressed: _onSave,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
}
