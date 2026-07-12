// Auto-generated Model file for User

import 'address.model.dart';
import '../../finance/bank_detail.model.dart';

class UserModel {
  final String id;
  final String name;
  final String avatar;
  final String phone;
  final String email;
  final String status;
  final String created_at;
  final String updated_at;
  final bool is_deleted;
  final String employee;
  final String employee_branch_name;
  final String employee_role_name;
  final String employee_department_name;
  final String employee_post_name;
  final String employee_shift_name;
  final List<AddressModel> addresses;
  final List<BankDetailModel> bank_details;
  final int order_count;
  final int session_count;
  final int complaint_count;
  final int loyalty_transaction_count;
  final int device_token_count;
  final int user_log_count;

  const UserModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.phone,
    required this.email,
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.is_deleted,
    required this.employee,
    this.employee_branch_name = '',
    this.employee_role_name = '',
    this.employee_department_name = '',
    this.employee_post_name = '',
    this.employee_shift_name = '',
    required this.addresses,
    required this.bank_details,
    this.order_count = 0,
    this.session_count = 0,
    this.complaint_count = 0,
    this.loyalty_transaction_count = 0,
    this.device_token_count = 0,
    this.user_log_count = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      status: json['status'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      is_deleted: json['is_deleted'] ?? false,
      employee: _employeeId(json['employee']),
      employee_branch_name: _nestedName(json['employee'], 'branch'),
      employee_role_name: _nestedName(json['employee'], 'role_rel'),
      employee_department_name: _nestedName(json['employee'], 'department_rel'),
      employee_post_name: _nestedName(json['employee'], 'post_rel'),
      employee_shift_name: _nestedName(json['employee'], 'shift_rel'),
      addresses: (json['addresses'] as List<dynamic>? ?? [])
          .map((x) => AddressModel.fromJson(x as Map<String, dynamic>))
          .toList(),
      bank_details: (json['bank_details'] as List<dynamic>? ?? [])
          .map((x) => BankDetailModel.fromJson(x as Map<String, dynamic>))
          .toList(),
      order_count: json['order_count'] ?? 0,
      session_count: json['session_count'] ?? 0,
      complaint_count: json['complaint_count'] ?? 0,
      loyalty_transaction_count: json['loyalty_transaction_count'] ?? 0,
      device_token_count: json['device_token_count'] ?? 0,
      user_log_count: json['user_log_count'] ?? 0,
    );
  }

  static String _employeeId(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value['id']?.toString() ?? '';
    }
    return value?.toString() ?? '';
  }

  static String _nestedName(dynamic value, String key) {
    if (value is Map<String, dynamic>) {
      final nested = value[key];
      if (nested is Map<String, dynamic>) {
        return nested['name']?.toString() ?? '';
      }
    }
    return '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'phone': phone,
      'email': email,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'is_deleted': is_deleted,
      'employee': employee,
      'employee_branch_name': employee_branch_name,
      'employee_role_name': employee_role_name,
      'employee_department_name': employee_department_name,
      'employee_post_name': employee_post_name,
      'employee_shift_name': employee_shift_name,
      'addresses': addresses.map((x) => x.toJson()).toList(),
      'bank_details': bank_details.map((x) => x.toJson()).toList(),
      'order_count': order_count,
      'session_count': session_count,
      'complaint_count': complaint_count,
      'loyalty_transaction_count': loyalty_transaction_count,
      'device_token_count': device_token_count,
      'user_log_count': user_log_count,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? avatar,
    String? phone,
    String? email,
    String? status,
    String? created_at,
    String? updated_at,
    bool? is_deleted,
    String? employee,
    String? employee_branch_name,
    String? employee_role_name,
    String? employee_department_name,
    String? employee_post_name,
    String? employee_shift_name,
    List<AddressModel>? addresses,
    List<BankDetailModel>? bank_details,
    int? order_count,
    int? session_count,
    int? complaint_count,
    int? loyalty_transaction_count,
    int? device_token_count,
    int? user_log_count,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_deleted: is_deleted ?? this.is_deleted,
      employee: employee ?? this.employee,
      employee_branch_name: employee_branch_name ?? this.employee_branch_name,
      employee_role_name: employee_role_name ?? this.employee_role_name,
      employee_department_name:
          employee_department_name ?? this.employee_department_name,
      employee_post_name: employee_post_name ?? this.employee_post_name,
      employee_shift_name: employee_shift_name ?? this.employee_shift_name,
      addresses: addresses ?? this.addresses,
      bank_details: bank_details ?? this.bank_details,
      order_count: order_count ?? this.order_count,
      session_count: session_count ?? this.session_count,
      complaint_count: complaint_count ?? this.complaint_count,
      loyalty_transaction_count:
          loyalty_transaction_count ?? this.loyalty_transaction_count,
      device_token_count: device_token_count ?? this.device_token_count,
      user_log_count: user_log_count ?? this.user_log_count,
    );
  }
}
