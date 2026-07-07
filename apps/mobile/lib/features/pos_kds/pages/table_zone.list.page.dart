import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/pos_kds/constants/pos.constant.dart';
import 'package:mobile/features/pos_kds/controllers/pos_kds.cubit.dart';
import 'package:mobile/features/pos_kds/controllers/pos_kds.state.dart';
import 'package:mobile/components/ui/app_refresher.dart';
import 'package:mobile/components/ui/loader.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/bottom_action.dart';
import 'package:mobile/core/widgets/action_bottom_sheet.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile/features/pos_kds/models/table_zone.model.dart';

class TableZoneListPage extends StatefulWidget {
  const TableZoneListPage({super.key});

  @override
  State<TableZoneListPage> createState() => _TableZoneListPageState();
}

class _TableZoneListPageState extends State<TableZoneListPage> {
  @override
  void initState() {
    super.initState();
    context.read<PosKdsCubit>().listTableZones();
  }

  void _showZoneForm([TableZoneModel? zone]) {
    final isEditing = zone != null;
    final controller = TextEditingController(text: zone?.name ?? '');

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 16.h),
                  Center(
                    child: Text(
                      isEditing ? 'Edit Table Zone' : 'Create Table Zone',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: AppInput(
                      hintText: 'Zone Name (e.g. Indoor Seating)',
                      controller: controller,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  BlocBuilder<PosKdsCubit, PosKdsState>(
                    builder: (context, state) {
                      final isLoading =
                          state.saveTableZonesInfo.status ==
                          OperationStatus.loading;
                      return AppBottomAction(
                        child: AppButton(
                          text: isEditing ? 'Save Changes' : 'Create Zone',
                          isLoading: isLoading,
                          onPressed: () {
                            final name = controller.text.trim();
                            if (name.isEmpty) return;
                            if (isEditing) {
                              context.read<PosKdsCubit>().updateTableZone(
                                zone.id,
                                {'name': name},
                              );
                            } else {
                              context.read<PosKdsCubit>().createTableZone(
                                {'branch_id': '', 'name': name}, // Branch ID will be handled by backend from user token
                              );
                            }
                            Navigator.pop(ctx);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showActionSheet(TableZoneModel zone) {
    ActionBottomSheet.show(
      context,
      groups: [
        BottomSheetActionGroup(
          actions: [
            BottomSheetAction(
              label: 'Edit Zone',
              icon: Icons.edit_outlined,
              onTap: () => _showZoneForm(zone),
            ),
            BottomSheetAction(
              label: 'Delete Zone',
              icon: Icons.delete_outline,
              iconColor: Colors.redAccent,
              labelColor: Colors.redAccent,
              onTap: () {
                context.read<PosKdsCubit>().deleteTableZone(zone.id);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: AppColors.pureWhite,
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
          Expanded(
            child: Text(
              PosConstant.TABLE_ZONE_TITLE,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(width: 40.w), // Balance the chevron
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          _buildAppBar(context),
          Expanded(
            child: BlocBuilder<PosKdsCubit, PosKdsState>(
              builder: (context, state) {
                if (state.loadTableZonesInfo.status ==
                    OperationStatus.loading) {
                  return const Center(child: AppLoader());
                }

                final zones = state.tableZones;
                if (zones.isEmpty) {
                  return Center(
                    child: Text(
                      'No table zones found.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }

                return AppRefresher(
                  onRefresh: () async {
                    context.read<PosKdsCubit>().listTableZones();
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.all(16.w),
                    itemCount: zones.length,
                    separatorBuilder: (c, i) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final zone = zones[index];
                      return Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppColors.pureWhite,
                          border: Border.all(color: AppColors.borderGrey),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              zone.name,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _showActionSheet(zone),
                              child: Icon(
                                Icons.more_vert,
                                color: AppColors.textSecondary,
                                size: 20.w,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showZoneForm,
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.add, color: AppColors.pureWhite),
        label: Text(
          PosConstant.CREATE_ZONE,
          style: TextStyle(
            color: AppColors.pureWhite,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
