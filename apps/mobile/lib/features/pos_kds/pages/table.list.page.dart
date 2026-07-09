import 'package:mobile/components/ui/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/app_refresher.dart';
import 'package:mobile/features/pos_kds/constants/pos.constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/pos_kds/controllers/pos_kds.cubit.dart';
import 'package:mobile/features/pos_kds/controllers/pos_kds.state.dart';
import 'package:mobile/features/pos_kds/models/table.model.dart';
import 'package:mobile/features/pos_kds/services/table_qr_url_builder.dart';
import 'package:mobile/utils/error.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TableListPage extends StatefulWidget {
  const TableListPage({super.key});

  @override
  State<TableListPage> createState() => _TableListPageState();
}

class _TableListPageState extends State<TableListPage> {
  String? _selectedZoneId;

  @override
  void initState() {
    super.initState();
    context.read<PosKdsCubit>().listTables();
    context.read<PosKdsCubit>().listOrders();
    context.read<PosKdsCubit>().listTableZones();
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            PosConstant.TABLE_LIST_TITLE,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(width: 40.w),
        ],
      ),
    );
  }

  Widget _buildZoneFilter(PosKdsState state) {
    final zones = state.tableZones;
    if (zones.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: AppColors.pureWhite,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('All', null),
            ...zones.map((z) => _buildFilterChip(z.name, z.id)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String? zoneId) {
    final isSelected = _selectedZoneId == zoneId;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedZoneId = zoneId;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : AppColors.pureWhite,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.borderGrey,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: isSelected ? AppColors.pureWhite : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  String _tableSideQrData(TableModel table, String side) {
    return TableQrUrlBuilder.sideUrl(table: table, side: side);
  }

  void _showTableSideQr(TableModel table, String side) {
    final qrData = _tableSideQrData(table, side);
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: AppColors.pureWhite,
          insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${PosConstant.TABLE_SIDE_QR_TITLE} ${table.table_number}',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(dialogContext),
                      child: Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: const BoxDecoration(
                          color: AppColors.deepOnyx,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: AppColors.pureWhite,
                          size: 18.w,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    side,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
                Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: AppColors.pureWhite,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColors.borderGrey),
                  ),
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 220.w,
                    backgroundColor: AppColors.pureWhite,
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  PosConstant.TABLE_SIDE_QR_SUBTITLE,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textTertiary,
                  ),
                ),
                SizedBox(height: 18.h),
                SizedBox(
                  width: double.infinity,
                  height: 44.h,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      PosConstant.TABLE_SIDE_QR_CLOSE,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.pureWhite,
                      ),
                    ),
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
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            BlocBuilder<PosKdsCubit, PosKdsState>(
              builder: (context, state) {
                return _buildZoneFilter(state);
              },
            ),
            Container(
              color: AppColors.pureWhite,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  _buildStatusLegend('Available', AppColors.primaryGreen),
                  SizedBox(width: 16.w),
                  _buildStatusLegend('Occupied', Colors.redAccent),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<PosKdsCubit, PosKdsState>(
                builder: (context, state) {
                  if (state.loadTablesInfo.status == OperationStatus.loading) {
                    return const Center(child: AppLoader());
                  }
                  final tables = state.tables.where((t) {
                    if (_selectedZoneId == null) return true;
                    return t.zone_id == _selectedZoneId;
                  }).toList();

                  if (tables.isEmpty) {
                    return Center(
                      child: Text(
                        'No tables found',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    );
                  }

                  final activeOrders = state.orders
                      .where(
                        (order) => PosConstant.ACTIVE_TABLE_ORDER_STATUSES
                            .contains(order.status),
                      )
                      .toList();

                  return AppRefresher(
                    onRefresh: () async {
                      context.read<PosKdsCubit>().listTables();
                      context.read<PosKdsCubit>().listOrders();
                    },
                    child: GridView.builder(
                      padding: EdgeInsets.all(24.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 32.w,
                        mainAxisSpacing: 32.h,
                        childAspectRatio: 1,
                      ),
                      itemCount: tables.length,
                      itemBuilder: (context, index) {
                        final table = tables[index];
                        final tableOrders = activeOrders
                            .where((o) => o.table_id == table.id)
                            .toList();
                        final isOccupied =
                            tableOrders.isNotEmpty ||
                            table.status == 'OCCUPIED';

                        final activeSideLabels = <String>{};
                        for (final order in tableOrders) {
                          activeSideLabels.addAll(
                            order.table_side_ids.map((e) => e.toString()),
                          );
                        }

                        return GestureDetector(
                          onTap: () {},
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isOccupied
                                        ? [
                                            const Color(0xFFFFEBEE),
                                            const Color(0xFFFFCDD2),
                                          ]
                                        : [
                                            AppColors.pureWhite,
                                            const Color(0xFFF5F5F5),
                                          ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: isOccupied
                                        ? Colors.redAccent
                                        : AppColors.borderGrey,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isOccupied
                                          ? Colors.redAccent.withOpacity(0.3)
                                          : Colors.black.withOpacity(0.05),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        table.table_number,
                                        style: TextStyle(
                                          fontSize: 32.sp,
                                          fontWeight: FontWeight.w900,
                                          color: isOccupied
                                              ? Colors.redAccent
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                      if (isOccupied)
                                        Text(
                                          'Active',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              ...List.generate(table.side_count, (i) {
                                final label = table.side_labels.length > i
                                    ? table.side_labels[i]
                                    : 'S${i + 1}';
                                final isSideActive = activeSideLabels.contains(
                                  label,
                                );
                                return _buildChairForTable(
                                  i,
                                  table.side_count,
                                  isSideActive,
                                  label,
                                  () => _showTableSideQr(table, label),
                                );
                              }),
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
      ),
    );
  }

  Widget _buildStatusLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildChairForTable(
    int index,
    int total,
    bool isActive,
    String label,
    VoidCallback onTap,
  ) {
    Alignment alignment = Alignment.topCenter;

    final offset = -16.0.w;

    if (total == 1) {
      alignment = Alignment.topCenter;
    } else if (total == 2) {
      alignment = index == 0 ? Alignment.topCenter : Alignment.bottomCenter;
    } else if (total == 3) {
      if (index == 0) alignment = Alignment.topCenter;
      if (index == 1) alignment = Alignment.bottomCenter;
      if (index == 2) alignment = Alignment.centerRight;
    } else if (total == 4) {
      if (index == 0) alignment = Alignment.topCenter;
      if (index == 1) alignment = Alignment.centerRight;
      if (index == 2) alignment = Alignment.bottomCenter;
      if (index == 3) alignment = Alignment.centerLeft;
    }

    return Positioned(
      top: alignment == Alignment.topCenter ? offset : null,
      bottom: alignment == Alignment.bottomCenter ? offset : null,
      left: alignment == Alignment.centerLeft ? offset : null,
      right: alignment == Alignment.centerRight ? offset : null,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isActive
                  ? [Colors.redAccent, Colors.red.shade700]
                  : [const Color(0xFFF5F5F5), const Color(0xFFE0E0E0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.pureWhite, width: 3),
            boxShadow: [
              BoxShadow(
                color: isActive
                    ? Colors.redAccent.withOpacity(0.5)
                    : Colors.black12,
                blurRadius: isActive ? 8 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w900,
                color: isActive ? AppColors.pureWhite : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
