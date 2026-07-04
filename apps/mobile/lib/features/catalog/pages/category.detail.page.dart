import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/core/color.dart';
import 'dart:io';
import 'package:mobile/utils/error.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/features/inventory/controllers/inventory.cubit.dart';
import 'package:mobile/features/inventory/controllers/inventory.state.dart';
import 'package:mobile/features/inventory/models/item_category.model.dart';

class CategoryDetailPage extends StatelessWidget {
  const CategoryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments as ItemCategoryModel;
    return _CategoryDetailView(category: category);
  }
}

class _CategoryDetailView extends StatefulWidget {
  final ItemCategoryModel category;
  const _CategoryDetailView({required this.category});

  @override
  State<_CategoryDetailView> createState() => _CategoryDetailViewState();
}

class _CategoryDetailViewState extends State<_CategoryDetailView> {
  void _openEditSheet(BuildContext context, ItemCategoryModel category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.pureWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => _EditCategorySheet(category: category),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      body: SafeArea(
        child: BlocBuilder<InventoryCubit, InventoryState>(
          builder: (context, state) {
            // Find updated category from state
            final updatedCategory = state.itemCategories.firstWhere(
              (e) => e.id == widget.category.id,
              orElse: () => widget.category,
            );

            // Find items that belong to this category
            final categoryItems = state.items.where((i) => i.category_id == updatedCategory.id).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(context, updatedCategory),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (updatedCategory.images.isNotEmpty)
                          Container(
                            width: double.infinity,
                            height: 200.h,
                            margin: EdgeInsets.only(bottom: 24.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              image: DecorationImage(
                                image: NetworkImage(updatedCategory.images.first),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        Text(
                          updatedCategory.name,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (updatedCategory.description != null && updatedCategory.description!.isNotEmpty) ...[
                          SizedBox(height: 8.h),
                          Text(
                            updatedCategory.description!,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                        SizedBox(height: 32.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ITEMS IN CATEGORY',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textTertiary,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                '${categoryItems.length}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        if (categoryItems.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(24.w),
                            decoration: BoxDecoration(
                              color: AppColors.softGrey,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              'No items linked to this category yet.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: categoryItems.length,
                            separatorBuilder: (_, __) => SizedBox(height: 12.h),
                            itemBuilder: (context, index) {
                              final item = categoryItems[index];
                              return Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.borderGrey),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ItemCategoryModel category) {
    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
              size: 24.w,
            ),
          ),
          GestureDetector(
            onTap: () => _openEditSheet(context, category),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.edit, size: 16.w, color: AppColors.primaryGreen),
                  SizedBox(width: 8.w),
                  Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditCategorySheet extends StatefulWidget {
  final ItemCategoryModel category;
  const _EditCategorySheet({required this.category});

  @override
  State<_EditCategorySheet> createState() => _EditCategorySheetState();
}

class _EditCategorySheetState extends State<_EditCategorySheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  List<String> _existingImages = [];
  final List<String> _localImages = [];
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.category.name);
    _descCtrl = TextEditingController(text: widget.category.description);
    _existingImages = List.from(widget.category.images);
  }

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

  void _onUpdate() async {
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
      context.read<InventoryCubit>().updateItemCategory(
        widget.category.id,
        {
          'name': _nameCtrl.text.trim(),
          'description': _descCtrl.text.trim(),
          'images': [..._existingImages, ...uploadedUrls],
        },
      );
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

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Category',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close, color: AppColors.textPrimary, size: 24.w),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
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
                  hintText: 'Enter category name',
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
                  hintText: 'Enter description',
                  maxLines: 3,
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
                    ..._existingImages.map((url) => Stack(
                          children: [
                            Container(
                              width: 80.r,
                              height: 80.r,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                image: DecorationImage(
                                  image: NetworkImage(url),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: -4,
                              right: -4,
                              child: GestureDetector(
                                onTap: () => setState(() => _existingImages.remove(url)),
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
                SizedBox(height: 32.h),
                AppButton(
                  text: 'Update Category',
                  onPressed: _onUpdate,
                  isLoading: isLoading || _isUploading,
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
