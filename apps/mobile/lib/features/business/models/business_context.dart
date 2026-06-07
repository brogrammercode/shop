import 'package:mobile/features/business/models/branch.dart';
import 'package:mobile/features/business/models/employee.dart';

class BusinessContextModel {
  final BranchModel branch;
  final EmployeeModel employee;
  final List<String> permissions;

  const BusinessContextModel({
    required this.branch,
    required this.employee,
    required this.permissions,
  });

  factory BusinessContextModel.fromJson(Map<String, dynamic> json) {
    return BusinessContextModel(
      branch: BranchModel.fromJson(json['branch'] ?? {}),
      employee: EmployeeModel.fromJson(json['employee'] ?? {}),
      permissions: List<String>.from(json['permissions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch': branch.toJson(),
      'employee': employee.toJson(),
      'permissions': permissions,
    };
  }
}
