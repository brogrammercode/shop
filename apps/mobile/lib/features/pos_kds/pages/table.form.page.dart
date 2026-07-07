import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/bottom_action.dart';
import 'package:mobile/features/pos_kds/controllers/pos_kds.cubit.dart';
import 'package:mobile/features/pos_kds/controllers/pos_kds.state.dart';
import 'package:mobile/features/pos_kds/models/table.model.dart';
import 'package:mobile/features/pos_kds/models/table_zone.model.dart';
import 'package:mobile/core/widgets/action_bottom_sheet.dart';
import 'package:mobile/utils/error.dart';

class TableFormPage extends StatefulWidget {
  final TableModel? table;
  const TableFormPage({super.key, this.table});

  @override
  State<TableFormPage> createState() => _TableFormPageState();
}

class _TableFormPageState extends State<TableFormPage> {
  late TextEditingController _numberController;
  late TextEditingController _capacityController;
  late TextEditingController _sideCountController;

  TableZoneModel? _selectedZone;

  @override
  void initState() {
    super.initState();
    _numberController =
        TextEditingController(text: widget.table?.table_number ?? '');
    _capacityController =
        TextEditingController(text: widget.table?.capacity.toString() ?? '4');
    _sideCountController =
        TextEditingController(text: widget.table?.side_count.toString() ?? '4');

    // Make sure zones are loaded
    context.read<PosKdsCubit>().listTableZones();
  }

  @override
  void dispose() {
    _numberController.dispose();
    _capacityController.dispose();
    _sideCountController.dispose();
    super.dispose();
  }

  void _showZonePicker(List<TableZoneModel> zones) {
    if (zones.isEmpty) {
      ActionBottomSheet.show(
        context,
        groups: [
          BottomSheetActionGroup(
            actions: [
              BottomSheetAction(
                label: 'Create Table Zone First',
                icon: Icons.add_circle_outline,
                onTap: () {
                  Navigator.pushNamed(context, '/table-zone-list');
                },
              ),
            ],
          ),
        ],
      );
      return;
    }
    ActionBottomSheet.show(
      context,
      groups: [
        BottomSheetActionGroup(
          actions:
              zones.map((z) {
                return BottomSheetAction(
                  label: z.name,
                  icon: Icons.check_circle_outline,
                  iconColor:
                      _selectedZone?.id == z.id
                          ? AppColors.primaryGreen
                          : AppColors.textTertiary,
                  onTap: () {
                    setState(() {
                      _selectedZone = z;
                    });
                  },
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(
                color: AppColors.pureWhite,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.chevron_left,
                color: AppColors.textPrimary,
                size: 24.w,
              ),
            ),
          ),
          Text(
            widget.table == null ? 'Create Table' : 'Edit Table',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(width: 40.w), // Balance for centering
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: BlocBuilder<PosKdsCubit, PosKdsState>(
                  builder: (context, state) {
                    // Initialize selected zone if editing
                    if (widget.table != null && _selectedZone == null) {
                      try {
                        _selectedZone = state.tableZones.firstWhere(
                          (z) => z.id == widget.table!.zone_id,
                        );
                      } catch (_) {}
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TABLE ZONE',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textTertiary,
                            letterSpacing: 0.8,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        AppInput(
                          hintText: 'Select Table Zone',
                          controller: TextEditingController(
                            text: _selectedZone?.name ?? '',
                          ),
                          readOnly: true,
                          onTap: () => _showZonePicker(state.tableZones),
                          suffixIcon: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.textTertiary,
                            size: 20.w,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          'TABLE NUMBER / NAME',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textTertiary,
                            letterSpacing: 0.8,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        AppInput(
                          hintText: 'e.g. T-01',
                          controller: _numberController,
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          'CAPACITY',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textTertiary,
                            letterSpacing: 0.8,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        AppInput(
                          hintText: 'e.g. 4',
                          keyboardType: TextInputType.number,
                          controller: _capacityController,
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          'SIDES (FOR KDS)',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textTertiary,
                            letterSpacing: 0.8,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        AppInput(
                          hintText: 'e.g. 4',
                          keyboardType: TextInputType.number,
                          controller: _sideCountController,
                        ),
                        SizedBox(height: 12.h),
                        AnimatedBuilder(
                          animation: Listenable.merge([
                            _numberController,
                            _sideCountController,
                          ]),
                          builder: (context, _) {
                            final number = _numberController.text.trim();
                            final count =
                                int.tryParse(_sideCountController.text) ?? 0;
                            if (number.isEmpty || count <= 0) {
                              return const SizedBox.shrink();
                            }
                            final labels = List.generate(
                              count,
                              (i) => '$number-${i + 1}',
                            ).join(', ');
                            return Text(
                              'Generated side QR codes: $labels',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                                fontStyle: FontStyle.italic,
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            BlocConsumer<PosKdsCubit, PosKdsState>(
              listenWhen: (prev, curr) {
                return prev.saveTablesInfo.status !=
                        curr.saveTablesInfo.status &&
                    curr.saveTablesInfo.status == OperationStatus.success;
              },
              listener: (context, state) {
                Navigator.pop(context);
              },
              builder: (context, state) {
                return AppBottomAction(
                  child: AppButton(
                    text: widget.table == null ? 'Create Table' : 'Save Changes',
                    isLoading:
                        state.saveTablesInfo.status == OperationStatus.loading,
                    onPressed: () {
                      if (_selectedZone == null) return;
                      final number = _numberController.text.trim();
                      if (number.isEmpty) return;

                      final data = {
                        'zone_id': _selectedZone!.id,
                        'table_number': number,
                        'capacity': int.tryParse(_capacityController.text) ?? 4,
                        'side_count':
                            int.tryParse(_sideCountController.text) ?? 4,
                      };

                      if (widget.table != null) {
                        context.read<PosKdsCubit>().updateTable(
                          widget.table!.id,
                          data,
                        );
                      } else {
                        // branch_id is handled by backend from token
                        context.read<PosKdsCubit>().createTable(data);
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
