import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile/features/crm/crm.repo.dart';
import 'package:mobile/features/crm/crm.state.dart';

class CrmCubit extends Cubit<CrmState> {
  final CrmRepo _repo;

  CrmCubit({required CrmRepo repo})
      : _repo = repo,
        super(const CrmState());

  Future<void> listCoupons() async {
    emit(state.copyWith(loadCouponsInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.listCoupons();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadCouponsInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (coupons) {
        emit(state.copyWith(
          coupons: coupons,
          loadCouponsInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> createCoupon(Map<String, dynamic> data) async {
    emit(state.copyWith(saveCouponsInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.createCoupon(data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(saveCouponsInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Coupon created');
        emit(state.copyWith(saveCouponsInfo: const OperationInfo(status: OperationStatus.success)));
        listCoupons();
      },
    );
  }

  Future<void> getLoyaltyByCustomer(String customerId) async {
    emit(state.copyWith(loadLoyaltyInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.getLoyaltyByCustomer(customerId);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadLoyaltyInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (data) {
        emit(state.copyWith(
          customerLoyalty: data,
          loadLoyaltyInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> createLoyaltyTransaction(Map<String, dynamic> data) async {
    emit(state.copyWith(saveLoyaltyInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.createLoyaltyTransaction(data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(saveLoyaltyInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Loyalty transaction recorded');
        emit(state.copyWith(saveLoyaltyInfo: const OperationInfo(status: OperationStatus.success)));
        if (data.containsKey('customer_id')) {
          getLoyaltyByCustomer(data['customer_id']);
        }
      },
    );
  }

  Future<void> listComplaints() async {
    emit(state.copyWith(loadComplaintsInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.listComplaints();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadComplaintsInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (complaints) {
        emit(state.copyWith(
          complaints: complaints,
          loadComplaintsInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> createComplaint(Map<String, dynamic> data) async {
    emit(state.copyWith(saveComplaintsInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.createComplaint(data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(saveComplaintsInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Complaint recorded');
        emit(state.copyWith(saveComplaintsInfo: const OperationInfo(status: OperationStatus.success)));
        listComplaints();
      },
    );
  }

  Future<void> updateComplaintStatus(String id, Map<String, dynamic> data) async {
    emit(state.copyWith(saveComplaintsInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.updateComplaintStatus(id, data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(saveComplaintsInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Complaint status updated');
        emit(state.copyWith(saveComplaintsInfo: const OperationInfo(status: OperationStatus.success)));
        listComplaints();
      },
    );
  }
}
