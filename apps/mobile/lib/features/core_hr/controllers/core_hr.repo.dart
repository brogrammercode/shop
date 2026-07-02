import 'package:mobile/core/config.dart';
import 'package:mobile/services/api_client.dart';
import 'package:mobile/services/local_storage.dart';
import 'package:mobile/utils/try_catch.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/features/core_hr/models/user.model.dart';
import 'package:mobile/features/core_hr/models/branch.model.dart';
import 'package:mobile/features/core_hr/models/employee.model.dart';
import 'package:mobile/features/core_hr/models/department.model.dart';
import 'package:mobile/features/core_hr/models/role.model.dart';
import 'package:mobile/features/core_hr/models/post.model.dart';
import 'package:mobile/features/core_hr/models/shift.model.dart';
import 'package:mobile/features/core_hr/models/time_log.model.dart';
import 'package:mobile/features/core_hr/models/cash_register.model.dart';
import 'package:mobile/features/core_hr/models/user_log.model.dart';

class CoreHrEndpoints {
  static const String login = '/hr/auth/login';
  static const String sendOtp = '/hr/auth/send-otp';
  static const String me = '/hr/auth/me';
  static const String branch = '/hr/branch';
  static const String searchBranch = '/hr/branch/search';
  static const String joinRequest = '/hr/branch/join-request';
  static const String joinRequests = '/hr/branch/join-requests';
  static String approveJoinRequest(String id) =>
      '/hr/branch/join-requests/$id/approve';
  static String rejectJoinRequest(String id) =>
      '/hr/branch/join-requests/$id/reject';
  static const String employees = '/hr/employees';
  static String employee(String id) => '/hr/employees/$id';
  static const String departments = '/hr/departments';
  static const String roles = '/hr/roles';
  static const String posts = '/hr/posts';
  static const String shifts = '/hr/shifts';
  static const String timeLogs = '/hr/time-logs';
  static const String clockIn = '/hr/time-logs/clock-in';
  static String clockOut(String id) => '/hr/time-logs/$id/clock-out';
  static const String cashRegisters = '/hr/cash-registers';
  static String openCashRegister(String id) => '/hr/cash-registers/$id/open';
  static String closeCashRegister(String id) => '/hr/cash-registers/$id/close';
  static const String userLogs = '/hr/user-logs';
}

class CoreHrRepo {
  final ApiClient _apiClient;
  final LocalStorage _localStorage;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: AppConfig.googleClientId,
    serverClientId: AppConfig.googleServerClientId,
  );

  CoreHrRepo({required ApiClient apiClient, required LocalStorage localStorage})
    : _apiClient = apiClient,
      _localStorage = localStorage;

  TaskResult<Map<String, dynamic>> signInWithGoogle() async {
    return tryCatchAsync(() async {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        throw Exception('Google sign in cancelled');
      }
      final GoogleSignInAuthentication auth = await account.authentication;
      final String? idToken = auth.idToken;
      if (idToken == null) {
        throw Exception('Google sign in failed');
      }
      final response = await _apiClient.post(
        CoreHrEndpoints.login,
        data: {'idToken': idToken},
      );
      final data = response.data['data'];
      await _localStorage.saveToken(data['tokens']['accessToken']);
      await _localStorage.saveRefreshToken(data['tokens']['refreshToken']);
      return {
        'user': UserModel.fromJson(data['user']),
        'employee': data['employee'] != null
            ? EmployeeModel.fromJson(data['employee'])
            : null,
      };
    });
  }

  TaskResult<void> sendOtp(String phoneNumber) async {
    return tryCatchAsync(() async {
      await _apiClient.post(
        CoreHrEndpoints.sendOtp,
        data: {'phone_number': phoneNumber},
      );
    });
  }

  TaskResult<Map<String, dynamic>> login(
    String phoneNumber,
    String otp, {
    bool rememberLogin = false,
  }) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(
        CoreHrEndpoints.login,
        data: {
          'phone_number': phoneNumber,
          'otp': otp,
        },
      );
      final data = response.data['data'];
      await _localStorage.saveToken(data['tokens']['accessToken']);
      await _localStorage.saveRefreshToken(data['tokens']['refreshToken']);
      return {
        'user': UserModel.fromJson(data['user']),
        'employee': data['employee'] != null
            ? EmployeeModel.fromJson(data['employee'])
            : null,
      };
    });
  }

  TaskResult<void> logout(String sessionId) async {
    return tryCatchAsync(() async {
      await _apiClient.post('/hr/auth/logout', data: {'sessionId': sessionId});
      await _localStorage.clearSession();
    });
  }

  TaskResult<String> refreshAccessToken(String refreshToken) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post('/hr/auth/refresh', data: {'refreshToken': refreshToken});
      final accessToken = response.data['data']['accessToken'];
      await _localStorage.saveToken(accessToken);
      return accessToken;
    });
  }

  TaskResult<List<dynamic>> getSessions() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get('/hr/auth/sessions');
      return response.data['data'] as List<dynamic>;
    });
  }

  TaskResult<void> terminateSession(String sessionId) async {
    return tryCatchAsync(() async {
      await _apiClient.delete('/hr/auth/sessions/$sessionId');
    });
  }

  TaskResult<void> logActivity(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      await _apiClient.post('/hr/auth/activity', data: data);
    });
  }

  TaskResult<List<dynamic>> getActivities() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get('/hr/auth/activity');
      return response.data['data'] as List<dynamic>;
    });
  }

  TaskResult<Map<String, dynamic>> getMe() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(CoreHrEndpoints.me);
      final data = response.data['data'];
      return {
        'user': UserModel.fromJson(data['user']),
        'employee': data['employee'] != null
            ? EmployeeModel.fromJson(data['employee'])
            : null,
      };
    });
  }

  TaskResult<Map<String, dynamic>> createBranch(
    String name,
    String code,
    bool isHq,
  ) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(
        CoreHrEndpoints.branch,
        data: {'name': name, 'code': code, 'is_hq': isHq},
      );
      final data = response.data['data'];
      return {
        'branch': BranchModel.fromJson(data['branch']),
        'employee': EmployeeModel.fromJson(data['employee']),
      };
    });
  }

  TaskResult<List<BranchModel>> searchBranches(String query) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(
        '${CoreHrEndpoints.searchBranch}?q=$query',
      );
      final data = response.data['data'] as List;
      return data.map((e) => BranchModel.fromJson(e)).toList();
    });
  }

  TaskResult<dynamic> sendJoinRequest(String branchId, String? message) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(
        CoreHrEndpoints.joinRequest,
        data: {'branch_id': branchId, 'message': message},
      );
      return response.data['data'];
    });
  }

  TaskResult<List<dynamic>> listJoinRequests() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(CoreHrEndpoints.joinRequests);
      return response.data['data'] as List<dynamic>;
    });
  }

  TaskResult<dynamic> approveJoinRequest(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(
        CoreHrEndpoints.approveJoinRequest(id),
      );
      return response.data['data'];
    });
  }

  TaskResult<dynamic> rejectJoinRequest(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(
        CoreHrEndpoints.rejectJoinRequest(id),
      );
      return response.data['data'];
    });
  }

  TaskResult<List<EmployeeModel>> listEmployees() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(CoreHrEndpoints.employees);
      final data = response.data['data'] as List;
      return data.map((e) => EmployeeModel.fromJson(e)).toList();
    });
  }

  TaskResult<EmployeeModel> createEmployee(String uid, String roleId) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(
        CoreHrEndpoints.employees,
        data: {'uid': uid, 'role_id': roleId},
      );
      return EmployeeModel.fromJson(response.data['data']);
    });
  }

  TaskResult<EmployeeModel> updateEmployee(
    String id,
    Map<String, dynamic> data,
  ) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.patch(
        CoreHrEndpoints.employee(id),
        data: data,
      );
      return EmployeeModel.fromJson(response.data['data']);
    });
  }

  TaskResult<dynamic> deleteEmployee(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.delete(CoreHrEndpoints.employee(id));
      return response.data['data'];
    });
  }

  TaskResult<List<DepartmentModel>> listDepartments() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(CoreHrEndpoints.departments);
      final data = response.data['data'] as List;
      return data.map((e) => DepartmentModel.fromJson(e)).toList();
    });
  }

  TaskResult<DepartmentModel> createDepartment(
    String name,
    String? description,
  ) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(
        CoreHrEndpoints.departments,
        data: {'name': name, 'description': description},
      );
      return DepartmentModel.fromJson(response.data['data']);
    });
  }

  TaskResult<List<RoleModel>> listRoles() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(CoreHrEndpoints.roles);
      final data = response.data['data'] as List;
      return data.map((e) => RoleModel.fromJson(e)).toList();
    });
  }

  TaskResult<RoleModel> createRole(
    String name,
    List<String> permissions,
  ) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(
        CoreHrEndpoints.roles,
        data: {'name': name, 'permissions': permissions},
      );
      return RoleModel.fromJson(response.data['data']);
    });
  }

  TaskResult<List<PostModel>> listPosts() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(CoreHrEndpoints.posts);
      final data = response.data['data'] as List;
      return data.map((e) => PostModel.fromJson(e)).toList();
    });
  }

  TaskResult<PostModel> createPost(
    String name,
    String departmentId,
    String? description,
  ) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(
        CoreHrEndpoints.posts,
        data: {
          'name': name,
          'department_id': departmentId,
          'description': description,
        },
      );
      return PostModel.fromJson(response.data['data']);
    });
  }

  TaskResult<List<ShiftModel>> listShifts() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(CoreHrEndpoints.shifts);
      final data = response.data['data'] as List;
      return data.map((e) => ShiftModel.fromJson(e)).toList();
    });
  }

  TaskResult<ShiftModel> createShift(
    String name,
    String startTime,
    String endTime,
  ) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(
        CoreHrEndpoints.shifts,
        data: {'name': name, 'start_time': startTime, 'end_time': endTime},
      );
      return ShiftModel.fromJson(response.data['data']);
    });
  }

  TaskResult<List<TimeLogModel>> listTimeLogs() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(CoreHrEndpoints.timeLogs);
      final data = response.data['data'] as List;
      return data.map((e) => TimeLogModel.fromJson(e)).toList();
    });
  }

  TaskResult<TimeLogModel> clockIn() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(CoreHrEndpoints.clockIn);
      return TimeLogModel.fromJson(response.data['data']);
    });
  }

  TaskResult<TimeLogModel> clockOut(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.patch(CoreHrEndpoints.clockOut(id));
      return TimeLogModel.fromJson(response.data['data']);
    });
  }

  TaskResult<List<CashRegisterModel>> listCashRegisters() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(CoreHrEndpoints.cashRegisters);
      final data = response.data['data'] as List;
      return data.map((e) => CashRegisterModel.fromJson(e)).toList();
    });
  }

  TaskResult<CashRegisterModel> createCashRegister(
    String registerName,
    String? macAddress,
  ) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(
        CoreHrEndpoints.cashRegisters,
        data: {'register_name': registerName, 'mac_address': macAddress},
      );
      return CashRegisterModel.fromJson(response.data['data']);
    });
  }

  TaskResult<CashRegisterModel> openCashRegister(
    String id,
    double expectedCash,
  ) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.patch(
        CoreHrEndpoints.openCashRegister(id),
        data: {'expected_cash': expectedCash},
      );
      return CashRegisterModel.fromJson(response.data['data']);
    });
  }

  TaskResult<CashRegisterModel> closeCashRegister(
    String id,
    double actualCash,
  ) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.patch(
        CoreHrEndpoints.closeCashRegister(id),
        data: {'actual_cash': actualCash},
      );
      return CashRegisterModel.fromJson(response.data['data']);
    });
  }

  TaskResult<List<UserLogModel>> listUserLogs() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(CoreHrEndpoints.userLogs);
      final data = response.data['data'] as List;
      return data.map((e) => UserLogModel.fromJson(e)).toList();
    });
  }
}
