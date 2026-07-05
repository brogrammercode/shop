import 'package:mobile/components/ui/loader.dart';
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
import 'package:mobile/features/inventory/models/item.model.dart';
import 'package:mobile/features/inventory/models/unit_of_measure.model.dart';
import 'package:mobile/utils/error.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateVariantPage extends StatefulWidget {
  const CreateVariantPage({super.key});

  @override
  State<CreateVariantPage> createState() => _CreateVariantPageState();
}

class _CreateVariantPageState extends State<CreateVariantPage> {
  final TextEditingController _baseCostCtrl = TextEditingController();
  final TextEditingController _minStockCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final List<String> _localImages = [];
  bool _isUploading = false;

  UnitOfMeasureModel? _selectedUom;
  late ItemModel _item;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _item = ModalRoute.of(context)!.settings.arguments as ItemModel;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<InventoryCubit>().listUoms();
      });
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _baseCostCtrl.dispose();
    _minStockCtrl.dispose();
    _nameCtrl.dispose();
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
    if (_selectedUom == null || _baseCostCtrl.text.isEmpty) return;
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
      context.read<InventoryCubit>().createVariant({
        'item_id': _item.id,
        'uom_id': _selectedUom!.id,
        'name': _nameCtrl.text.isNotEmpty ? _nameCtrl.text.trim() : null,
        'images': uploadedUrls,
        'base_cost': double.tryParse(_baseCostCtrl.text.trim()) ?? 0.0,
        'min_stock_lvl': double.tryParse(_minStockCtrl.text.trim()) ?? 0.0,
      });
    }
  }

  void _showUomSelector(BuildContext context, List<UnitOfMeasureModel> uoms) {
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
                  'Select Unit (UOM)',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                SizedBox(height: 16.h),
                if (uoms.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: Center(
                      child: Text('No units found. Create one first.', style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary)),
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: uoms.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final uom = uoms[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedUom = uom;
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(uom.description, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                                Text(uom.code, style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary)),
                              ],
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
      listenWhen: (previous, current) => previous.saveVariantsInfo.status != current.saveVariantsInfo.status,
      listener: (context, state) {
        if (state.saveVariantsInfo.status == OperationStatus.success) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final isLoading = state.saveVariantsInfo.status == OperationStatus.loading;
        final uoms = state.uoms;

        return Scaffold(
          backgroundColor: AppColors.pureWhite,
          appBar: AppBar(
            backgroundColor: AppColors.pureWhite,
            elevation: 0,
            scrolledUnderElevation: 0,
            iconTheme: const IconThemeData(color: AppColors.textPrimary),
            title: Text(CatalogConstant.CREATE_VARIANT_TITLE, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
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
                        Text('Item: ${_item.name}', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                        SizedBox(height: 24.h),
                        AppInput(
                          controller: _nameCtrl,
                          hintText: 'Variant Name (Optional)',
                        ),
                        SizedBox(height: 16.h),
                        Text('Images', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
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
                                        image: DecorationImage(image: FileImage(File(path)), fit: BoxFit.cover),
                                      ),
                                    ),
                                    Positioned(
                                      top: -4,
                                      right: -4,
                                      child: GestureDetector(
                                        onTap: () => setState(() => _localImages.remove(path)),
                                        child: Container(
                                          padding: EdgeInsets.all(4.r),
                                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
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
                                    ? Center(child: AppLoader())
                                    : Icon(Icons.add_photo_alternate, color: AppColors.textTertiary),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        GestureDetector(
                          onTap: () => _showUomSelector(context, uoms),
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(border: Border.all(color: AppColors.borderGrey), borderRadius: BorderRadius.circular(10.r)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_selectedUom?.description ?? 'Select Unit (e.g., KG)', style: TextStyle(fontSize: 15.sp, color: _selectedUom != null ? AppColors.textPrimary : AppColors.textSecondary, fontWeight: _selectedUom != null ? FontWeight.w600 : FontWeight.w400)),
                                Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: AppInput(
                                controller: _baseCostCtrl,
                                hintText: CatalogConstant.BASE_COST,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: AppInput(
                                controller: _minStockCtrl,
                                hintText: CatalogConstant.MIN_STOCK,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 120.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: AppBottomAction(
            child: AppButton(
              text: CatalogConstant.SAVE_VARIANT,
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
