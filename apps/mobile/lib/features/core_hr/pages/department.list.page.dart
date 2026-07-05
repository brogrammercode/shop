import 'package:mobile/components/ui/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/app_refresher.dart';
import 'package:mobile/features/core_hr/constants/hr.constant.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.cubit.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.state.dart';
import 'package:mobile/utils/error.dart';

class DepartmentListPage extends StatefulWidget {
  const DepartmentListPage({super.key});

  @override
  State<DepartmentListPage> createState() => _DepartmentListPageState();
}

class _DepartmentListPageState extends State<DepartmentListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoreHrCubit>().listDepartments();
    });
  }

  Future<void> _onRefresh() async {
    await context.read<CoreHrCubit>().listDepartments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        title: Text(HrConstant.DEPARTMENT_LIST_TITLE, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: BlocBuilder<CoreHrCubit, CoreHrState>(
        buildWhen: (prev, curr) => prev.departmentInfo.status != curr.departmentInfo.status,
        builder: (context, state) {
          final isLoading = state.departmentInfo.status == OperationStatus.loading && state.departments.isEmpty;

          return AppRefresher(
            onRefresh: _onRefresh,
            child: isLoading 
              ? const Center(child: AppLoader()) 
              : state.departments.isEmpty 
                  ? const Center(child: Text('No departments found'))
                  : ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: state.departments.length,
              separatorBuilder: (c, i) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final dept = state.departments[index];
                return Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(border: Border.all(color: AppColors.borderGrey), borderRadius: BorderRadius.circular(12.r)),
                  child: Text(dept.name, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/department-form'),
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.add, color: AppColors.pureWhite),
        label: Text(HrConstant.ADD_DEPARTMENT, style: TextStyle(color: AppColors.pureWhite, fontWeight: FontWeight.w800)),
      ),
    );
  }
}
