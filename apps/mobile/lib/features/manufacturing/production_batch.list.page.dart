import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/manufacturing/constants/production.constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/manufacturing/manufacturing.cubit.dart';
import 'package:mobile/features/manufacturing/manufacturing.state.dart';
import 'package:mobile/utils/error.dart';

class ProductionBatchListPage extends StatefulWidget {
  const ProductionBatchListPage({super.key});

  @override
  State<ProductionBatchListPage> createState() => _ProductionBatchListPageState();
}

class _ProductionBatchListPageState extends State<ProductionBatchListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ManufacturingCubit>().listBatches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        title: Text(ProductionConstant.BATCH_LIST_TITLE, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: BlocBuilder<ManufacturingCubit, ManufacturingState>(
        builder: (context, state) {
          if (state.loadBatchesInfo.status == OperationStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          final batches = state.batches;
          if (batches.isEmpty) {
            return Center(child: Text('No batches found', style: TextStyle(color: AppColors.textSecondary)));
          }
          return ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: batches.length,
            separatorBuilder: (c, i) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final batch = batches[index];
              return GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/production-batch-detail'),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(border: Border.all(color: AppColors.borderGrey), borderRadius: BorderRadius.circular(12.r)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(batch.id, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                      Text(batch.status, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: Colors.orange)),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text('BOM: ${batch.bom_id} (${batch.planned_qty} Planned)', style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary)),
                ],
              ),
            ),
          );
        },
      );
      },
    ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/create-production-batch'),
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.add, color: AppColors.pureWhite),
        label: Text(ProductionConstant.NEW_BATCH, style: TextStyle(color: AppColors.pureWhite, fontWeight: FontWeight.w800)),
      ),
    );
  }
}
