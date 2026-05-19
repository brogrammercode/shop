import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/features/business/constants/business.dart';
import 'package:mobile/features/business/cubit/business_cubit.dart';
import 'package:mobile/features/business/models/business_input_model.dart';

class CreateBusinessPage extends StatefulWidget {
  const CreateBusinessPage({super.key});

  @override
  State<CreateBusinessPage> createState() => _CreateBusinessPageState();
}

class _CreateBusinessPageState extends State<CreateBusinessPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          BusinessConstants.createBusiness,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                BusinessConstants.createBusinessTitle,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 12.h),
              Text(
                BusinessConstants.createBusinessSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 36.h),
              AppInput(
                hintText: BusinessConstants.businessNameHint,
                controller: _nameController,
                prefixIcon: const Icon(
                  Icons.storefront,
                  color: AppColors.primaryIndigo,
                ),
              ),
              SizedBox(height: 16.h),
              AppInput(
                hintText: BusinessConstants.businessEmailHint,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(
                  Icons.mail_outline,
                  color: AppColors.primaryIndigo,
                ),
              ),
              SizedBox(height: 16.h),
              AppInput(
                hintText: BusinessConstants.businessPhoneHint,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(
                  Icons.call_outlined,
                  color: AppColors.primaryIndigo,
                ),
              ),
              SizedBox(height: 16.h),
              AppInput(
                hintText: BusinessConstants.businessAddressHint,
                controller: _addressController,
                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primaryIndigo,
                ),
              ),
              SizedBox(height: 36.h),
              AppButton(
                text: BusinessConstants.continueText,
                onPressed: _continueToBranchSetup,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _continueToBranchSetup() {
    final business = BusinessInputModel(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
    );

    if (business.name.isEmpty) {
      _showMessage(BusinessConstants.requiredFieldMessage);
      return;
    }

    context.read<BusinessCubit>().setPendingBusiness(business);
    Navigator.pushNamed(context, AppRoutes.createBranch, arguments: business);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
