import 'package:mobile/features/catalog/models/menu_category.model.dart';
import 'dart:io';

import 'package:mobile/features/inventory/controllers/inventory.cubit.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/components/ui/bottom_action.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile/features/catalog/controllers/catalog.cubit.dart';
import 'package:mobile/features/catalog/controllers/catalog.state.dart';

class CreateMenuCategoryPage extends StatefulWidget {
  const CreateMenuCategoryPage({super.key});

  @override
  State<CreateMenuCategoryPage> createState() => _CreateMenuCategoryPageState();
}

class _CreateMenuCategoryPageState extends State<CreateMenuCategoryPage> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final List<String> _localImages = [];
  List<String> _remoteImages = [];
  bool _isUploading = false;
  final _displayOrderCtrl = TextEditingController(text: '0');

  MenuCategoryModel? _categoryToEdit;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is MenuCategoryModel) {
        _categoryToEdit = args;
        _nameCtrl.text = _categoryToEdit!.name;
        _descCtrl.text = _categoryToEdit!.description;
        _displayOrderCtrl.text = _categoryToEdit!.display_order.toString();
        _remoteImages = List.from(_categoryToEdit!.images);
        // Ignoring existing remote images for UI simplicity here, just append new ones
      }
      _isInit = false;
    }
  }


  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _displayOrderCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (mounted) setState(() => _localImages.add(pickedFile.path));
    }
  }

  void _onSave() async {
    if (_nameCtrl.text.trim().isEmpty) return;
    
    final displayOrder = int.tryParse(_displayOrderCtrl.text.trim()) ?? 0;

    if (mounted) setState(() => _isUploading = true);
    List<String> uploadedUrls = [];
    final inventoryCubit = context.read<InventoryCubit>();
    for (String path in _localImages) {
      final url = await inventoryCubit.uploadImage(path);
      if (url != null) uploadedUrls.add(url);
    }
    if (mounted) setState(() => _isUploading = false);
      
    
    if (mounted) {
      final payload = {
        'images': uploadedUrls,
        'name': _nameCtrl.text.trim(),
        'description': _descCtrl.text.trim(),
        'display_order': displayOrder,
        'status': _categoryToEdit?.status ?? 'ACTIVE',
      };
      if (_categoryToEdit != null) {
        if (uploadedUrls.isEmpty && _categoryToEdit!.images.isNotEmpty) {
           payload['images'] = _categoryToEdit!.images;
        }
        context.read<CatalogCubit>().updateMenuCategory(_categoryToEdit!.id, payload);
      } else {
        context.read<CatalogCubit>().createMenuCategory(payload);
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CatalogCubit, CatalogState>(
      listenWhen: (prev, curr) => prev.saveMenuCategoriesInfo.status != curr.saveMenuCategoriesInfo.status,
      listener: (context, state) {
        if (state.saveMenuCategoriesInfo.status == OperationStatus.success) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final isLoading = state.saveMenuCategoriesInfo.status == OperationStatus.loading;

        return Scaffold(
          backgroundColor: AppColors.pureWhite,
          body: SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('BASIC DETAILS', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: AppColors.textTertiary, letterSpacing: 0.8)),
                        SizedBox(height: 12.h),
                        AppInput(controller: _nameCtrl, hintText: 'Category Name'),
                        SizedBox(height: 16.h),
                        AppInput(controller: _descCtrl, hintText: 'Description (Optional)', maxLines: 3),
                        SizedBox(height: 16.h),
                        AppInput(controller: _displayOrderCtrl, hintText: 'Display Order', keyboardType: TextInputType.number),
                        
                        SizedBox(height: 24.h),
                        Text('IMAGES', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: AppColors.textTertiary, letterSpacing: 0.8)),
                        SizedBox(height: 12.h),
                        Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: [
                                ..._remoteImages.map((url) => Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: 56.w,
                                      height: 56.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12.r),
                                        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
                                      ),
                                    ),
                                    Positioned(
                                      top: -6.h,
                                      right: -6.w,
                                      child: GestureDetector(
                                        onTap: () => setState(() => _remoteImages.remove(url)),
                                        child: Container(
                                          padding: EdgeInsets.all(2.w),
                                          decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                                          child: Icon(Icons.close, size: 12.w, color: AppColors.pureWhite),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                                ..._localImages.map((path) => Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: 56.w,
                                      height: 56.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12.r),
                                        image: DecorationImage(image: FileImage(File(path)), fit: BoxFit.cover),
                                      ),
                                    ),
                                    Positioned(
                                      top: -6.h,
                                      right: -6.w,
                                      child: GestureDetector(
                                        onTap: () => setState(() => _localImages.remove(path)),
                                        child: Container(
                                          padding: EdgeInsets.all(2.w),
                                          decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                                          child: Icon(Icons.close, size: 12.w, color: AppColors.pureWhite),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                                GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    width: 56.w,
                                    height: 56.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.softGrey,
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(color: AppColors.borderGrey, style: BorderStyle.solid),
                                    ),
                                    child: Icon(Icons.add_a_photo, color: AppColors.textSecondary, size: 20.w),
                                  ),
                                ),
                              ],
                        ),
                      ],
                    ),
                  ),
                ),
                AppBottomAction(
                  child: AppButton(text: _categoryToEdit != null ? 'Update Category' : 'Create Category', onPressed: _onSave, isLoading: isLoading || _isUploading),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: AppColors.pureWhite,
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
                boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 4, offset: Offset(0, 2))],
              ),
              child: Icon(Icons.chevron_left, color: AppColors.textPrimary, size: 24.w),
            ),
          ),
          SizedBox(width: 16.w),
          Text(
            _categoryToEdit != null ? 'Edit Menu Category' : 'Create Menu Category',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
