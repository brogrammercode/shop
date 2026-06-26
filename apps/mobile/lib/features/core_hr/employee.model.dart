// Auto-generated Model file for Employee

import 'address.model.dart';

class EmployeeModel {
  final String id;
  final String branch_id;
  final String uid;
  final String department;
  final String post;
  final String shift;
  final String role;
  final String status;
  final String created_at;
  final String updated_at;
  final bool is_deleted;
  final List<AddressModel> addresses;

  const EmployeeModel({
    required this.id,
    required this.branch_id,
    required this.uid,
    required this.department,
    required this.post,
    required this.shift,
    required this.role,
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.is_deleted,
    required this.addresses,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      uid: json['uid'] ?? '',
      department: json['department'] ?? '',
      post: json['post'] ?? '',
      shift: json['shift'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      is_deleted: json['is_deleted'] ?? false,
      addresses: (json['addresses'] as List<dynamic>? ?? []).map((x) => AddressModel.fromJson(x as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'uid': uid,
      'department': department,
      'post': post,
      'shift': shift,
      'role': role,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'is_deleted': is_deleted,
      'addresses': addresses.map((x) => x.toJson()).toList(),
    };
  }

  EmployeeModel copyWith({
    String? id,
    String? branch_id,
    String? uid,
    String? department,
    String? post,
    String? shift,
    String? role,
    String? status,
    String? created_at,
    String? updated_at,
    bool? is_deleted,
    List<AddressModel>? addresses,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      uid: uid ?? this.uid,
      department: department ?? this.department,
      post: post ?? this.post,
      shift: shift ?? this.shift,
      role: role ?? this.role,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_deleted: is_deleted ?? this.is_deleted,
      addresses: addresses ?? this.addresses,
    );
  }
}
