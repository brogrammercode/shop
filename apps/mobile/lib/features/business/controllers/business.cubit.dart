import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile/utils/error.dart';
import '../repo/business_repo.dart';
import 'business.state.dart';
import '../constants/business.constant.dart';

class BusinessCubit extends Cubit<BusinessState> {
  final BusinessRepo _businessRepo;

  BusinessCubit({required BusinessRepo businessRepo})
      : _businessRepo = businessRepo,
        super(const BusinessState());

  Future<void> searchBranches(String query) async {
    emit(state.copyWith(searchInfo: const OperationInfo(status: OperationStatus.loading)));
    
    final result = await _businessRepo.searchBranches(query);
    
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(
          searchInfo: OperationInfo(status: OperationStatus.error, error: failure),
        ));
      },
      (branches) {
        emit(state.copyWith(
          searchResults: branches,
          searchInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> getMyJoinRequests() async {
    emit(state.copyWith(getMyRequestsInfo: const OperationInfo(status: OperationStatus.loading)));
    
    final result = await _businessRepo.getMyJoinRequests();
    
    result.fold(
      (failure) {
        emit(state.copyWith(
          getMyRequestsInfo: OperationInfo(status: OperationStatus.error, error: failure),
        ));
      },
      (requests) {
        emit(state.copyWith(
          myJoinRequests: requests,
          getMyRequestsInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> requestJoin(String branchId) async {
    final pendingRequests = state.myJoinRequests?.where((r) => r.status == 'PENDING').toList() ?? [];
    if (pendingRequests.isNotEmpty) {
      Fluttertoast.showToast(msg: BusinessConstant.withdrawPreviousRequestFirst);
      return;
    }

    emit(state.copyWith(requestJoinInfo: const OperationInfo(status: OperationStatus.loading)));
    
    final result = await _businessRepo.requestJoin(branchId);
    
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(
          requestJoinInfo: OperationInfo(status: OperationStatus.error, error: failure),
        ));
      },
      (request) {
        Fluttertoast.showToast(msg: BusinessConstant.joinRequestSuccess);
        final updatedRequests = List.of(state.myJoinRequests ?? <dynamic>[])
          ..insert(0, request);
        emit(state.copyWith(
          myJoinRequests: updatedRequests.cast(),
          requestJoinInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> withdrawJoinRequest(String requestId) async {
    emit(state.copyWith(withdrawJoinInfo: const OperationInfo(status: OperationStatus.loading)));
    
    final result = await _businessRepo.withdrawJoinRequest(requestId);
    
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(
          withdrawJoinInfo: OperationInfo(status: OperationStatus.error, error: failure),
        ));
      },
      (_) {
        Fluttertoast.showToast(msg: BusinessConstant.withdrawRequestSuccess);
        final updatedRequests = state.myJoinRequests?.where((r) => r.id != requestId).toList() ?? [];
        emit(state.copyWith(
          myJoinRequests: updatedRequests,
          withdrawJoinInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> initializeBranch(Map<String, dynamic> data) async {
    emit(state.copyWith(initializeBranchInfo: const OperationInfo(status: OperationStatus.loading)));
    
    final result = await _businessRepo.initializeBranch(data);
    
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(
          initializeBranchInfo: OperationInfo(status: OperationStatus.error, error: failure),
        ));
      },
      (_) {
        Fluttertoast.showToast(msg: BusinessConstant.createBranchSuccess);
        emit(state.copyWith(
          initializeBranchInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }
}
