import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/manufacturing/constants/production.constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/manufacturing/manufacturing.cubit.dart';
import 'package:mobile/features/manufacturing/manufacturing.state.dart';
import 'package:mobile/utils/error.dart';

class BomListPage extends StatefulWidget {
  const BomListPage({super.key});

  @override
  State<BomListPage> createState() => _BomListPageState();
}

class _BomListPageState extends State<BomListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ManufacturingCubit>().listBOMs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(ProductionConstant.BOM_LIST_TITLE, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: BlocBuilder<ManufacturingCubit, ManufacturingState>(
        builder: (context, state) {
          if (state.loadBomsInfo.status == OperationStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          final boms = state.boms;
          if (boms.isEmpty) {
            return Center(child: Text('No BOMs found', style: TextStyle(color: AppColors.textSecondary)));
          }
          return ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: boms.length,
            separatorBuilder: (c, i) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final bom = boms[index];
              return GestureDetector(
                onTap: () {
                  context.read<ManufacturingCubit>().getBOM(bom.id);
                  Navigator.pushNamed(context, '/bom-detail');
                },
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(border: Border.all(color: AppColors.borderGrey), borderRadius: BorderRadius.circular(12.r)),
                  child: Text('Variant: ${bom.output_variant_id} (${bom.yield_quantity} Yield)', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/create-bom'),
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.add, color: AppColors.pureWhite),
        label: Text(ProductionConstant.CREATE_RECIPE, style: TextStyle(color: AppColors.pureWhite, fontWeight: FontWeight.w800)),
      ),
    );
  }
}
