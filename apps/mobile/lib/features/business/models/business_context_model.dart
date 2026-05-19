import 'package:mobile/features/business/models/branch_model.dart';
import 'package:mobile/features/business/models/business_model.dart';
import 'package:mobile/features/business/models/employee_model.dart';

class BusinessContextModel {
  final BusinessModel business;
  final BranchModel branch;
  final EmployeeModel employee;
  final List<String> permissions;

  const BusinessContextModel({
    required this.business,
    required this.branch,
    required this.employee,
    required this.permissions,
  });

  factory BusinessContextModel.fromJson(Map<String, dynamic> json) {
    return BusinessContextModel(
      business: BusinessModel.fromJson(
        Map<String, dynamic>.from(json['business'] ?? {}),
      ),
      branch: BranchModel.fromJson(
        Map<String, dynamic>.from(json['branch'] ?? {}),
      ),
      employee: EmployeeModel.fromJson(
        Map<String, dynamic>.from(json['employee'] ?? {}),
      ),
      permissions: (json['permissions'] as List<dynamic>? ?? [])
          .map<String>((permission) => permission.toString())
          .toList(),
    );
  }

  BusinessContextModel copyWith({
    BusinessModel? business,
    BranchModel? branch,
    EmployeeModel? employee,
    List<String>? permissions,
  }) {
    return BusinessContextModel(
      business: business ?? this.business,
      branch: branch ?? this.branch,
      employee: employee ?? this.employee,
      permissions: permissions ?? this.permissions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'business': business.toJson(),
      'branch': branch.toJson(),
      'employee': employee.toJson(),
      'permissions': permissions,
    };
  }
}
