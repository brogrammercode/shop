import 'package:mobile/features/business/models/address.dart';
import 'package:mobile/features/business/models/bank_details.dart';

class EmployeeModel {
  final String id;
  final String uid;
  final String name;
  final String email;
  final String? phone_number;
  final BankDetailsModel bank_details;
  final AddressModel address;
  final String branch_id;
  final String role_id;
  final String shift_id;
  final String post_id;
  final String created_at;
  final String updated_at;

  const EmployeeModel({
    required this.id,
    required this.uid,
    required this.name,
    required this.email,
    this.phone_number,
    required this.bank_details,
    required this.address,
    required this.branch_id,
    required this.role_id,
    required this.shift_id,
    required this.post_id,
    required this.created_at,
    required this.updated_at,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: (json['id'] ?? '').toString(),
      uid: (json['uid'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone_number: json['phone_number']?.toString(),
      bank_details: BankDetailsModel.fromJson(json['bank_details'] ?? {}),
      address: AddressModel.fromJson(json['address'] ?? {}),
      branch_id: (json['branch_id'] ?? '').toString(),
      role_id: (json['role_id'] ?? '').toString(),
      shift_id: (json['shift_id'] ?? '').toString(),
      post_id: (json['post_id'] ?? '').toString(),
      created_at: (json['created_at'] ?? '').toString(),
      updated_at: (json['updated_at'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'email': email,
      'phone_number': phone_number,
      'bank_details': bank_details.toJson(),
      'address': address.toJson(),
      'branch_id': branch_id,
      'role_id': role_id,
      'shift_id': shift_id,
      'post_id': post_id,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
