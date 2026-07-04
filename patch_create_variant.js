const fs = require('fs');

let content = fs.readFileSync('apps/mobile/lib/features/catalog/pages/create.variant.page.dart', 'utf8');

// 1. Imports
content = content.replace("import 'package:mobile/utils/error.dart';", "import 'package:mobile/utils/error.dart';\nimport 'package:image_picker/image_picker.dart';\nimport 'dart:io';");

// 2. State variables
content = content.replace(
  "final TextEditingController _minStockCtrl = TextEditingController();",
  "final TextEditingController _minStockCtrl = TextEditingController();\n  final TextEditingController _nameCtrl = TextEditingController();\n  final List<String> _localImages = [];\n  bool _isUploading = false;"
);

// 3. Dispose
content = content.replace(
  "_minStockCtrl.dispose();",
  "_minStockCtrl.dispose();\n    _nameCtrl.dispose();"
);

// 4. _pickImage & _onSave
const saveMethodRegex = /void _onSave\(\) \{[\s\S]*?\}\n/;
const newMethods = `
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
`;
content = content.replace(saveMethodRegex, newMethods);

// 5. Build method: _isUploading
content = content.replace(
  "final isLoading = state.saveVariantsInfo.status == OperationStatus.loading;",
  "final isLoading = state.saveVariantsInfo.status == OperationStatus.loading;"
);

// 6. UI insertions
const uiTarget = `Text('Item: \${_item.name}', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),`;
const uiReplacement = `Text('Item: \${_item.name}', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
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
                                    ? Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryGreen))
                                    : Icon(Icons.add_photo_alternate, color: AppColors.textTertiary),
                              ),
                            ),
                          ],
                        ),`;
content = content.replace(uiTarget, uiReplacement);

// 7. Update loading indicator on the Save button
content = content.replace(
  "isLoading: isLoading,",
  "isLoading: isLoading || _isUploading,"
);

fs.writeFileSync('apps/mobile/lib/features/catalog/pages/create.variant.page.dart', content);
