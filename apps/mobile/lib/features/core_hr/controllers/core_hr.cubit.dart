import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.repo.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.state.dart';
import 'package:mobile/services/json_cache.dart';
import 'package:mobile/features/core_hr/models/user.model.dart';
import 'package:mobile/features/core_hr/models/employee.model.dart';

class CoreHrCubit extends Cubit<CoreHrState> {
  final CoreHrRepo _repo;
  final JsonCache _cache = JsonCache();

  CoreHrCubit({required CoreHrRepo repo})
    : _repo = repo,
      super(const CoreHrState());

  Future<void> loginWithSavedProfile() async {
    emit(state.copyWith(loginWithSavedProfileInfo: const OperationInfo(status: OperationStatus.loading)));
    try {
      final profile = await _cache.getSavedProfile();
      if (profile != null) {
        emit(state.copyWith(
          currentUser: profile['user'] != null ? UserModel.fromJson(profile['user']) : null,
          currentEmployee: profile['employee'] != null ? EmployeeModel.fromJson(profile['employee']) : null,
          loginWithSavedProfileInfo: const OperationInfo(status: OperationStatus.success),
        ));
      } else {
        emit(state.copyWith(loginWithSavedProfileInfo: const OperationInfo(status: OperationStatus.initial)));
      }
    } catch (e) {
      emit(state.copyWith(loginWithSavedProfileInfo: const OperationInfo(status: OperationStatus.initial)));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(
      state.copyWith(
        googleSignInInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.signInWithGoogle();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            googleSignInInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (data) {
        final profile = {
          'user': data['user']?.toJson(),
          'employee': data['employee']?.toJson(),
        };
        _cache.saveSavedProfile(profile);
        emit(
          state.copyWith(
            currentUser: data['user'],
            currentEmployee: data['employee'],
            googleSignInInfo: const OperationInfo(status: OperationStatus.success),
          ),
        );
      },
    );
  }

  Future<void> sendOtp(String phoneNumber) async {
    emit(
      state.copyWith(
        sendOtpInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.sendOtp(phoneNumber);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            sendOtpInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            sendOtpInfo: const OperationInfo(status: OperationStatus.success),
          ),
        );
      },
    );
  }

  Future<void> login(
    String phoneNumber,
    String otp, {
    bool rememberLogin = false,
  }) async {
    emit(
      state.copyWith(
        loginInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.login(
      phoneNumber,
      otp,
      rememberLogin: rememberLogin,
    );
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            loginInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (data) {
        final profile = {
          'user': data['user']?.toJson(),
          'employee': data['employee']?.toJson(),
        };
        _cache.saveSavedProfile(profile);
        emit(
          state.copyWith(
            currentUser: data['user'],
            currentEmployee: data['employee'],
            loginInfo: const OperationInfo(status: OperationStatus.success),
          ),
        );
      },
    );
  }

  Future<void> logout(String sessionId) async {
    emit(state.copyWith(logoutInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.logout(sessionId);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(logoutInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        _cache.clearSavedProfile();
        emit(state.copyWith(
          currentUser: null,
          currentEmployee: null,
          logoutInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> getSessions() async {
    emit(state.copyWith(sessionInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.getSessions();
    result.fold(
      (failure) => emit(state.copyWith(sessionInfo: OperationInfo(status: OperationStatus.error, error: failure))),
      (data) => emit(state.copyWith(sessions: data, sessionInfo: const OperationInfo(status: OperationStatus.success))),
    );
  }

  Future<void> terminateSession(String sessionId) async {
    emit(state.copyWith(sessionInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.terminateSession(sessionId);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(sessionInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) => getSessions(),
    );
  }

  Future<void> getActivities() async {
    emit(state.copyWith(activityInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.getActivities();
    result.fold(
      (failure) => emit(state.copyWith(activityInfo: OperationInfo(status: OperationStatus.error, error: failure))),
      (data) => emit(state.copyWith(activities: data, activityInfo: const OperationInfo(status: OperationStatus.success))),
    );
  }

  Future<void> getMe() async {
    emit(
      state.copyWith(
        getMeInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.getMe();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            getMeInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (data) {
        emit(
          state.copyWith(
            currentUser: data['user'],
            currentEmployee: data['employee'],
            getMeInfo: const OperationInfo(status: OperationStatus.success),
          ),
        );
      },
    );
  }

  Future<void> createBranch(String name, String code, bool isHq) async {
    emit(
      state.copyWith(
        branchInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.createBranch(name, code, isHq);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            branchInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (data) {
        emit(
          state.copyWith(
            currentBranch: data['branch'],
            currentEmployee: data['employee'],
            branchInfo: const OperationInfo(status: OperationStatus.success),
          ),
        );
      },
    );
  }

  Future<void> searchBranches(String query) async {
    emit(
      state.copyWith(
        searchBranchInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.searchBranches(query);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            searchBranchInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (branches) {
        emit(
          state.copyWith(
            searchedBranches: branches,
            searchBranchInfo: const OperationInfo(
              status: OperationStatus.success,
            ),
          ),
        );
      },
    );
  }

  Future<void> sendJoinRequest(String branchId, String? message) async {
    emit(
      state.copyWith(
        joinInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.sendJoinRequest(branchId, message);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            joinInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        Fluttertoast.showToast(msg: 'Join request sent');
        emit(
          state.copyWith(
            joinInfo: const OperationInfo(status: OperationStatus.success),
          ),
        );
      },
    );
  }

  Future<void> listJoinRequests() async {
    emit(
      state.copyWith(
        joinInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.listJoinRequests();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            joinInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (requests) {
        emit(
          state.copyWith(
            joinRequests: requests,
            joinInfo: const OperationInfo(status: OperationStatus.success),
          ),
        );
      },
    );
  }

  Future<void> approveJoinRequest(String id) async {
    emit(
      state.copyWith(
        joinInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.approveJoinRequest(id);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            joinInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        Fluttertoast.showToast(msg: 'Request approved');
        listJoinRequests();
      },
    );
  }

  Future<void> rejectJoinRequest(String id) async {
    emit(
      state.copyWith(
        joinInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.rejectJoinRequest(id);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            joinInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        Fluttertoast.showToast(msg: 'Request rejected');
        listJoinRequests();
      },
    );
  }

  Future<void> listEmployees() async {
    emit(
      state.copyWith(
        employeeInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.listEmployees();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            employeeInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (employees) {
        emit(
          state.copyWith(
            employees: employees,
            employeeInfo: const OperationInfo(status: OperationStatus.success),
          ),
        );
      },
    );
  }

  Future<void> createEmployee(String uid, String roleId) async {
    emit(
      state.copyWith(
        employeeInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.createEmployee(uid, roleId);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            employeeInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        Fluttertoast.showToast(msg: 'Employee created');
        listEmployees();
      },
    );
  }

  Future<void> updateEmployee(String id, Map<String, dynamic> data) async {
    emit(
      state.copyWith(
        employeeInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.updateEmployee(id, data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            employeeInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        Fluttertoast.showToast(msg: 'Employee updated');
        listEmployees();
      },
    );
  }

  Future<void> deleteEmployee(String id) async {
    emit(
      state.copyWith(
        employeeInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.deleteEmployee(id);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            employeeInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        Fluttertoast.showToast(msg: 'Employee deleted');
        listEmployees();
      },
    );
  }

  Future<void> listDepartments() async {
    emit(
      state.copyWith(
        departmentInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.listDepartments();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            departmentInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (departments) {
        emit(
          state.copyWith(
            departments: departments,
            departmentInfo: const OperationInfo(
              status: OperationStatus.success,
            ),
          ),
        );
      },
    );
  }

  Future<void> createDepartment(String name, String? description) async {
    emit(
      state.copyWith(
        departmentInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.createDepartment(name, description);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            departmentInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        Fluttertoast.showToast(msg: 'Department created');
        listDepartments();
      },
    );
  }

  Future<void> listRoles() async {
    emit(
      state.copyWith(
        roleInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.listRoles();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            roleInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (roles) {
        emit(
          state.copyWith(
            roles: roles,
            roleInfo: const OperationInfo(status: OperationStatus.success),
          ),
        );
      },
    );
  }

  Future<void> createRole(String name, List<String> permissions) async {
    emit(
      state.copyWith(
        roleInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.createRole(name, permissions);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            roleInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        Fluttertoast.showToast(msg: 'Role created');
        listRoles();
      },
    );
  }

  Future<void> listPosts() async {
    emit(
      state.copyWith(
        postInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.listPosts();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            postInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (posts) {
        emit(
          state.copyWith(
            posts: posts,
            postInfo: const OperationInfo(status: OperationStatus.success),
          ),
        );
      },
    );
  }

  Future<void> createPost(
    String name,
    String departmentId,
    String? description,
  ) async {
    emit(
      state.copyWith(
        postInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.createPost(name, departmentId, description);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            postInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        Fluttertoast.showToast(msg: 'Post created');
        listPosts();
      },
    );
  }

  Future<void> listShifts() async {
    emit(
      state.copyWith(
        shiftInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.listShifts();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            shiftInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (shifts) {
        emit(
          state.copyWith(
            shifts: shifts,
            shiftInfo: const OperationInfo(status: OperationStatus.success),
          ),
        );
      },
    );
  }

  Future<void> createShift(
    String name,
    String startTime,
    String endTime,
  ) async {
    emit(
      state.copyWith(
        shiftInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.createShift(name, startTime, endTime);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            shiftInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        Fluttertoast.showToast(msg: 'Shift created');
        listShifts();
      },
    );
  }

  Future<void> listTimeLogs() async {
    emit(
      state.copyWith(
        timeLogInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.listTimeLogs();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            timeLogInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (logs) {
        emit(
          state.copyWith(
            timeLogs: logs,
            timeLogInfo: const OperationInfo(status: OperationStatus.success),
          ),
        );
      },
    );
  }

  Future<void> clockIn() async {
    emit(
      state.copyWith(
        timeLogInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.clockIn();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            timeLogInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        Fluttertoast.showToast(msg: 'Clocked in');
        listTimeLogs();
      },
    );
  }

  Future<void> clockOut(String id) async {
    emit(
      state.copyWith(
        timeLogInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.clockOut(id);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            timeLogInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        Fluttertoast.showToast(msg: 'Clocked out');
        listTimeLogs();
      },
    );
  }

  Future<void> listCashRegisters() async {
    emit(
      state.copyWith(
        cashRegisterInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.listCashRegisters();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            cashRegisterInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (registers) {
        emit(
          state.copyWith(
            cashRegisters: registers,
            cashRegisterInfo: const OperationInfo(
              status: OperationStatus.success,
            ),
          ),
        );
      },
    );
  }

  Future<void> createCashRegister(String name, String? macAddress) async {
    emit(
      state.copyWith(
        cashRegisterInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.createCashRegister(name, macAddress);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            cashRegisterInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        Fluttertoast.showToast(msg: 'Cash register created');
        listCashRegisters();
      },
    );
  }

  Future<void> openCashRegister(String id, double expectedCash) async {
    emit(
      state.copyWith(
        cashRegisterInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.openCashRegister(id, expectedCash);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            cashRegisterInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        Fluttertoast.showToast(msg: 'Cash register opened');
        listCashRegisters();
      },
    );
  }

  Future<void> closeCashRegister(String id, double actualCash) async {
    emit(
      state.copyWith(
        cashRegisterInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.closeCashRegister(id, actualCash);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            cashRegisterInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        Fluttertoast.showToast(msg: 'Cash register closed');
        listCashRegisters();
      },
    );
  }

  Future<void> listUserLogs() async {
    final result = await _repo.listUserLogs();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
      },
      (logs) {
        emit(state.copyWith(userLogs: logs));
      },
    );
  }
}
