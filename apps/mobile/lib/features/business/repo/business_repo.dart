import 'package:mobile/features/business/models/branch_input_model.dart';
import 'package:mobile/features/business/models/branch_model.dart';
import 'package:mobile/features/business/models/business_context_model.dart';
import 'package:mobile/features/business/models/business_input_model.dart';
import 'package:mobile/features/business/models/business_join_request_model.dart';
import 'package:mobile/features/business/models/business_model.dart';
import 'package:mobile/features/business/constants/business.dart';
import 'package:mobile/features/business/repo/business_endpoints.dart';
import 'package:mobile/services/api_client.dart';
import 'package:mobile/services/local_storage.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile/utils/try_catch.dart';

class BusinessRepo {
  final ApiClient _apiClient;
  final LocalStorage _localStorage;

  BusinessRepo({
    required ApiClient apiClient,
    required LocalStorage localStorage,
  }) : _apiClient = apiClient,
       _localStorage = localStorage;

  TaskResult<BusinessContextModel> initializeBusiness({
    required BusinessInputModel business,
    required BranchInputModel branch,
  }) async {
    return tryCatchAsync(() async {
      await _apiClient.post(
        BusinessEndpoints.initialize,
        data: {'business': business.toJson(), 'branch': branch.toJson()},
      );

      final context = await _getContext();
      await _localStorage.saveBusinessContext(context);
      return context;
    });
  }

  TaskResult<BusinessContextModel> getCurrentContext() async {
    return tryCatchAsync(() async {
      final context = await _getContext();
      await _localStorage.saveBusinessContext(context);
      return context;
    });
  }

  TaskResult<BusinessContextModel> getCachedContext() async {
    return tryCatchAsync(() async {
      final context = await _localStorage.getBusinessContext();
      if (context == null) {
        throw const CacheException(BusinessConstants.businessContextNotFound);
      }

      return context;
    });
  }

  TaskResult<List<BusinessModel>> searchBusinesses(String query) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(
        BusinessEndpoints.search,
        queryParameters: {'q': query},
      );
      final data = _unwrapResponseData(response.data);
      return (data as List<dynamic>? ?? [])
          .map<BusinessModel>(
            (item) => BusinessModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    });
  }

  TaskResult<List<BranchModel>> getBranches(String business_id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(
        BusinessEndpoints.branches,
        queryParameters: {'business_id': business_id},
      );
      final data = _unwrapResponseData(response.data);
      return (data as List<dynamic>? ?? [])
          .map<BranchModel>(
            (item) => BranchModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    });
  }

  TaskResult<BusinessJoinRequestModel> requestToJoin(String branch_id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(
        BusinessEndpoints.joinRequests,
        data: {'branch_id': branch_id},
      );
      final data = _unwrapResponseData(response.data);
      return BusinessJoinRequestModel.fromJson(Map<String, dynamic>.from(data));
    });
  }

  TaskResult<List<BusinessJoinRequestModel>> getMyJoinRequests() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(BusinessEndpoints.myJoinRequests);
      final data = _unwrapResponseData(response.data);
      return _parseJoinRequests(data);
    });
  }

  TaskResult<List<BusinessJoinRequestModel>> getJoinRequests(
    String branch_id,
  ) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(
        BusinessEndpoints.joinRequests,
        queryParameters: {'branch_id': branch_id},
      );
      final data = _unwrapResponseData(response.data);
      return _parseJoinRequests(data);
    });
  }

  TaskResult<BusinessJoinRequestModel> approveJoinRequest(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(
        BusinessEndpoints.approveJoinRequest(id),
      );
      final data = _unwrapResponseData(response.data);
      final requestData =
          data is Map<String, dynamic> && data['request'] != null
          ? data['request']
          : data;
      return BusinessJoinRequestModel.fromJson(
        Map<String, dynamic>.from(requestData),
      );
    });
  }

  TaskResult<BusinessJoinRequestModel> rejectJoinRequest(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(
        BusinessEndpoints.rejectJoinRequest(id),
      );
      final data = _unwrapResponseData(response.data);
      return BusinessJoinRequestModel.fromJson(Map<String, dynamic>.from(data));
    });
  }

  Future<BusinessContextModel> _getContext() async {
    final response = await _apiClient.get(BusinessEndpoints.context);
    final data = _unwrapResponseData(response.data);
    return BusinessContextModel.fromJson(Map<String, dynamic>.from(data));
  }

  dynamic _unwrapResponseData(dynamic responseData) {
    if (responseData is Map<String, dynamic> &&
        responseData.containsKey('data')) {
      return responseData['data'];
    }

    return responseData;
  }

  List<BusinessJoinRequestModel> _parseJoinRequests(dynamic data) {
    return (data as List<dynamic>? ?? [])
        .map<BusinessJoinRequestModel>(
          (item) => BusinessJoinRequestModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }
}
