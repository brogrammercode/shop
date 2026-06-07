import 'package:mobile/features/business/models/branch.dart';
import 'package:mobile/features/business/models/role.dart';
import 'package:mobile/features/auth/models/user.dart';

class BusinessJoinRequestModel {
  final String id;
  final String uid;
  final String branch_id;
  final String? requested_role_id;
  final String status;
  final String? reviewed_by_id;
  final String created_at;
  final String updated_at;
  final UserModel? user;
  final BranchModel? branch;
  final RoleModel? requested_role;

  const BusinessJoinRequestModel({
    required this.id,
    required this.uid,
    required this.branch_id,
    this.requested_role_id,
    required this.status,
    this.reviewed_by_id,
    required this.created_at,
    required this.updated_at,
    this.user,
    this.branch,
    this.requested_role,
  });

  factory BusinessJoinRequestModel.fromJson(Map<String, dynamic> json) {
    return BusinessJoinRequestModel(
      id: (json['id'] ?? '').toString(),
      uid: (json['uid'] ?? '').toString(),
      branch_id: (json['branch_id'] ?? '').toString(),
      requested_role_id: json['requested_role_id']?.toString(),
      status: (json['status'] ?? '').toString(),
      reviewed_by_id: json['reviewed_by_id']?.toString(),
      created_at: (json['created_at'] ?? '').toString(),
      updated_at: (json['updated_at'] ?? '').toString(),
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      branch: json['branch'] != null ? BranchModel.fromJson(json['branch']) : null,
      requested_role: json['requested_role'] != null ? RoleModel.fromJson(json['requested_role']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'branch_id': branch_id,
      'requested_role_id': requested_role_id,
      'status': status,
      'reviewed_by_id': reviewed_by_id,
      'created_at': created_at,
      'updated_at': updated_at,
      'user': user?.toJson(),
      'branch': branch?.toJson(),
      'requested_role': requested_role?.toJson(),
    };
  }
}
