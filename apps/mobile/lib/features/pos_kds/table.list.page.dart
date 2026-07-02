import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/pos_kds/constants/pos.constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/pos_kds/pos_kds.cubit.dart';
import 'package:mobile/features/pos_kds/pos_kds.state.dart';
import 'package:mobile/utils/error.dart';

class TableListPage extends StatefulWidget {
  const TableListPage({super.key});

  @override
  State<TableListPage> createState() => _TableListPageState();
}

class _TableListPageState extends State<TableListPage> {
  @override
  void initState() {
    super.initState();
    context.read<PosKdsCubit>().listTables();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softGrey,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(PosConstant.TABLE_LIST_TITLE, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: Column(
        children: [
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
                  return const Center(child: CircularProgressIndicator());
                }
                final tables = state.tables;
                if (tables.isEmpty) {
                  return Center(child: Text('No tables found', style: TextStyle(color: AppColors.textSecondary)));
                }
                return GridView.builder(
              padding: EdgeInsets.all(24.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 32.w,
                mainAxisSpacing: 32.h,
                childAspectRatio: 1.0,
              ),
              itemCount: tables.length,
              itemBuilder: (context, index) {
                final table = tables[index];
                final isOccupied = table.status == 'OCCUPIED';
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/pos-terminal'),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      // The Table Square
                      Container(
                        decoration: BoxDecoration(
                          color: isOccupied ? const Color(0xFFFFEBEE) : AppColors.pureWhite,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: isOccupied ? Colors.redAccent : AppColors.borderGrey, width: 2),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(table.table_number, style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w900, color: isOccupied ? Colors.redAccent : AppColors.textPrimary)),
                              if (isOccupied)
                                Text('Active', style: TextStyle(fontSize: 12.sp, color: Colors.redAccent, fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                      ),
                      // Chair Indicators (Top, Right, Bottom, Left) depending on capacity
                      if (table.capacity >= 1) _buildChair(Alignment.topCenter, false, -10.h),
                      if (table.capacity >= 2) _buildChair(Alignment.bottomCenter, false, -10.h),
                      if (table.capacity >= 3) _buildChair(Alignment.centerRight, isOccupied, -10.w),
                      if (table.capacity >= 4) _buildChair(Alignment.centerLeft, false, -10.w),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    ],
  ),
    );
  }

  Widget _buildStatusLegend(String label, Color color) {
    return Row(
      children: [
        Container(width: 12.w, height: 12.w, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        SizedBox(width: 8.w),
        Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildChair(Alignment alignment, bool isOccupied, double offsetValue) {
    return Positioned(
      top: alignment == Alignment.topCenter ? offsetValue : null,
      bottom: alignment == Alignment.bottomCenter ? offsetValue : null,
      left: alignment == Alignment.centerLeft ? offsetValue : null,
      right: alignment == Alignment.centerRight ? offsetValue : null,
      child: Container(
        width: 24.w,
        height: 24.w,
        decoration: BoxDecoration(
          color: isOccupied ? Colors.redAccent : const Color(0xFFE0E0E0),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.pureWhite, width: 2),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
        ),
      ),
    );
  }
}
