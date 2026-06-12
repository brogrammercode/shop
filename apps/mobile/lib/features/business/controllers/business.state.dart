import 'package:mobile/utils/error.dart';
import '../models/branch.dart';
import '../models/business_join_request.dart';

class BusinessState {
  final List<BranchModel>? searchResults;
  final List<BusinessJoinRequestModel>? myJoinRequests;
  final OperationInfo searchInfo;
  final OperationInfo requestJoinInfo;
  final OperationInfo withdrawJoinInfo;
  final OperationInfo getMyRequestsInfo;
  final OperationInfo initializeBranchInfo;

  const BusinessState({
    this.searchResults,
    this.myJoinRequests,
    this.searchInfo = const OperationInfo(status: OperationStatus.initial),
    this.requestJoinInfo = const OperationInfo(status: OperationStatus.initial),
    this.withdrawJoinInfo = const OperationInfo(status: OperationStatus.initial),
    this.getMyRequestsInfo = const OperationInfo(status: OperationStatus.initial),
    this.initializeBranchInfo = const OperationInfo(status: OperationStatus.initial),
  });

  BusinessState copyWith({
    List<BranchModel>? searchResults,
    List<BusinessJoinRequestModel>? myJoinRequests,
    OperationInfo? searchInfo,
    OperationInfo? requestJoinInfo,
    OperationInfo? withdrawJoinInfo,
    OperationInfo? getMyRequestsInfo,
    OperationInfo? initializeBranchInfo,
  }) {
    return BusinessState(
      searchResults: searchResults ?? this.searchResults,
      myJoinRequests: myJoinRequests ?? this.myJoinRequests,
      searchInfo: searchInfo ?? this.searchInfo,
      requestJoinInfo: requestJoinInfo ?? this.requestJoinInfo,
      withdrawJoinInfo: withdrawJoinInfo ?? this.withdrawJoinInfo,
      getMyRequestsInfo: getMyRequestsInfo ?? this.getMyRequestsInfo,
      initializeBranchInfo: initializeBranchInfo ?? this.initializeBranchInfo,
    );
  }
}
