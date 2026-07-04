import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/app_refresher.dart';
import 'package:mobile/components/ui/loader.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/features/inventory/controllers/inventory.cubit.dart';
import 'package:mobile/features/inventory/controllers/inventory.state.dart';
import 'package:mobile/features/inventory/models/unit_of_measure.model.dart';
import 'package:mobile/features/inventory/models/u_o_m_conversion.model.dart';
import 'package:mobile/utils/error.dart';

class UomDetailPage extends StatefulWidget {
  const UomDetailPage({super.key});

  @override
  State<UomDetailPage> createState() => _UomDetailPageState();
}

class _UomDetailPageState extends State<UomDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryCubit>().listUomConversions();
    });
  }

  void _showAddConversionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.pureWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        final uom = ModalRoute.of(this.context)!.settings.arguments as UnitOfMeasureModel;
        return _AddConversionSheet(fromUom: uom);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final uom = ModalRoute.of(context)!.settings.arguments as UnitOfMeasureModel;

    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(context),
            _buildHeader(uom),
            SizedBox(height: 24.h),
            _buildSectionLabel('CONVERSIONS'),
            Expanded(
              child: BlocBuilder<InventoryCubit, InventoryState>(
                builder: (context, state) {
                  if (state.loadUomConversionsInfo.status == OperationStatus.loading &&
                      state.uomConversions.isEmpty) {
                    return const Center(child: AppLoader());
                  }

                  final conversions = state.uomConversions
                      .where((c) => c.from_uom_id == uom.id || c.to_uom_id == uom.id)
                      .toList();

                  if (conversions.isEmpty &&
                      state.loadUomConversionsInfo.status != OperationStatus.loading) {
                    return Center(
                      child: Text(
                        'No conversions found',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                        ),
                      ),
                    );
                  }

                  return AppRefresher(
                    onRefresh: () => context.read<InventoryCubit>().listUomConversions(),
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                      itemCount: conversions.length,
                      separatorBuilder: (c, i) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final conversion = conversions[index];
                        final isFrom = conversion.from_uom_id == uom.id;
                        final targetUom = state.uoms.firstWhere(
                          (u) => u.id == (isFrom ? conversion.to_uom_id : conversion.from_uom_id),
                          orElse: () => UnitOfMeasureModel(
                            id: '',
                            branch_id: '',
                            code: 'Unknown',
                            description: '',
                            created_at: '',
                            updated_at: '',
                            is_deleted: false,
                          ),
                        );
                        
                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: AppColors.pureWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                              ),
                              builder: (context) => _AddConversionSheet(
                                fromUom: uom,
                                existingConversion: conversion,
                              ),
                            );
                          },
                          child: _buildConversionCard(conversion, targetUom, uom, isFrom),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 32.h),
        child: FloatingActionButton(
          onPressed: _showAddConversionSheet,
          backgroundColor: AppColors.primaryGreen,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: AppColors.pureWhite),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Icon(
          Icons.arrow_back,
          color: AppColors.textPrimary,
          size: 24.w,
        ),
      ),
    );
  }

  Widget _buildHeader(UnitOfMeasureModel uom) {
    String formattedDate = '';
    try {
      final dt = DateTime.parse(uom.created_at);
      formattedDate = '${dt.month}/${dt.day}/${dt.year}';
    } catch (_) {
      formattedDate = uom.created_at;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
                child: Text(
                  uom.code.length > 3
                      ? uom.code.substring(0, 3)
                      : uom.code,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      uom.code,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      uom.description,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            'Created on $formattedDate',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.textTertiary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildConversionCard(
      UOMConversionModel conversion, UnitOfMeasureModel target, UnitOfMeasureModel uom, bool isFrom) {
    final leftCode = isFrom ? uom.code : target.code;
    final rightCode = isFrom ? target.code : uom.code;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderGrey, width: 1.w),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                '1',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                leftCode,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Icon(Icons.arrow_forward_rounded, color: AppColors.textTertiary, size: 20.w),
          Row(
            children: [
              Text(
                conversion.factor.toString(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                rightCode,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddConversionSheet extends StatefulWidget {
  final UnitOfMeasureModel fromUom;
  final UOMConversionModel? existingConversion;

  const _AddConversionSheet({required this.fromUom, this.existingConversion});

  @override
  State<_AddConversionSheet> createState() => _AddConversionSheetState();
}

class _AddConversionSheetState extends State<_AddConversionSheet> {
  final TextEditingController _factorCtrl = TextEditingController();
  String? _selectedToUomId;
  bool _isEditing = false;
  bool _isReverseEdit = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingConversion != null) {
      _isEditing = true;
      _factorCtrl.text = widget.existingConversion!.factor.toString();
      _isReverseEdit = widget.existingConversion!.to_uom_id == widget.fromUom.id;
      _selectedToUomId = _isReverseEdit 
          ? widget.existingConversion!.from_uom_id 
          : widget.existingConversion!.to_uom_id;
    }
  }

  @override
  void dispose() {
    _factorCtrl.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_selectedToUomId == null || _factorCtrl.text.isEmpty) return;
    final factor = double.tryParse(_factorCtrl.text) ?? 1.0;
    
    if (_isEditing) {
      context.read<InventoryCubit>().updateUomConversion(
        widget.existingConversion!.id,
        {'factor': factor},
      );
    } else {
      context.read<InventoryCubit>().createUomConversion({
        'from_uom_id': widget.fromUom.id,
        'to_uom_id': _selectedToUomId,
        'factor': factor,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InventoryCubit, InventoryState>(
      listenWhen: (prev, curr) =>
          prev.saveUomConversionsInfo != curr.saveUomConversionsInfo,
      listener: (context, state) {
        if (state.saveUomConversionsInfo.status == OperationStatus.success) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final isLoading =
            state.saveUomConversionsInfo.status == OperationStatus.loading;
        final availableUoms =
            state.uoms.where((u) => u.id != widget.fromUom.id).toList();

        return Padding(
          padding: EdgeInsets.only(
            left: 24.w,
            right: 24.w,
            top: 24.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isEditing ? 'Edit Conversion' : 'Add Conversion',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: CircleAvatar(
                      radius: 16.r,
                      backgroundColor: AppColors.softGrey,
                      child: Icon(Icons.close, color: AppColors.deepOnyx, size: 16.w),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Text(
                _isReverseEdit ? 'Base UOM (From)' : 'Target UOM (To)',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.softGrey,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedToUomId,
                    isExpanded: true,
                    hint: Text(
                      'Select unit',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    items: availableUoms.map((uom) {
                      return DropdownMenuItem(
                        value: uom.id,
                        child: Text(
                          '${uom.code} - ${uom.description}',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: _isEditing ? null : (val) => setState(() => _selectedToUomId = val),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Conversion Factor',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              AppInput(
                controller: _factorCtrl,
                hintText: 'e.g. 1000',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 8.h),
              Text(
                _isReverseEdit 
                  ? '1 [Base UOM] = [Factor] ${widget.fromUom.code}'
                  : '1 ${widget.fromUom.code} = [Factor] [Target UOM]',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textTertiary,
                ),
              ),
              SizedBox(height: 32.h),
              AppButton(
                text: _isEditing ? 'UPDATE CONVERSION' : 'SAVE CONVERSION',
                isLoading: isLoading,
                onPressed: _onSave,
              ),
            ],
          ),
        );
      },
    );
  }
}
