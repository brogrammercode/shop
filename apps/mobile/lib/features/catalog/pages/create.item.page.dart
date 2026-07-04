import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/bottom_action.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/features/catalog/constants/catalog.constant.dart';
import 'package:mobile/features/inventory/controllers/inventory.cubit.dart';
import 'package:mobile/features/inventory/controllers/inventory.state.dart';
import 'package:mobile/features/inventory/models/item_category.model.dart';
import 'package:mobile/utils/error.dart';

class CreateItemPage extends StatefulWidget {
  const CreateItemPage({super.key});

  @override
  State<CreateItemPage> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _shelfLifeCtrl = TextEditingController();
  
  // Item type is hardcoded to RAW_MATERIAL for now, or we can make it selectable. Let's make it fixed or selectable.
  // The enum ItemType in prisma: RAW_MATERIAL, WORK_IN_PROGRESS, FINISHED_GOOD, CONSUMABLE, SERVICE.
  String _selectedItemType = 'RAW_MATERIAL';

  ItemCategoryModel? _selectedCategory;
  final List<String> _localImages = [];
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryCubit>().listItemCategories();
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _shelfLifeCtrl.dispose();
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
    if (_nameCtrl.text.isEmpty || _selectedCategory == null) return;
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
      context.read<InventoryCubit>().createItem({
        'name': _nameCtrl.text.trim(),
        'description': _descCtrl.text.trim(),
        'category_id': _selectedCategory!.id,
        'item_type': _selectedItemType,
        'shelf_life_days': int.tryParse(_shelfLifeCtrl.text.trim()),
        'images': uploadedUrls,
      });
    }
  }

  void _showCategorySelector(BuildContext context, List<ItemCategoryModel> categories) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.pureWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Category',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                SizedBox(height: 16.h),
                if (categories.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: Center(
                      child: Text('No categories found. Create one first.', style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary)),
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        return _buildCategoryCard(cat);
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard(ItemCategoryModel cat) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = cat;
        });
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          border: Border.all(color: AppColors.borderGrey, width: 1.w),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (cat.images.isNotEmpty)
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  image: DecorationImage(image: NetworkImage(cat.images.first), fit: BoxFit.cover),
                ),
              )
            else
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(color: AppColors.softGrey, borderRadius: BorderRadius.circular(8.r)),
                child: Icon(Icons.category, color: AppColors.textTertiary),
              ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cat.name,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                  if (cat.description != null && cat.description!.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      cat.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary, height: 1.3),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 18.w),
          ],
        ),
      ),
    );
  }

  void _showItemTypeSelector(BuildContext context) {
    final types = ['RAW_MATERIAL', 'SEMI_FINISHED', 'FINISHED_GOOD', 'ASSET', 'PACKAGING'];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.pureWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Item Type',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                SizedBox(height: 16.h),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: types.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final type = types[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedItemType = type;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                          decoration: BoxDecoration(
                            color: AppColors.pureWhite,
                            border: Border.all(color: AppColors.borderGrey, width: 1.w),
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: const [BoxShadow(color: AppColors.shadowColor, blurRadius: 4, offset: Offset(0, 2))],
                          ),
                          child: Text(
                            type.replaceAll('_', ' '),
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InventoryCubit, InventoryState>(
      listenWhen: (previous, current) => previous.saveItemsInfo.status != current.saveItemsInfo.status,
      listener: (context, state) {
        if (state.saveItemsInfo.status == OperationStatus.success) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final isLoading = state.saveItemsInfo.status == OperationStatus.loading;
        final categories = state.itemCategories;

        return Scaffold(
          backgroundColor: AppColors.pureWhite,
          appBar: AppBar(
            backgroundColor: AppColors.pureWhite,
            elevation: 0,
            scrolledUnderElevation: 0,
            iconTheme: const IconThemeData(color: AppColors.textPrimary),
            title: Text(CatalogConstant.CREATE_ITEM_TITLE, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
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
                        AppInput(controller: _nameCtrl, hintText: CatalogConstant.ITEM_NAME),
                        SizedBox(height: 16.h),
                        AppInput(controller: _descCtrl, hintText: 'Description'),
                        SizedBox(height: 16.h),
                        GestureDetector(
                          onTap: () => _showCategorySelector(context, categories),
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(border: Border.all(color: AppColors.borderGrey), borderRadius: BorderRadius.circular(10.r)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_selectedCategory?.name ?? 'Select Category', style: TextStyle(fontSize: 15.sp, color: _selectedCategory != null ? AppColors.textPrimary : AppColors.textSecondary, fontWeight: _selectedCategory != null ? FontWeight.w600 : FontWeight.w400)),
                                Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        GestureDetector(
                          onTap: () => _showItemTypeSelector(context),
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(border: Border.all(color: AppColors.borderGrey), borderRadius: BorderRadius.circular(10.r)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_selectedItemType.replaceAll('_', ' '), style: TextStyle(fontSize: 15.sp, color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                                Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        AppInput(controller: _shelfLifeCtrl, hintText: CatalogConstant.SHELF_LIFE, keyboardType: TextInputType.number),
                        SizedBox(height: 24.h),
                        Text('Item Images', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                        SizedBox(height: 12.h),
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
                        SizedBox(height: 120.h), // padding for bottom action
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: AppBottomAction(
            child: AppButton(
              text: CatalogConstant.SAVE_ITEM,
              onPressed: _onSave,
              isLoading: isLoading || _isUploading,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
