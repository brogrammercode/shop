import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/business/cubit/business_cubit.dart';
import 'package:mobile/features/product/constants/product.dart';
import 'package:mobile/features/product/cubit/product_cubit.dart';
import 'package:mobile/features/product/cubit/product_state.dart';
import 'package:mobile/features/product/models/product_input_model.dart';
import 'package:mobile/features/product/models/product_model.dart';
import 'package:mobile/utils/error.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _lowStockController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  ProductModel? _product;
  bool _isAvailable = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final argument = ModalRoute.of(context)?.settings.arguments;
    if (_product == null && argument is ProductModel) {
      _product = argument;
      _nameController.text = argument.name;
      _skuController.text = argument.sku;
      _barcodeController.text = argument.barcode;
      _categoryController.text = argument.category;
      _priceController.text = argument.price.toStringAsFixed(2);
      _stockController.text = argument.stock.toString();
      _unitController.text = argument.unit;
      _lowStockController.text = argument.low_stock_alert.toString();
      _descriptionController.text = argument.description;
      _isAvailable = argument.is_available;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _unitController.dispose();
    _lowStockController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = _product == null
        ? ProductConstants.addProduct
        : ProductConstants.editProduct;

    return BlocListener<ProductCubit, ProductState>(
      listenWhen: (previous, current) =>
          previous.saveInfo.status != current.saveInfo.status,
      listener: (context, state) {
        if (state.saveInfo.status == OperationStatus.success) {
          Navigator.pop(context, true);
        }

        if (state.saveInfo.status == OperationStatus.error) {
          _showMessage(state.saveInfo.error?.message ?? '');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.pureWhite,
        appBar: AppBar(
          backgroundColor: AppColors.pureWhite,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.deepOnyx),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(title, style: Theme.of(context).textTheme.headlineMedium),
          centerTitle: true,
        ),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ProductConstants.productFormTitle,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                SizedBox(height: 24.h),
                AppInput(
                  hintText: ProductConstants.nameHint,
                  controller: _nameController,
                  prefixIcon: const Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.primaryIndigo,
                  ),
                ),
                SizedBox(height: 12.h),
                AppInput(
                  hintText: ProductConstants.skuHint,
                  controller: _skuController,
                  prefixIcon: const Icon(
                    Icons.sell_outlined,
                    color: AppColors.primaryIndigo,
                  ),
                ),
                SizedBox(height: 12.h),
                AppInput(
                  hintText: ProductConstants.barcodeHint,
                  controller: _barcodeController,
                  prefixIcon: const Icon(
                    Icons.qr_code_2,
                    color: AppColors.primaryIndigo,
                  ),
                ),
                SizedBox(height: 12.h),
                AppInput(
                  hintText: ProductConstants.categoryHint,
                  controller: _categoryController,
                  prefixIcon: const Icon(
                    Icons.category_outlined,
                    color: AppColors.primaryIndigo,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: AppInput(
                        hintText: ProductConstants.priceHint,
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: AppInput(
                        hintText: ProductConstants.stockHint,
                        controller: _stockController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: AppInput(
                        hintText: ProductConstants.unitHint,
                        controller: _unitController,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: AppInput(
                        hintText: ProductConstants.lowStockHint,
                        controller: _lowStockController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                AppInput(
                  hintText: ProductConstants.descriptionHint,
                  controller: _descriptionController,
                  prefixIcon: const Icon(
                    Icons.notes_outlined,
                    color: AppColors.primaryIndigo,
                  ),
                ),
                SizedBox(height: 12.h),
                SwitchListTile(
                  value: _isAvailable,
                  onChanged: (value) {
                    setState(() {
                      _isAvailable = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    ProductConstants.availableLabel,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  activeThumbColor: AppColors.primaryIndigo,
                ),
                SizedBox(height: 24.h),
                BlocBuilder<ProductCubit, ProductState>(
                  builder: (context, state) {
                    final isSaving =
                        state.saveInfo.status == OperationStatus.loading;
                    return AppButton(
                      text: isSaving
                          ? ProductConstants.savingProduct
                          : ProductConstants.saveProduct,
                      onPressed: isSaving ? () {} : _saveProduct,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveProduct() {
    final branchId = context.read<BusinessCubit>().state.context?.branch.id;
    final price = double.tryParse(_priceController.text.trim());
    final stock = int.tryParse(_stockController.text.trim());
    final lowStock = int.tryParse(
      _lowStockController.text.trim().isEmpty
          ? '0'
          : _lowStockController.text.trim(),
    );

    if (branchId == null ||
        branchId.isEmpty ||
        _nameController.text.trim().isEmpty ||
        price == null ||
        stock == null) {
      _showMessage(ProductConstants.requiredFieldMessage);
      return;
    }

    if (price < 0 || stock < 0 || lowStock == null || lowStock < 0) {
      _showMessage(ProductConstants.invalidNumberMessage);
      return;
    }

    final input = ProductInputModel(
      branch_id: branchId,
      sku: _skuController.text.trim(),
      barcode: _barcodeController.text.trim(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      price: price,
      stock: stock,
      category: _categoryController.text.trim(),
      unit: _unitController.text.trim(),
      low_stock_alert: lowStock,
      is_available: _isAvailable,
    );

    context.read<ProductCubit>().save(input, id: _product?.id);
  }

  void _showMessage(String message) {
    if (message.isEmpty) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
