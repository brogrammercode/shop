import 'package:mobile/features/business/constants/business.endpoints.dart';
import 'package:mobile/features/business/models/branch.dart';
import 'package:mobile/features/business/models/employee.dart';
import 'package:mobile/features/business/models/department.dart';
import 'package:mobile/features/business/models/post.dart';
import 'package:mobile/features/business/models/role.dart';
import 'package:mobile/features/business/models/shift.dart';
import 'package:mobile/features/business/models/business_join_request.dart';
import 'package:mobile/features/business/models/business_context.dart';
import 'package:mobile/services/api_client.dart';
import 'package:mobile/utils/try_catch.dart';

class BusinessRepo {
  final ApiClient _apiClient;

  BusinessRepo({required ApiClient apiClient}) : _apiClient = apiClient;

  TaskResult<BusinessContextModel> getContext() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(BusinessEndpoints.context);
      final data = response.data['data'] ?? response.data;
      return BusinessContextModel.fromJson(data);
    });
  }

  TaskResult<List<BranchModel>> getBranches() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(BusinessEndpoints.branches);
      final list = response.data['data'] as List;
      return list.map((item) => BranchModel.fromJson(item)).toList();
    });
  }

  TaskResult<void> createBranch(BranchModel branch) async {
    return tryCatchAsync(() async {
      await _apiClient.post(BusinessEndpoints.branches, data: branch.toJson());
    });
  }

  TaskResult<List<EmployeeModel>> getEmployees() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(BusinessEndpoints.employees);
      final list = response.data['data'] as List;
      return list.map((item) => EmployeeModel.fromJson(item)).toList();
    });
  }

  TaskResult<void> createEmployee(EmployeeModel employee) async {
    return tryCatchAsync(() async {
      await _apiClient.post(BusinessEndpoints.employees, data: employee.toJson());
    });
  }

  TaskResult<List<DepartmentModel>> getDepartments() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(BusinessEndpoints.departments);
      final list = response.data['data'] as List;
      return list.map((item) => DepartmentModel.fromJson(item)).toList();
    });
  }

  TaskResult<void> createDepartment(DepartmentModel department) async {
    return tryCatchAsync(() async {
      await _apiClient.post(BusinessEndpoints.departments, data: department.toJson());
    });
  }

  TaskResult<List<PostModel>> getPosts() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(BusinessEndpoints.posts);
      final list = response.data['data'] as List;
      return list.map((item) => PostModel.fromJson(item)).toList();
    });
  }

  TaskResult<void> createPost(PostModel post) async {
    return tryCatchAsync(() async {
      await _apiClient.post(BusinessEndpoints.posts, data: post.toJson());
    });
  }

  TaskResult<List<RoleModel>> getRoles() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(BusinessEndpoints.roles);
      final list = response.data['data'] as List;
      return list.map((item) => RoleModel.fromJson(item)).toList();
    });
  }

  TaskResult<void> createRole(RoleModel role) async {
    return tryCatchAsync(() async {
      await _apiClient.post(BusinessEndpoints.roles, data: role.toJson());
    });
  }

  TaskResult<List<ShiftModel>> getShifts() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(BusinessEndpoints.shifts);
      final list = response.data['data'] as List;
      return list.map((item) => ShiftModel.fromJson(item)).toList();
    });
  }

  TaskResult<void> createShift(ShiftModel shift) async {
    return tryCatchAsync(() async {
      await _apiClient.post(BusinessEndpoints.shifts, data: shift.toJson());
    });
  }

  TaskResult<void> requestJoin(BusinessJoinRequestModel request) async {
    return tryCatchAsync(() async {
      await _apiClient.post(BusinessEndpoints.joinRequests, data: request.toJson());
    });
  }

  TaskResult<List<BusinessJoinRequestModel>> getJoinRequests() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(BusinessEndpoints.joinRequests);
      final list = response.data['data'] as List;
      return list.map((item) => BusinessJoinRequestModel.fromJson(item)).toList();
    });
  }

  TaskResult<List<BusinessJoinRequestModel>> getMyJoinRequests() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(BusinessEndpoints.joinRequestsMe);
      final list = response.data['data'] as List;
      return list.map((item) => BusinessJoinRequestModel.fromJson(item)).toList();
    });
  }
}
