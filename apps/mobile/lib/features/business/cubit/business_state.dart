import 'package:mobile/features/business/models/business_context_model.dart';
import 'package:mobile/features/business/models/business_input_model.dart';
import 'package:mobile/features/business/models/business_join_request_model.dart';
import 'package:mobile/features/business/models/business_model.dart';
import 'package:mobile/features/business/models/branch_model.dart';
import 'package:mobile/utils/error.dart';

class BusinessState {
  final BusinessInputModel? pendingBusiness;
  final BusinessContextModel? context;
  final List<BusinessModel> searchResults;
  final Map<String, List<BranchModel>> branchesByBusiness;
  final List<BusinessJoinRequestModel> myJoinRequests;
  final List<BusinessJoinRequestModel> pendingJoinRequests;
  final OperationInfo initializeInfo;
  final OperationInfo contextInfo;
  final OperationInfo searchInfo;
  final OperationInfo branchInfo;
  final OperationInfo joinRequestInfo;
  final OperationInfo myJoinRequestsInfo;
  final OperationInfo pendingJoinRequestsInfo;
  final OperationInfo joinApprovalInfo;

  const BusinessState({
    this.pendingBusiness,
    this.context,
    this.searchResults = const [],
    this.branchesByBusiness = const {},
    this.myJoinRequests = const [],
    this.pendingJoinRequests = const [],
    this.initializeInfo = const OperationInfo(status: OperationStatus.initial),
    this.contextInfo = const OperationInfo(status: OperationStatus.initial),
    this.searchInfo = const OperationInfo(status: OperationStatus.initial),
    this.branchInfo = const OperationInfo(status: OperationStatus.initial),
    this.joinRequestInfo = const OperationInfo(status: OperationStatus.initial),
    this.myJoinRequestsInfo = const OperationInfo(
      status: OperationStatus.initial,
    ),
    this.pendingJoinRequestsInfo = const OperationInfo(
      status: OperationStatus.initial,
    ),
    this.joinApprovalInfo = const OperationInfo(
      status: OperationStatus.initial,
    ),
  });

  BusinessState copyWith({
    BusinessInputModel? pendingBusiness,
    BusinessContextModel? context,
    List<BusinessModel>? searchResults,
    Map<String, List<BranchModel>>? branchesByBusiness,
    List<BusinessJoinRequestModel>? myJoinRequests,
    List<BusinessJoinRequestModel>? pendingJoinRequests,
    OperationInfo? initializeInfo,
    OperationInfo? contextInfo,
    OperationInfo? searchInfo,
    OperationInfo? branchInfo,
    OperationInfo? joinRequestInfo,
    OperationInfo? myJoinRequestsInfo,
    OperationInfo? pendingJoinRequestsInfo,
    OperationInfo? joinApprovalInfo,
  }) {
    return BusinessState(
      pendingBusiness: pendingBusiness ?? this.pendingBusiness,
      context: context ?? this.context,
      searchResults: searchResults ?? this.searchResults,
      branchesByBusiness: branchesByBusiness ?? this.branchesByBusiness,
      myJoinRequests: myJoinRequests ?? this.myJoinRequests,
      pendingJoinRequests: pendingJoinRequests ?? this.pendingJoinRequests,
      initializeInfo: initializeInfo ?? this.initializeInfo,
      contextInfo: contextInfo ?? this.contextInfo,
      searchInfo: searchInfo ?? this.searchInfo,
      branchInfo: branchInfo ?? this.branchInfo,
      joinRequestInfo: joinRequestInfo ?? this.joinRequestInfo,
      myJoinRequestsInfo: myJoinRequestsInfo ?? this.myJoinRequestsInfo,
      pendingJoinRequestsInfo:
          pendingJoinRequestsInfo ?? this.pendingJoinRequestsInfo,
      joinApprovalInfo: joinApprovalInfo ?? this.joinApprovalInfo,
    );
  }
}
