import 'package:mobile/utils/error.dart';
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

class CoreHrState {
  final UserModel? currentUser;
  final EmployeeModel? currentEmployee;
  final BranchModel? currentBranch;
  final List<BranchModel> searchedBranches;
  final List<EmployeeModel> employees;
  final List<DepartmentModel> departments;
  final List<RoleModel> roles;
  final List<PostModel> posts;
  final List<ShiftModel> shifts;
  final List<TimeLogModel> timeLogs;
  final List<CashRegisterModel> cashRegisters;
  final List<UserLogModel> userLogs;
  final List<dynamic> joinRequests;
  final List<dynamic> sessions;
  final List<dynamic> activities;

  final OperationInfo loginInfo;
  final OperationInfo googleSignInInfo;
  final OperationInfo sendOtpInfo;
  final OperationInfo getMeInfo;
  final OperationInfo branchInfo;
  final OperationInfo searchBranchInfo;
  final OperationInfo joinInfo;
  final OperationInfo employeeInfo;
  final OperationInfo departmentInfo;
  final OperationInfo roleInfo;
  final OperationInfo postInfo;
  final OperationInfo shiftInfo;
  final OperationInfo timeLogInfo;
  final OperationInfo cashRegisterInfo;
  final OperationInfo logoutInfo;
  final OperationInfo sessionInfo;
  final OperationInfo activityInfo;
  final OperationInfo loginWithSavedProfileInfo;

  const CoreHrState({
    this.currentUser,
    this.currentEmployee,
    this.currentBranch,
    this.searchedBranches = const [],
    this.employees = const [],
    this.departments = const [],
    this.roles = const [],
    this.posts = const [],
    this.shifts = const [],
    this.timeLogs = const [],
    this.cashRegisters = const [],
    this.userLogs = const [],
    this.joinRequests = const [],
    this.sessions = const [],
    this.activities = const [],
    this.loginInfo = const OperationInfo(status: OperationStatus.initial),
    this.googleSignInInfo = const OperationInfo(status: OperationStatus.initial),
    this.sendOtpInfo = const OperationInfo(status: OperationStatus.initial),
    this.getMeInfo = const OperationInfo(status: OperationStatus.initial),
    this.branchInfo = const OperationInfo(status: OperationStatus.initial),
    this.searchBranchInfo = const OperationInfo(
      status: OperationStatus.initial,
    ),
    this.joinInfo = const OperationInfo(status: OperationStatus.initial),
    this.employeeInfo = const OperationInfo(status: OperationStatus.initial),
    this.departmentInfo = const OperationInfo(status: OperationStatus.initial),
    this.roleInfo = const OperationInfo(status: OperationStatus.initial),
    this.postInfo = const OperationInfo(status: OperationStatus.initial),
    this.shiftInfo = const OperationInfo(status: OperationStatus.initial),
    this.timeLogInfo = const OperationInfo(status: OperationStatus.initial),
    this.cashRegisterInfo = const OperationInfo(
      status: OperationStatus.initial,
    ),
    this.logoutInfo = const OperationInfo(status: OperationStatus.initial),
    this.sessionInfo = const OperationInfo(status: OperationStatus.initial),
    this.activityInfo = const OperationInfo(status: OperationStatus.initial),
    this.loginWithSavedProfileInfo = const OperationInfo(status: OperationStatus.initial),
  });

  CoreHrState copyWith({
    UserModel? currentUser,
    EmployeeModel? currentEmployee,
    BranchModel? currentBranch,
    List<BranchModel>? searchedBranches,
    List<EmployeeModel>? employees,
    List<DepartmentModel>? departments,
    List<RoleModel>? roles,
    List<PostModel>? posts,
    List<ShiftModel>? shifts,
    List<TimeLogModel>? timeLogs,
    List<CashRegisterModel>? cashRegisters,
    List<UserLogModel>? userLogs,
    List<dynamic>? joinRequests,
    OperationInfo? loginInfo,
    OperationInfo? googleSignInInfo,
    OperationInfo? sendOtpInfo,
    OperationInfo? getMeInfo,
    OperationInfo? branchInfo,
    OperationInfo? searchBranchInfo,
    OperationInfo? joinInfo,
    OperationInfo? employeeInfo,
    OperationInfo? departmentInfo,
    OperationInfo? roleInfo,
    OperationInfo? postInfo,
    OperationInfo? shiftInfo,
    OperationInfo? timeLogInfo,
    OperationInfo? cashRegisterInfo,
    List<dynamic>? sessions,
    List<dynamic>? activities,
    OperationInfo? logoutInfo,
    OperationInfo? sessionInfo,
    OperationInfo? activityInfo,
    OperationInfo? loginWithSavedProfileInfo,
  }) {
    return CoreHrState(
      currentUser: currentUser ?? this.currentUser,
      currentEmployee: currentEmployee ?? this.currentEmployee,
      currentBranch: currentBranch ?? this.currentBranch,
      searchedBranches: searchedBranches ?? this.searchedBranches,
      employees: employees ?? this.employees,
      departments: departments ?? this.departments,
      roles: roles ?? this.roles,
      posts: posts ?? this.posts,
      shifts: shifts ?? this.shifts,
      timeLogs: timeLogs ?? this.timeLogs,
      cashRegisters: cashRegisters ?? this.cashRegisters,
      userLogs: userLogs ?? this.userLogs,
      joinRequests: joinRequests ?? this.joinRequests,
      loginInfo: loginInfo ?? this.loginInfo,
      googleSignInInfo: googleSignInInfo ?? this.googleSignInInfo,
      sendOtpInfo: sendOtpInfo ?? this.sendOtpInfo,
      getMeInfo: getMeInfo ?? this.getMeInfo,
      branchInfo: branchInfo ?? this.branchInfo,
      searchBranchInfo: searchBranchInfo ?? this.searchBranchInfo,
      joinInfo: joinInfo ?? this.joinInfo,
      employeeInfo: employeeInfo ?? this.employeeInfo,
      departmentInfo: departmentInfo ?? this.departmentInfo,
      roleInfo: roleInfo ?? this.roleInfo,
      postInfo: postInfo ?? this.postInfo,
      shiftInfo: shiftInfo ?? this.shiftInfo,
      timeLogInfo: timeLogInfo ?? this.timeLogInfo,
      cashRegisterInfo: cashRegisterInfo ?? this.cashRegisterInfo,
      sessions: sessions ?? this.sessions,
      activities: activities ?? this.activities,
      logoutInfo: logoutInfo ?? this.logoutInfo,
      sessionInfo: sessionInfo ?? this.sessionInfo,
      activityInfo: activityInfo ?? this.activityInfo,
      loginWithSavedProfileInfo: loginWithSavedProfileInfo ?? this.loginWithSavedProfileInfo,
    );
  }
}
