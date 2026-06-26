// Auto-generated Model file for User

import 'address.model.dart';
import '../finance/bank_detail.model.dart';

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
  final List<AddressModel> addresses;
  final List<BankDetailModel> bank_details;

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
    required this.addresses,
    required this.bank_details,
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
      employee: json['employee'] ?? '',
      addresses: (json['addresses'] as List<dynamic>? ?? []).map((x) => AddressModel.fromJson(x as Map<String, dynamic>)).toList(),
      bank_details: (json['bank_details'] as List<dynamic>? ?? []).map((x) => BankDetailModel.fromJson(x as Map<String, dynamic>)).toList(),
    );
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
      'addresses': addresses.map((x) => x.toJson()).toList(),
      'bank_details': bank_details.map((x) => x.toJson()).toList(),
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
    List<AddressModel>? addresses,
    List<BankDetailModel>? bank_details,
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
      addresses: addresses ?? this.addresses,
      bank_details: bank_details ?? this.bank_details,
    );
  }
}
