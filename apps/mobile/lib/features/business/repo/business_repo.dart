import 'package:mobile/services/api_client.dart';
import 'package:mobile/utils/try_catch.dart';
import '../models/business_context.dart';
import '../models/branch.dart';
import '../models/business_join_request.dart';
import '../constants/business.endpoints.dart';
import '../constants/business.params.dart';

class BusinessRepo {
  final ApiClient _apiClient;

  BusinessRepo({required ApiClient apiClient}) : _apiClient = apiClient;

  TaskResult<BusinessContextModel> getContext() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(BusinessEndpoints.context);
      final data = response.data[BusinessParams.dataKey];
      return BusinessContextModel.fromJson(data);
    });
  }

  TaskResult<List<BranchModel>> searchBranches(String query) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(
        BusinessEndpoints.search,
        queryParams: {BusinessParams.queryKey: query},
      );
      final list = response.data[BusinessParams.dataKey] as List;
      return list.map((json) => BranchModel.fromJson(json)).toList();
    });
  }

  TaskResult<List<BusinessJoinRequestModel>> getMyJoinRequests() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(BusinessEndpoints.joinRequestsMe);
      final list = response.data[BusinessParams.dataKey] as List;
      return list.map((json) => BusinessJoinRequestModel.fromJson(json)).toList();
    });
  }

  TaskResult<BusinessJoinRequestModel> requestJoin(String branchId) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(
        BusinessEndpoints.joinRequests,
        data: {BusinessParams.branchIdKey: branchId},
      );
      final data = response.data[BusinessParams.dataKey];
      return BusinessJoinRequestModel.fromJson(data);
    });
  }

  TaskResult<void> withdrawJoinRequest(String requestId) async {
    return tryCatchAsync(() async {
      await _apiClient.delete('${BusinessEndpoints.joinRequests}/$requestId');
    });
  }

  TaskResult<void> initializeBranch(Map<String, dynamic> branchData) async {
    return tryCatchAsync(() async {
      await _apiClient.post(
        BusinessEndpoints.initialize,
        data: {BusinessParams.branchKey: branchData},
      );
    });
  }
}
