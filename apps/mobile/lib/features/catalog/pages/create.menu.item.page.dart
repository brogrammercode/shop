import 'package:mobile/features/catalog/models/menu_item.model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/components/ui/loader.dart';
import 'package:mobile/components/ui/bottom_action.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile/features/catalog/controllers/catalog.cubit.dart';
import 'package:mobile/features/catalog/controllers/catalog.state.dart';
import 'package:mobile/features/catalog/models/menu_category.model.dart';
import 'package:mobile/features/inventory/controllers/inventory.cubit.dart';
import 'package:mobile/features/inventory/controllers/inventory.state.dart';
import 'dart:io';

class CreateMenuItemPage extends StatefulWidget {
  const CreateMenuItemPage({super.key});

  @override
  State<CreateMenuItemPage> createState() => _CreateMenuItemPageState();
}

class _CreateMenuItemPageState extends State<CreateMenuItemPage> {
  final _displayNameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  String? _selectedCategoryId;
  String? _selectedItemId;
  String? _selectedVariantId;

  final List<String> _localImages = [];
  List<String> _remoteImages = [];
  
  final List<String> _localVideos = [];
  List<String> _remoteVideos = [];
  
  bool _isUploading = false;
  MenuItemModel? _itemToEdit;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      context.read<CatalogCubit>().listMenuCategories();
      context.read<InventoryCubit>().listItems();
      
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is MenuItemModel) {
        _itemToEdit = args;
        _displayNameCtrl.text = _itemToEdit!.display_name;
        _descCtrl.text = _itemToEdit!.description;
        _priceCtrl.text = _itemToEdit!.selling_price.toString();
        _remoteImages = List.from(_itemToEdit!.images);
        _remoteVideos = List.from(_itemToEdit!.videos);
        _selectedCategoryId = _itemToEdit!.category_id;
        _selectedVariantId = _itemToEdit!.variant_id;
        if (_itemToEdit!.item_id != null) {
          _selectedItemId = _itemToEdit!.item_id;
          context.read<InventoryCubit>().listVariants(_selectedItemId!);
        }
      } else if (args is MenuCategoryModel) {
        _selectedCategoryId = args.id;
      }
      _isInit = false;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (mounted) setState(() => _localImages.add(pickedFile.path));
    }
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (mounted) setState(() => _localVideos.add(pickedFile.path));
    }
  }

  void _onSave() async {
    if (_selectedCategoryId == null && _itemToEdit == null) {
      Fluttertoast.showToast(msg: 'Please select a category');
      return;
    }
    if (_itemToEdit == null && (_selectedItemId == null || _selectedVariantId == null)) {
      Fluttertoast.showToast(msg: 'Please select an inventory item and variant');
      return;
    }
    if (_displayNameCtrl.text.isEmpty || _priceCtrl.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill in display name and price');
      return;
    }

    final price = double.tryParse(_priceCtrl.text);
    if (price == null) {
      Fluttertoast.showToast(msg: 'Invalid price');
      return;
    }

    setState(() => _isUploading = true);
    List<String> uploadedImages = [];
    List<String> uploadedVideos = [];
    
    try {
      final inventoryCubit = context.read<InventoryCubit>();
      
      // Upload Images
      for (final path in _localImages) {
        final result = await inventoryCubit.uploadImage(path);
        if (result != null) uploadedImages.add(result);
      }
      
      // Upload Videos
      for (final path in _localVideos) {
        final result = await inventoryCubit.uploadImage(path);
        if (result != null) uploadedVideos.add(result);
      }

      final allImages = [..._remoteImages, ...uploadedImages];
      final allVideos = [..._remoteVideos, ...uploadedVideos];

      final data = {
        'display_name': _displayNameCtrl.text.trim(),
        'description': _descCtrl.text.trim(),
        'selling_price': price,
        'images': allImages,
        'videos': allVideos,
        'status': 'ACTIVE',
      };
      
      if (_selectedCategoryId != null) {
        data['category_id'] = _selectedCategoryId!;
      } else if (_itemToEdit != null) {
        data['category_id'] = _itemToEdit!.category_id;
      }
      
      if (_selectedVariantId != null) {
        data['variant_id'] = _selectedVariantId!;
      }

      final catId = data['category_id'] as String;

      if (!mounted) return;
      if (_itemToEdit != null) {
        await context.read<CatalogCubit>().updateMenuItem(_itemToEdit!.id, data, catId);
      } else {
        await context.read<CatalogCubit>().createMenuItem(data, catId);
      }

      setState(() => _isUploading = false);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => _isUploading = false);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  void dispose() {
    _displayNameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(
      builder: (context, catalogState) {
        final isSaving = catalogState.saveMenuItemsInfo.status == OperationStatus.loading;
        
        // Auto-select category if we are editing and haven't selected one yet
        if (_itemToEdit != null && _selectedCategoryId == null && catalogState.menuCategories.isNotEmpty) {
          try {
            _selectedCategoryId = catalogState.menuCategories.firstWhere((c) => c.id == _itemToEdit!.category_id).id;
          } catch (_) {}
        }

        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          body: SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: BlocBuilder<InventoryCubit, InventoryState>(
                    builder: (context, inventoryState) {
                      return SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CATEGORY SELECTION', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: AppColors.textTertiary, letterSpacing: 0.8)),
                            SizedBox(height: 12.h),
                            if (catalogState.loadMenuCategoriesInfo.status == OperationStatus.loading && catalogState.menuCategories.isEmpty)
                              const Center(child: AppLoader())
                            else
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                decoration: BoxDecoration(color: AppColors.pureWhite, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: AppColors.borderGrey)),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    hint: const Text('Select Menu Category'),
                                    value: _selectedCategoryId,
                                    items: catalogState.menuCategories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                                    onChanged: (catId) => setState(() => _selectedCategoryId = catId),
                                  ),
                                ),
                              ),
                            
                            SizedBox(height: 24.h),
                            Text('LINK INVENTORY (OPTIONAL IF EDITING)', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: AppColors.textTertiary, letterSpacing: 0.8)),
                            if (_itemToEdit != null && _selectedVariantId == null) ...[
                              SizedBox(height: 8.h),
                              Text('Currently linked to a variant. Select below ONLY if you wish to change the linkage.', style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
                            ],
                            SizedBox(height: 12.h),
                            if (inventoryState.loadItemsInfo.status == OperationStatus.loading && inventoryState.items.isEmpty)
                              const Center(child: AppLoader())
                            else
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                decoration: BoxDecoration(color: AppColors.pureWhite, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: AppColors.borderGrey)),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    hint: const Text('Select Inventory Item'),
                                    value: _selectedItemId,
                                    items: inventoryState.items.map((item) => DropdownMenuItem(value: item.id, child: Text(item.name))).toList(),
                                    onChanged: (itemId) {
                                      setState(() {
                                        _selectedItemId = itemId;
                                        _selectedVariantId = null;
                                        if (itemId != null) {
                                          final item = inventoryState.items.firstWhere((i) => i.id == itemId);
                                          if (_displayNameCtrl.text.isEmpty) _displayNameCtrl.text = item.name;
                                        }
                                      });
                                      if (itemId != null) context.read<InventoryCubit>().listVariants(itemId);
                                    },
                                  ),
                                ),
                              ),

                            if (_selectedItemId != null) ...[
                              SizedBox(height: 16.h),
                              if (inventoryState.loadVariantsInfo.status == OperationStatus.loading)
                                const Center(child: AppLoader())
                              else
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                                  decoration: BoxDecoration(color: AppColors.pureWhite, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: AppColors.borderGrey)),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      hint: const Text('Select Variant'),
                                      value: _selectedVariantId,
                                      items: inventoryState.variants.map((variant) => DropdownMenuItem(value: variant.id, child: Text((variant.name?.isNotEmpty ?? false) ? variant.name! : variant.sku))).toList(),
                                      onChanged: (variantId) {
                                        setState(() {
                                          _selectedVariantId = variantId;
                                          if (variantId != null) {
                                            final variant = inventoryState.variants.firstWhere((v) => v.id == variantId);
                                            if ((variant.name?.isNotEmpty ?? false) && _displayNameCtrl.text.isEmpty) {
                                              _displayNameCtrl.text = '\${item.name} - \${variant.name ?? ''}';
                                            }
                                            if (_priceCtrl.text.isEmpty) {
                                              _priceCtrl.text = (variant.base_cost * 1.5).toStringAsFixed(2);
                                            }
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                            ],

                            SizedBox(height: 32.h),
                            Text('MENU DETAILS', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: AppColors.textTertiary, letterSpacing: 0.8)),
                            SizedBox(height: 12.h),
                            AppInput(controller: _displayNameCtrl, hintText: 'Display Name on Menu'),
                            SizedBox(height: 16.h),
                            AppInput(controller: _descCtrl, hintText: 'Description (Optional)', maxLines: 3),
                            SizedBox(height: 16.h),
                            AppInput(controller: _priceCtrl, hintText: 'Selling Price', keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: Icon(Icons.currency_rupee, color: AppColors.textTertiary, size: 20.w)),
                            
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
                                      width: 64.w,
                                      height: 64.w,
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
                                      width: 64.w,
                                      height: 64.w,
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
                                    width: 64.w,
                                    height: 64.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.softGrey,
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(color: AppColors.borderGrey, style: BorderStyle.solid),
                                    ),
                                    child: Icon(Icons.add_a_photo, color: AppColors.textSecondary, size: 24.w),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 24.h),
                            Text('VIDEOS (OPTIONAL)', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: AppColors.textTertiary, letterSpacing: 0.8)),
                            SizedBox(height: 12.h),
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: [
                                ..._remoteVideos.map((url) => Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: 64.w,
                                      height: 64.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.deepOnyx,
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: Icon(Icons.play_circle, color: AppColors.pureWhite, size: 24.w),
                                    ),
                                    Positioned(
                                      top: -6.h,
                                      right: -6.w,
                                      child: GestureDetector(
                                        onTap: () => setState(() => _remoteVideos.remove(url)),
                                        child: Container(
                                          padding: EdgeInsets.all(2.w),
                                          decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                                          child: Icon(Icons.close, size: 12.w, color: AppColors.pureWhite),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                                ..._localVideos.map((path) => Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: 64.w,
                                      height: 64.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryGreen.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: Icon(Icons.movie, color: AppColors.primaryGreen, size: 24.w),
                                    ),
                                    Positioned(
                                      top: -6.h,
                                      right: -6.w,
                                      child: GestureDetector(
                                        onTap: () => setState(() => _localVideos.remove(path)),
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
                                  onTap: _pickVideo,
                                  child: Container(
                                    width: 64.w,
                                    height: 64.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.softGrey,
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(color: AppColors.borderGrey, style: BorderStyle.solid),
                                    ),
                                    child: Icon(Icons.video_call, color: AppColors.textSecondary, size: 28.w),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 32.h),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                AppBottomAction(
                  child: AppButton(text: _itemToEdit != null ? 'Update Item' : 'Add to Menu', onPressed: _onSave, isLoading: isSaving || _isUploading),
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
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
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
              child: Icon(Icons.chevron_left, color: AppColors.textPrimary, size: 20.w),
            ),
          ),
          SizedBox(width: 16.w),
          Text(
            _itemToEdit != null ? 'Edit Menu Item' : 'Add Menu Item',
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
