import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/business/constants/business.dart';
import 'package:mobile/features/business/cubit/business_state.dart';
import 'package:mobile/features/business/models/branch_input_model.dart';
import 'package:mobile/features/business/models/business_input_model.dart';
import 'package:mobile/features/business/repo/business_repo.dart';
import 'package:mobile/utils/error.dart';

class BusinessCubit extends Cubit<BusinessState> {
  final BusinessRepo _businessRepo;

  BusinessCubit(this._businessRepo) : super(const BusinessState());

  void setPendingBusiness(BusinessInputModel business) {
    emit(state.copyWith(pendingBusiness: business));
  }

  Future<void> initializeBusiness(BranchInputModel branch) async {
    final business = state.pendingBusiness;
    if (business == null) {
      emit(
        state.copyWith(
          initializeInfo: const OperationInfo(
            status: OperationStatus.error,
            error: ValidationFailure(BusinessConstants.unableToReadSetup),
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        initializeInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _businessRepo.initializeBusiness(
      business: business,
      branch: branch,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          initializeInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (context) => emit(
        state.copyWith(
          context: context,
          initializeInfo: const OperationInfo(status: OperationStatus.success),
        ),
      ),
    );
  }

  Future<void> getCurrentContext() async {
    emit(
      state.copyWith(
        contextInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _businessRepo.getCurrentContext();

    result.fold(
      (failure) => emit(
        state.copyWith(
          contextInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (context) => emit(
        state.copyWith(
          context: context,
          contextInfo: const OperationInfo(status: OperationStatus.success),
        ),
      ),
    );
  }

  Future<void> getCachedContext() async {
    final result = await _businessRepo.getCachedContext();

    result.fold(
      (failure) => null,
      (context) => emit(state.copyWith(context: context)),
    );
  }

  Future<void> searchBusinesses(String query) async {
    if (query.trim().isEmpty) {
      emit(
        state.copyWith(
          searchResults: const [],
          searchInfo: const OperationInfo(status: OperationStatus.initial),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        searchInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _businessRepo.searchBusinesses(query);

    result.fold(
      (failure) => emit(
        state.copyWith(
          searchInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (businesses) => emit(
        state.copyWith(
          searchResults: businesses,
          searchInfo: const OperationInfo(status: OperationStatus.success),
        ),
      ),
    );
  }

  Future<void> getBranches(String business_id) async {
    emit(
      state.copyWith(
        branchInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _businessRepo.getBranches(business_id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          branchInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (branches) {
        final branchesByBusiness = Map.of(state.branchesByBusiness);
        branchesByBusiness[business_id] = branches;
        emit(
          state.copyWith(
            branchesByBusiness: branchesByBusiness,
            branchInfo: const OperationInfo(status: OperationStatus.success),
          ),
        );
      },
    );
  }

  Future<void> requestToJoin(String branch_id) async {
    emit(
      state.copyWith(
        joinRequestInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _businessRepo.requestToJoin(branch_id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          joinRequestInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (request) => emit(
        state.copyWith(
          myJoinRequests: [request, ...state.myJoinRequests],
          joinRequestInfo: const OperationInfo(status: OperationStatus.success),
        ),
      ),
    );
  }

  Future<void> getMyJoinRequests() async {
    emit(
      state.copyWith(
        myJoinRequestsInfo: const OperationInfo(
          status: OperationStatus.loading,
        ),
      ),
    );

    final result = await _businessRepo.getMyJoinRequests();

    result.fold(
      (failure) => emit(
        state.copyWith(
          myJoinRequestsInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (requests) => emit(
        state.copyWith(
          myJoinRequests: requests,
          myJoinRequestsInfo: const OperationInfo(
            status: OperationStatus.success,
          ),
        ),
      ),
    );
  }

  Future<void> getPendingJoinRequests() async {
    final context = state.context;
    if (context == null || !canReviewJoinRequests) {
      return;
    }

    emit(
      state.copyWith(
        pendingJoinRequestsInfo: const OperationInfo(
          status: OperationStatus.loading,
        ),
      ),
    );

    final result = await _businessRepo.getJoinRequests(context.branch.id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          pendingJoinRequestsInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (requests) => emit(
        state.copyWith(
          pendingJoinRequests: requests,
          pendingJoinRequestsInfo: const OperationInfo(
            status: OperationStatus.success,
          ),
        ),
      ),
    );
  }

  Future<void> approveJoinRequest(String id) async {
    emit(
      state.copyWith(
        joinApprovalInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _businessRepo.approveJoinRequest(id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          joinApprovalInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (_) => emit(
        state.copyWith(
          pendingJoinRequests: state.pendingJoinRequests
              .where((request) => request.id != id)
              .toList(),
          joinApprovalInfo: const OperationInfo(
            status: OperationStatus.success,
          ),
        ),
      ),
    );
  }

  Future<void> rejectJoinRequest(String id) async {
    emit(
      state.copyWith(
        joinApprovalInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _businessRepo.rejectJoinRequest(id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          joinApprovalInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (_) => emit(
        state.copyWith(
          pendingJoinRequests: state.pendingJoinRequests
              .where((request) => request.id != id)
              .toList(),
          joinApprovalInfo: const OperationInfo(
            status: OperationStatus.success,
          ),
        ),
      ),
    );
  }

  bool get canReviewJoinRequests {
    final permissions = state.context?.permissions ?? const [];
    return permissions.contains(BusinessConstants.allPermission) ||
        permissions.contains(BusinessConstants.employeeWritePermission);
  }
}
