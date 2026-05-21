import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/business/cubit/business_cubit.dart';
import 'package:mobile/features/order/constants/order.dart';
import 'package:mobile/features/order/cubit/counter_sale_cubit.dart';
import 'package:mobile/features/order/cubit/counter_sale_state.dart';
import 'package:mobile/features/order/models/cart_item_model.dart';
import 'package:mobile/features/order/models/thermal_printer_model.dart';
import 'package:mobile/features/product/models/product_model.dart';
import 'package:mobile/utils/error.dart';

class CounterSalePage extends StatefulWidget {
  const CounterSalePage({super.key});

  @override
  State<CounterSalePage> createState() => _CounterSalePageState();
}

class _CounterSalePageState extends State<CounterSalePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProducts();
      context.read<CounterSaleCubit>().loadPrinters();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CounterSaleCubit, CounterSaleState>(
          listenWhen: (previous, current) =>
              previous.billInfo.status != current.billInfo.status,
          listener: (context, state) {
            if (state.billInfo.status == OperationStatus.success) {
              _showMessage(OrderConstants.receiptReady);
              _loadProducts();
            }

            if (state.billInfo.status == OperationStatus.error) {
              _showMessage(state.billInfo.error?.message ?? '');
            }
          },
        ),
        BlocListener<CounterSaleCubit, CounterSaleState>(
          listenWhen: (previous, current) =>
              previous.printInfo.status != current.printInfo.status ||
              previous.printerInfo.status != current.printerInfo.status,
          listener: (context, state) {
            if (state.printInfo.status == OperationStatus.success) {
              _showMessage(OrderConstants.receiptPrinted);
            }

            if (state.printInfo.status == OperationStatus.error) {
              _showMessage(state.printInfo.error?.message ?? '');
            }

            if (state.printerInfo.status == OperationStatus.error) {
              _showMessage(state.printerInfo.error?.message ?? '');
            }
          },
        ),
      ],
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
          title: Text(
            OrderConstants.counterTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          top: false,
          child: BlocBuilder<CounterSaleCubit, CounterSaleState>(
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 24.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            OrderConstants.counterSubtitle,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(height: 20.h),
                          AppInput(
                            hintText: OrderConstants.searchHint,
                            controller: _searchController,
                            onChanged: (_) => _loadProducts(),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: AppColors.primaryIndigo,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          _ProductSection(
                            products: state.products,
                            isLoading:
                                state.productInfo.status ==
                                OperationStatus.loading,
                            onAdd: context.read<CounterSaleCubit>().addProduct,
                          ),
                          SizedBox(height: 24.h),
                          _CartSection(
                            items: state.cartItems,
                            subtotal: state.subtotal,
                            onIncrement: (item) {
                              context.read<CounterSaleCubit>().updateQuantity(
                                item.product.id,
                                item.quantity + 1,
                              );
                            },
                            onDecrement: (item) {
                              context.read<CounterSaleCubit>().updateQuantity(
                                item.product.id,
                                item.quantity - 1,
                              );
                            },
                          ),
                          if (state.receipt != null) ...[
                            SizedBox(height: 24.h),
                            _PrinterSection(
                              printers: state.printers,
                              selectedPrinter: state.selectedPrinter,
                              onRefresh: context
                                  .read<CounterSaleCubit>()
                                  .loadPrinters,
                              onChanged: (printer) {
                                if (printer != null) {
                                  context
                                      .read<CounterSaleCubit>()
                                      .selectPrinter(printer);
                                }
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  _BottomBar(state: state, branchId: _branchId(context)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _branchId(BuildContext context) {
    return context.read<BusinessCubit>().state.context?.branch.id ?? '';
  }

  void _loadProducts() {
    final branchId = _branchId(context);
    if (branchId.isEmpty) {
      return;
    }

    context.read<CounterSaleCubit>().loadProducts(
      branchId,
      search: _searchController.text,
    );
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

class _ProductSection extends StatelessWidget {
  final List<ProductModel> products;
  final bool isLoading;
  final ValueChanged<ProductModel> onAdd;

  const _ProductSection({
    required this.products,
    required this.isLoading,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (products.isEmpty) {
      return _InfoPanel(text: OrderConstants.emptyCart);
    }

    return Column(
      children: products
          .map(
            (product) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _CounterProductTile(product: product, onAdd: onAdd),
            ),
          )
          .toList(),
    );
  }
}

class _CounterProductTile extends StatelessWidget {
  final ProductModel product;
  final ValueChanged<ProductModel> onAdd;

  const _CounterProductTile({required this.product, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.softGrey,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            color: AppColors.primaryIndigo,
            size: 28.w,
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${OrderConstants.currencySymbol} ${product.price.toStringAsFixed(2)} · ${OrderConstants.stockPrefix} ${product.stock}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle),
            color: AppColors.primaryIndigo,
            onPressed: product.stock <= 0 ? null : () => onAdd(product),
          ),
        ],
      ),
    );
  }
}

class _CartSection extends StatelessWidget {
  final List<CartItemModel> items;
  final double subtotal;
  final ValueChanged<CartItemModel> onIncrement;
  final ValueChanged<CartItemModel> onDecrement;

  const _CartSection({
    required this.items,
    required this.subtotal,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.deepOnyx,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            OrderConstants.cartTitle,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(color: AppColors.pureWhite),
          ),
          SizedBox(height: 12.h),
          if (items.isEmpty)
            Text(
              OrderConstants.emptyCart,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.pureWhite.withOpacity(0.8),
              ),
            )
          else
            Column(
              children: items
                  .map(
                    (item) => _CartItemTile(
                      item: item,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                    ),
                  )
                  .toList(),
            ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  OrderConstants.totalLabel,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${OrderConstants.currencySymbol} ${subtotal.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.pureWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final ValueChanged<CartItemModel> onIncrement;
  final ValueChanged<CartItemModel> onDecrement;

  const _CartItemTile({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.pureWhite),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            color: AppColors.pureWhite,
            onPressed: () => onDecrement(item),
          ),
          Text(
            item.quantity.toString(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.pureWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            color: AppColors.pureWhite,
            onPressed: () => onIncrement(item),
          ),
        ],
      ),
    );
  }
}

class _PrinterSection extends StatelessWidget {
  final List<ThermalPrinterModel> printers;
  final ThermalPrinterModel? selectedPrinter;
  final VoidCallback onRefresh;
  final ValueChanged<ThermalPrinterModel?> onChanged;

  const _PrinterSection({
    required this.printers,
    required this.selectedPrinter,
    required this.onRefresh,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.softGrey,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  OrderConstants.printerTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              TextButton(
                onPressed: onRefresh,
                child: const Text(OrderConstants.refreshPrinters),
              ),
            ],
          ),
          if (printers.isEmpty)
            Text(
              OrderConstants.noPrinters,
              style: Theme.of(context).textTheme.bodyMedium,
            )
          else
            DropdownButton<ThermalPrinterModel>(
              value: selectedPrinter,
              isExpanded: true,
              items: printers
                  .map(
                    (printer) => DropdownMenuItem<ThermalPrinterModel>(
                      value: printer,
                      child: Text(
                        printer.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final CounterSaleState state;
  final String branchId;

  const _BottomBar({required this.state, required this.branchId});

  @override
  Widget build(BuildContext context) {
    final hasReceipt = state.receipt != null;
    final isBilling = state.billInfo.status == OperationStatus.loading;
    final isPrinting = state.printInfo.status == OperationStatus.loading;
    final canCreateBill = state.cartItems.isNotEmpty && branchId.isNotEmpty;
    final canPrint = hasReceipt && state.selectedPrinter != null;

    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
      color: AppColors.pureWhite,
      child: AppButton(
        text: hasReceipt
            ? isPrinting
                  ? OrderConstants.printingReceipt
                  : OrderConstants.printReceipt
            : isBilling
            ? OrderConstants.creatingBill
            : OrderConstants.createBill,
        onPressed: hasReceipt
            ? canPrint && !isPrinting
                  ? context.read<CounterSaleCubit>().printReceipt
                  : () {}
            : canCreateBill && !isBilling
            ? () => context.read<CounterSaleCubit>().createBill(branchId)
            : () {},
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  final String text;

  const _InfoPanel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.softGrey,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
