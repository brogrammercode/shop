import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/features/business/constants/business.dart';
import 'package:mobile/features/business/cubit/business_cubit.dart';
import 'package:mobile/features/business/cubit/business_state.dart';
import 'package:mobile/features/business/models/branch_input_model.dart';
import 'package:mobile/features/business/models/business_input_model.dart';
import 'package:mobile/utils/error.dart';

class CreateBranchPage extends StatefulWidget {
  const CreateBranchPage({super.key});

  @override
  State<CreateBranchPage> createState() => _CreateBranchPageState();
}

class _CreateBranchPageState extends State<CreateBranchPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)?.settings.arguments;
    final pendingBusiness = context
        .watch<BusinessCubit>()
        .state
        .pendingBusiness;
    final business = argument is BusinessInputModel
        ? argument
        : pendingBusiness;

    return Scaffold(
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
          BusinessConstants.branchTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: business != null
            ? _CreateBranchBody(
                business: business,
                nameController: _nameController,
                addressController: _addressController,
              )
            : const _InvalidSetupBody(),
      ),
    );
  }
}

class _CreateBranchBody extends StatelessWidget {
  final BusinessInputModel business;
  final TextEditingController nameController;
  final TextEditingController addressController;

  const _CreateBranchBody({
    required this.business,
    required this.nameController,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BusinessCubit, BusinessState>(
      listenWhen: (previous, current) =>
          previous.initializeInfo.status != current.initializeInfo.status,
      listener: (context, state) {
        if (state.initializeInfo.status == OperationStatus.success) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.dashboard,
            (route) => false,
            arguments: state.context,
          );
        }

        if (state.initializeInfo.status == OperationStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.initializeInfo.error?.message ??
                    BusinessConstants.requiredFieldMessage,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading =
            state.initializeInfo.status == OperationStatus.loading;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                BusinessConstants.branchTitle,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 12.h),
              Text(
                BusinessConstants.branchSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 36.h),
              AppInput(
                hintText: BusinessConstants.branchNameHint,
                controller: nameController,
                prefixIcon: const Icon(
                  Icons.apartment,
                  color: AppColors.primaryIndigo,
                ),
              ),
              SizedBox(height: 16.h),
              AppInput(
                hintText: BusinessConstants.branchAddressHint,
                controller: addressController,
                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primaryIndigo,
                ),
              ),
              SizedBox(height: 36.h),
              AppButton(
                text: isLoading
                    ? BusinessConstants.completingSetup
                    : BusinessConstants.completeSetup,
                onPressed: isLoading
                    ? () {}
                    : () {
                        final branch = BranchInputModel(
                          name: nameController.text.trim(),
                          address: addressController.text.trim(),
                        );

                        if (branch.name.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                BusinessConstants.requiredFieldMessage,
                              ),
                            ),
                          );
                          return;
                        }

                        context.read<BusinessCubit>().setPendingBusiness(
                          business,
                        );
                        context.read<BusinessCubit>().initializeBusiness(
                          branch,
                        );
                      },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InvalidSetupBody extends StatelessWidget {
  const _InvalidSetupBody();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            BusinessConstants.unableToReadSetup,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 24.h),
          AppButton(
            text: BusinessConstants.createBusiness,
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.createBusiness);
            },
          ),
        ],
      ),
    );
  }
}
