import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/color.dart';
import '../../../core/di.dart';
import '../../../utils/error.dart';
import '../../../components/ui/button.dart';
import '../../../components/ui/input.dart';

import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';
import '../constants/product.constant.dart';

class CreateProductPage extends StatefulWidget {
  final String branchId;
  final dynamic productToEdit;
  final bool isSubProduct;
  final String? parentProductId;
  final List<String>? parentProductLinkedIds;

  const CreateProductPage({
    super.key, 
    required this.branchId, 
    this.productToEdit,
    this.isSubProduct = false,
    this.parentProductId,
    this.parentProductLinkedIds,
  });

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _unitController = TextEditingController(text: 'pc');
  final _stockController = TextEditingController();
  
  String? _selectedCategoryId;
  String? _selectedSubCategoryId;
  bool _isVeg = false;
  bool _isAvailable = true;

  final List<XFile> _images = [];
  List<String> _existingImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    if (widget.productToEdit != null) {
      final p = widget.productToEdit;
      _nameController.text = p.name;
      _descController.text = p.description;
      _priceController.text = p.price.toString();
      _unitController.text = p.unit;
      _stockController.text = p.stock.toString();
      _selectedCategoryId = p.category_id.isNotEmpty ? p.category_id : null;
      _selectedSubCategoryId = p.sub_category_id.isNotEmpty ? p.sub_category_id : null;
      _isVeg = p.is_veg;
      _isAvailable = p.is_available;
      _existingImages = List.from(p.images);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _unitController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
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
        final payload = {
          'name': _nameController.text.trim(),
          'description': _descController.text.trim(),
          'price': double.parse(_priceController.text),
          'unit': _unitController.text.trim(),
          'stock': int.parse(_stockController.text),
          'category_id': _selectedCategoryId,
          'sub_category_id': _selectedSubCategoryId,
          'is_veg': _isVeg,
          'is_available': _isAvailable,
          'images': allImages,
        };

        if (widget.isSubProduct) {
          if (widget.productToEdit != null) {
            context.read<ProductCubit>().updateSubProduct(widget.productToEdit.id, payload);
          } else {
            payload['branch_id'] = widget.branchId;
            context.read<ProductCubit>().createSubProduct(payload);
          }
        } else {
          if (widget.productToEdit != null) {
            context.read<ProductCubit>().updateProduct(widget.productToEdit.id, payload);
          } else {
            payload['branch_id'] = widget.branchId;
            context.read<ProductCubit>().createProduct(payload);
          }
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
            SnackBar(content: Text(ProductConstants.createSuccess)),
          );
          if (widget.isSubProduct && widget.parentProductId != null && widget.parentProductLinkedIds != null && widget.productToEdit == null) {
            // Need to link the newly created sub-product
            final newSubProduct = state.subProducts.last;
            final updatedLinked = List<String>.from(widget.parentProductLinkedIds!)..add(newSubProduct.id);
            context.read<ProductCubit>().updateProduct(widget.parentProductId!, {'supported_sub_products': updatedLinked});
          }
          Navigator.pop(context);
        } else if (state.saveInfo.status == OperationStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.saveInfo.error?.message ?? ProductConstants.fetchProductsError)),
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
                                label: 'Unit',
                                controller: _unitController,
                                hint: 'e.g. kg, pc, gm',
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
            widget.productToEdit != null ? 'Update Product' : 'Add Product',
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
                    Text('Add Images', style: TextStyle(color: AppColors.textTertiary, fontSize: 12.sp)),
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
        AppInput(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType ?? TextInputType.text,
          validator: validator,
          hintText: hint,
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
        final isLoading = state.saveInfo.status == OperationStatus.loading || _isUploading;
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: AppButton(
            text: widget.productToEdit != null ? 'Update Product' : 'Save Product',
            onPressed: isLoading ? () {} : _saveProduct,
            isLoading: isLoading,
          ),
        );
      },
    );
  }
}