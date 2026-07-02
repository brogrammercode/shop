import 'package:mobile/utils/error.dart';
import 'package:mobile/features/crm/coupon.model.dart';
import 'package:mobile/features/crm/complaint.model.dart';

class CrmState {
  final List<CouponModel> coupons;
  final CouponModel? selectedCoupon;
  final List<ComplaintModel> complaints;
  final ComplaintModel? selectedComplaint;
  final dynamic customerLoyalty;

  final OperationInfo loadCouponsInfo;
  final OperationInfo saveCouponsInfo;
  final OperationInfo loadLoyaltyInfo;
  final OperationInfo saveLoyaltyInfo;
  final OperationInfo loadComplaintsInfo;
  final OperationInfo saveComplaintsInfo;

  const CrmState({
    this.coupons = const [],
    this.selectedCoupon,
    this.complaints = const [],
    this.selectedComplaint,
    this.customerLoyalty,
    this.loadCouponsInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveCouponsInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadLoyaltyInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveLoyaltyInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadComplaintsInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveComplaintsInfo = const OperationInfo(status: OperationStatus.initial),
  });

  CrmState copyWith({
    List<CouponModel>? coupons,
    CouponModel? selectedCoupon,
    List<ComplaintModel>? complaints,
    ComplaintModel? selectedComplaint,
    dynamic customerLoyalty,
    OperationInfo? loadCouponsInfo,
    OperationInfo? saveCouponsInfo,
    OperationInfo? loadLoyaltyInfo,
    OperationInfo? saveLoyaltyInfo,
    OperationInfo? loadComplaintsInfo,
    OperationInfo? saveComplaintsInfo,
  }) {
    return CrmState(
      coupons: coupons ?? this.coupons,
      selectedCoupon: selectedCoupon ?? this.selectedCoupon,
      complaints: complaints ?? this.complaints,
      selectedComplaint: selectedComplaint ?? this.selectedComplaint,
      customerLoyalty: customerLoyalty ?? this.customerLoyalty,
      loadCouponsInfo: loadCouponsInfo ?? this.loadCouponsInfo,
      saveCouponsInfo: saveCouponsInfo ?? this.saveCouponsInfo,
      loadLoyaltyInfo: loadLoyaltyInfo ?? this.loadLoyaltyInfo,
      saveLoyaltyInfo: saveLoyaltyInfo ?? this.saveLoyaltyInfo,
      loadComplaintsInfo: loadComplaintsInfo ?? this.loadComplaintsInfo,
      saveComplaintsInfo: saveComplaintsInfo ?? this.saveComplaintsInfo,
    );
  }
}
