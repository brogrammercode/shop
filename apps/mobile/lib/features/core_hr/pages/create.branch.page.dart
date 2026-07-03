import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/components/ui/toggle.dart';
import 'package:mobile/components/ui/bottom_action.dart';
import 'package:mobile/features/core_hr/constants/branch.constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.cubit.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.state.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile/services/location_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateBranchPage extends StatefulWidget {
  const CreateBranchPage({super.key});

  @override
  State<CreateBranchPage> createState() => _CreateBranchPageState();
}

class _CreateBranchPageState extends State<CreateBranchPage> {
  final _nameController = TextEditingController();
  bool _isHq = false;
  
  int? _fetchingLocationIndex;
  final LocationService _locationService = LocationService();

  final List<Map<String, TextEditingController>> _addressControllers = [];
  final List<Map<String, TextEditingController>> _bankControllers = [];

  @override
  void initState() {
    super.initState();
    _addAddressBlock();
    _addBankBlock();
  }

  void _addAddressBlock() {
    setState(() {
      _addressControllers.add({
        'area': TextEditingController(),
        'locality': TextEditingController(),
        'city': TextEditingController(),
        'state': TextEditingController(),
        'country': TextEditingController(),
        'pinCode': TextEditingController(),
        'lat': TextEditingController(),
        'long': TextEditingController(),
      });
    });
  }

  void _addBankBlock() {
    setState(() {
      _bankControllers.add({
        'bankName': TextEditingController(),
        'accountName': TextEditingController(),
        'accountNumber': TextEditingController(),
        'ifscCode': TextEditingController(),
        'swiftCode': TextEditingController(),
        'branchName': TextEditingController(),
      });
    });
  }

  void _removeAddressBlock(int index) {
    if (index == 0 || index >= _addressControllers.length) return;
    setState(() {
      final block = _addressControllers.removeAt(index);
      for (var c in block.values) {
        c.dispose();
      }
    });
  }

  void _removeBankBlock(int index) {
    if (index == 0 || index >= _bankControllers.length) return;
    setState(() {
      final block = _bankControllers.removeAt(index);
      for (var c in block.values) {
        c.dispose();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (var addr in _addressControllers) {
      for (var c in addr.values) {
        c.dispose();
      }
    }
    for (var bank in _bankControllers) {
      for (var c in bank.values) {
        c.dispose();
      }
    }
    super.dispose();
  }

  void _onCreate() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      List<Map<String, dynamic>> addresses = [];
      for (var addr in _addressControllers) {
        if (addr['area']!.text.isNotEmpty || addr['city']!.text.isNotEmpty) {
          addresses.add({
            'area': addr['area']!.text.trim(),
            'locality': addr['locality']!.text.trim(),
            'city': addr['city']!.text.trim(),
            'state': addr['state']!.text.trim(),
            'country': addr['country']!.text.trim(),
            'pin_code': addr['pinCode']!.text.trim(),
            if (addr['lat']!.text.isNotEmpty) 'lat': double.tryParse(addr['lat']!.text.trim()),
            if (addr['long']!.text.isNotEmpty) 'long': double.tryParse(addr['long']!.text.trim()),
          });
        }
      }
      List<Map<String, dynamic>> banks = [];
      for (var bank in _bankControllers) {
        if (bank['accountNumber']!.text.isNotEmpty || bank['ifscCode']!.text.isNotEmpty) {
          banks.add({
            'bank_name': bank['bankName']!.text.trim(),
            'account_name': bank['accountName']!.text.trim(),
            'account_number': bank['accountNumber']!.text.trim(),
            'ifsc_code': bank['ifscCode']!.text.trim(),
            'swift_code': bank['swiftCode']!.text.trim(),
            'branch_name': bank['branchName']!.text.trim(),
          });
        }
      }
      context.read<CoreHrCubit>().createBranch(name, _isHq, addresses.isNotEmpty ? addresses : null, banks.isNotEmpty ? banks : null);
    }
  }

  Future<void> _fetchLocation(int index) async {
    setState(() => _fetchingLocationIndex = index);
    final result = await _locationService.getCurrentLocation();
    setState(() => _fetchingLocationIndex = null);
    result.fold(
      (failure) => Fluttertoast.showToast(msg: failure.message),
      (location) {
        final address = _addressControllers[index];
        if (location.street != null) address['area']!.text = location.street!;
        if (location.locality != null) address['locality']!.text = location.locality!;
        if (location.city != null) address['city']!.text = location.city!;
        if (location.state != null) address['state']!.text = location.state!;
        if (location.country != null) address['country']!.text = location.country!;
        if (location.pinCode != null) address['pinCode']!.text = location.pinCode!;
        address['lat']!.text = location.latitude.toString();
        address['long']!.text = location.longitude.toString();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoreHrCubit, CoreHrState>(
      listenWhen: (previous, current) =>
          previous.branchInfo.status != current.branchInfo.status,
      listener: (context, state) {
        if (state.branchInfo.status == OperationStatus.success) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      builder: (context, state) {
        final isLoading = state.branchInfo.status == OperationStatus.loading;
        return Scaffold(
          backgroundColor: AppColors.pureWhite,
          floatingActionButton: AppBottomAction(
            child: AppButton(
              text: BranchConstant.SUBMIT_CREATE_BRANCH,
              isLoading: isLoading,
              onPressed: _onCreate,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(context),
                _buildPageTitle(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 8.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.h),
                        _buildSectionHeader(BranchConstant.BASIC_INFO_SECTION),
                        SizedBox(height: 12.h),
                        AppInput(
                          hintText: BranchConstant.BRANCH_NAME_LABEL,
                          controller: _nameController,
                        ),
                        SizedBox(height: 12.h),
                        AppToggle(
                          label: BranchConstant.IS_HQ_LABEL,
                          value: _isHq,
                          onChanged: (val) => setState(() => _isHq = val),
                        ),

                        SizedBox(height: 32.h),
                        ..._addressControllers.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final addr = entry.value;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionHeaderWithLocation(
                                idx == 0 ? BranchConstant.ADDRESS_SECTION : 'Address ${idx + 1}',
                                idx,
                              ),
                              SizedBox(height: 12.h),
                              AppInput(
                                hintText: BranchConstant.AREA_LABEL,
                                controller: addr['area'],
                              ),
                              SizedBox(height: 12.h),
                              AppInput(
                                hintText: BranchConstant.LOCALITY_LABEL,
                                controller: addr['locality'],
                              ),
                              SizedBox(height: 12.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: AppInput(
                                      hintText: BranchConstant.CITY_LABEL,
                                      controller: addr['city'],
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: AppInput(
                                      hintText: BranchConstant.STATE_LABEL,
                                      controller: addr['state'],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: AppInput(
                                      hintText: BranchConstant.COUNTRY_LABEL,
                                      controller: addr['country'],
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: AppInput(
                                      hintText: BranchConstant.PIN_CODE_LABEL,
                                      controller: addr['pinCode'],
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24.h),
                              if (idx > 0)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () => _removeAddressBlock(idx),
                                    child: Text(
                                      'Remove',
                                      style: TextStyle(
                                        color: AppColors.error,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              if (idx > 0) SizedBox(height: 12.h),
                            ],
                          );
                        }),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: _addAddressBlock,
                            icon: Icon(Icons.add, color: AppColors.primaryGreen, size: 16.w),
                            label: Text(
                              'Add Address',
                              style: TextStyle(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.w700,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 16.h),
                        ..._bankControllers.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final bank = entry.value;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionHeader(idx == 0 ? BranchConstant.BANK_SECTION : 'Bank Detail ${idx + 1}'),
                              SizedBox(height: 12.h),
                              AppInput(
                                hintText: BranchConstant.BANK_NAME_LABEL,
                                controller: bank['bankName'],
                              ),
                              SizedBox(height: 12.h),
                              AppInput(
                                hintText: BranchConstant.ACCOUNT_NAME_LABEL,
                                controller: bank['accountName'],
                              ),
                              SizedBox(height: 12.h),
                              AppInput(
                                hintText: BranchConstant.ACCOUNT_NUMBER_LABEL,
                                controller: bank['accountNumber'],
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(height: 12.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: AppInput(
                                      hintText: BranchConstant.IFSC_CODE_LABEL,
                                      controller: bank['ifscCode'],
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: AppInput(
                                      hintText: BranchConstant.SWIFT_CODE_LABEL,
                                      controller: bank['swiftCode'],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              AppInput(
                                hintText: BranchConstant.BANK_BRANCH_LABEL,
                                controller: bank['branchName'],
                              ),
                              SizedBox(height: 24.h),
                              if (idx > 0)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () => _removeBankBlock(idx),
                                    child: Text(
                                      'Remove',
                                      style: TextStyle(
                                        color: AppColors.error,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              if (idx > 0) SizedBox(height: 12.h),
                            ],
                          );
                        }),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: _addBankBlock,
                            icon: Icon(Icons.add, color: AppColors.primaryGreen, size: 16.w),
                            label: Text(
                              'Add Bank Detail',
                              style: TextStyle(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.w700,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 100.h),
                      ],
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

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24.w),
      ),
    );
  }

  Widget _buildPageTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            BranchConstant.CREATE_BRANCH_HEADER,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 4.h),
          Container(height: 1.h, color: AppColors.borderGrey),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textTertiary,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildSectionHeaderWithLocation(String title, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textTertiary,
            letterSpacing: 0.8,
          ),
        ),
        GestureDetector(
          onTap: _fetchingLocationIndex != null ? null : () => _fetchLocation(index),
          child: Row(
            children: [
              if (_fetchingLocationIndex == index)
                SizedBox(
                  width: 12.w,
                  height: 12.w,
                  child: const CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryGreen),
                )
              else
                Icon(Icons.my_location, size: 14.w, color: AppColors.primaryGreen),
              SizedBox(width: 4.w),
              Text(
                'Use Current Location',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
