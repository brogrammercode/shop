const fs = require('fs');

let content = fs.readFileSync('apps/mobile/lib/features/catalog/pages/item.detail.page.dart', 'utf8');

// 1. State variables
content = content.replace(
  "  late final TextEditingController _minStockCtrl;\n  late UnitOfMeasureModel? _selectedUom;",
  "  late final TextEditingController _minStockCtrl;\n  late final TextEditingController _nameCtrl;\n  late UnitOfMeasureModel? _selectedUom;\n  List<String> _existingImages = [];\n  final List<String> _localImages = [];\n  bool _isUploading = false;"
);

// 2. initState
content = content.replace(
  "    _minStockCtrl = TextEditingController(text: widget.variant.min_stock_lvl.toString());\n    _selectedUom = widget.uoms.where((u) => u.id == widget.variant.uom_id).firstOrNull;",
  "    _minStockCtrl = TextEditingController(text: widget.variant.min_stock_lvl.toString());\n    _nameCtrl = TextEditingController(text: widget.variant.name ?? '');\n    _selectedUom = widget.uoms.where((u) => u.id == widget.variant.uom_id).firstOrNull;\n    _existingImages = List.from(widget.variant.images);"
);

// 3. dispose
content = content.replace(
  "    _minStockCtrl.dispose();\n    super.dispose();",
  "    _minStockCtrl.dispose();\n    _nameCtrl.dispose();\n    super.dispose();"
);

// 4. _pickImage & _onUpdate
const updateMethodRegex = /void _onUpdate\(\) \{[\s\S]*?\}\n/;
const newUpdateMethod = `
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
    if (_selectedUom == null) return;
    if (mounted) setState(() => _isUploading = true);

    List<String> uploadedUrls = [];
    for (String path in _localImages) {
      final url = await context.read<InventoryCubit>().uploadImage(path);
      if (url != null) {
        uploadedUrls.add(url);
      }
    }

    if (mounted) setState(() => _isUploading = false);

    final finalImages = [..._existingImages, ...uploadedUrls];
    final baseCost = double.tryParse(_baseCostCtrl.text.trim()) ?? 0.0;
    final minStock = double.tryParse(_minStockCtrl.text.trim()) ?? 0.0;

    if (mounted) {
      context.read<InventoryCubit>().updateVariant(
        widget.variant.id,
        widget.item.id,
        {
          'uom_id': _selectedUom!.id,
          'name': _nameCtrl.text.isNotEmpty ? _nameCtrl.text.trim() : null,
          'images': finalImages,
          'base_cost': baseCost,
          'min_stock_lvl': minStock,
          'status': widget.variant.status,
        },
      );
    }
  }
`;
content = content.replace(updateMethodRegex, newUpdateMethod);

// 5. UI elements in EditVariantSheet
const uiTarget = `GestureDetector(
                  onTap: () => _showUomSelector(context),`;

const uiReplacement = `AppInput(
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
                    ..._existingImages.map((url) => Stack(
                          children: [
                            Container(
                              width: 80.r,
                              height: 80.r,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
                              ),
                            ),
                            Positioned(
                              top: -4,
                              right: -4,
                              child: GestureDetector(
                                onTap: () => setState(() => _existingImages.remove(url)),
                                child: Container(
                                  padding: EdgeInsets.all(4.r),
                                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
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
                ),
                SizedBox(height: 16.h),
                GestureDetector(
                  onTap: () => _showUomSelector(context),`;

content = content.replace(uiTarget, uiReplacement);

// 6. Update Button isLoading
content = content.replace(
  "isLoading: isLoading,",
  "isLoading: isLoading || _isUploading,"
);

// 7. Render Variant Name in the Variant List
const variantListTarget = `Text(variant.sku, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                                    SizedBox(height: 4.h),
                                    Text('Cost: ₹\${variant.base_cost}', style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary)),`;

const variantListReplacement = `Text(variant.name?.isNotEmpty == true ? variant.name! : variant.sku, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                                    SizedBox(height: 4.h),
                                    Text(variant.name?.isNotEmpty == true ? 'SKU: \${variant.sku} • Cost: ₹\${variant.base_cost}' : 'Cost: ₹\${variant.base_cost}', style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary)),`;

content = content.replace(variantListTarget, variantListReplacement);

// 8. Render Variant Image Thumbnail in the Variant List
const variantListRowTarget = `Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [`;
const variantListRowReplacement = `Row(
                                  children: [
                                    if (variant.images.isNotEmpty)
                                      Container(
                                        width: 48.w,
                                        height: 48.w,
                                        margin: EdgeInsets.only(right: 12.w),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.r),
                                          image: DecorationImage(image: NetworkImage(variant.images.first), fit: BoxFit.cover),
                                        ),
                                      ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [`;
content = content.replace(variantListRowTarget, variantListRowReplacement);

// Need to fix closing for Row we just opened
const variantListRowCloseTarget = `Icon(Icons.chevron_right, color: AppColors.textSecondary),
                              ],
                            ),`;
const variantListRowCloseReplacement = `  ],
                                    ),
                                Icon(Icons.chevron_right, color: AppColors.textSecondary),
                              ],
                            ),`;
content = content.replace(variantListRowCloseTarget, variantListRowCloseReplacement);

fs.writeFileSync('apps/mobile/lib/features/catalog/pages/item.detail.page.dart', content);
