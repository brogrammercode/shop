import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/features/business/controllers/business.cubit.dart';
import 'package:mobile/features/business/controllers/business.state.dart';
import 'package:mobile/utils/error.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:fluttertoast/fluttertoast.dart';
class CreateBranchPage extends StatefulWidget {
  const CreateBranchPage({super.key});

  @override
  State<CreateBranchPage> createState() => _CreateBranchPageState();
}

class _CreateBranchPageState extends State<CreateBranchPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  String? _latitude;
  String? _longitude;
  bool _isFetchingLocation = false;

  Future<void> _fetchLocationAndAutofill() async {
    setState(() {
      _isFetchingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Fluttertoast.showToast(msg: 'Please enable location services.');
        await Geolocator.openLocationSettings();
        setState(() => _isFetchingLocation = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Fluttertoast.showToast(msg: 'Location permissions are denied');
          setState(() => _isFetchingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(
            msg: 'Location permissions are permanently denied.');
        setState(() => _isFetchingLocation = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _latitude = position.latitude.toString();
        _longitude = position.longitude.toString();
      });

      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          final street = place.street ?? '';
          final locality = place.locality ?? '';
          _streetController.text = [street, locality]
              .where((s) => s.isNotEmpty)
              .join(', ');
              
          _cityController.text = (place.subAdministrativeArea ?? '').replaceAll(' Division', '');
          _stateController.text = place.administrativeArea ?? '';
          _postalCodeController.text = place.postalCode ?? '';
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to fetch location: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingLocation = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  void _onCreate() {
    if (_nameController.text.trim().isEmpty ||
        _streetController.text.trim().isEmpty ||
        _cityController.text.trim().isEmpty ||
        _stateController.text.trim().isEmpty ||
        _postalCodeController.text.trim().isEmpty) {
      return;
    }
    context.read<BusinessCubit>().initializeBranch({
      'name': _nameController.text.trim(),
      'address': {
        'street': _streetController.text.trim(),
        'city': _cityController.text.trim(),
        'state': _stateController.text.trim(),
        'postal_code': _postalCodeController.text.trim(),
        'latitude': _latitude ?? '',
        'longitude': _longitude ?? '',
      },
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      body: BlocListener<BusinessCubit, BusinessState>(
        listenWhen: (previous, current) =>
            previous.initializeBranchInfo.status !=
            current.initializeBranchInfo.status,
        listener: (context, state) {
          if (state.initializeBranchInfo.status == OperationStatus.success) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (route) => false,
            );
          }
        },
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.h),
                      Text(
                        'REGISTER BUSINESS',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textTertiary,
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildTextField(
                        label: 'Branch Name',
                        controller: _nameController,
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ADDRESS DETAILS',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textTertiary,
                              letterSpacing: 0.8,
                            ),
                          ),
                          GestureDetector(
                            onTap: _isFetchingLocation ? null : _fetchLocationAndAutofill,
                            child: Row(
                              children: [
                                if (_isFetchingLocation)
                                  SizedBox(
                                    width: 12.w,
                                    height: 12.w,
                                    child: const CircularProgressIndicator(
                                      color: AppColors.primaryGreen,
                                      strokeWidth: 2,
                                    ),
                                  )
                                else
                                  Icon(Icons.my_location, color: AppColors.primaryGreen, size: 16.w),
                                SizedBox(width: 4.w),
                                Text(
                                  'Autofill',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _buildTextField(
                        label: 'Street Address',
                        controller: _streetController,
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              label: 'City',
                              controller: _cityController,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _buildTextField(
                              label: 'State',
                              controller: _stateController,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _buildTextField(
                        label: 'Postal Code',
                        controller: _postalCodeController,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 32.h),
                      BlocBuilder<BusinessCubit, BusinessState>(
                        builder: (context, state) {
                          final isLoading =
                              state.initializeBranchInfo.status ==
                              OperationStatus.loading;
                          return SizedBox(
                            width: double.infinity,
                            height: 48.h,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _onCreate,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                elevation: 0,
                              ),
                              child: isLoading
                                  ? SizedBox(
                                      width: 20.w,
                                      height: 20.w,
                                      child: const CircularProgressIndicator(
                                        color: AppColors.pureWhite,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      'Create Branch',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.pureWhite,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.chevron_left,
              color: AppColors.textPrimary,
              size: 28.w,
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            'Create Branch',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 42.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFCCCCCC)),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
            isDense: true,
          ),
        ),
      ),
    );
  }
}
