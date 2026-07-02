// Auto-generated Model file for Supplier

import '../core_hr/models/address.model.dart';
import '../finance/bank_detail.model.dart';

class SupplierModel {
  final String id;
  final String branch_id;
  final String name;
  final String avatar;
  final String tax_number;
  final String contact_email;
  final String contact_phone;
  final String status;
  final String created_at;
  final String updated_at;
  final bool is_deleted;
  final List<AddressModel> addresses;
  final List<BankDetailModel> bank_details;

  const SupplierModel({
    required this.id,
    required this.branch_id,
    required this.name,
    required this.avatar,
    required this.tax_number,
    required this.contact_email,
    required this.contact_phone,
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.is_deleted,
    required this.addresses,
    required this.bank_details,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      tax_number: json['tax_number'] ?? '',
      contact_email: json['contact_email'] ?? '',
      contact_phone: json['contact_phone'] ?? '',
      status: json['status'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      is_deleted: json['is_deleted'] ?? false,
      addresses: (json['addresses'] as List<dynamic>? ?? [])
          .map((x) => AddressModel.fromJson(x as Map<String, dynamic>))
          .toList(),
      bank_details: (json['bank_details'] as List<dynamic>? ?? [])
          .map((x) => BankDetailModel.fromJson(x as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'name': name,
      'avatar': avatar,
      'tax_number': tax_number,
      'contact_email': contact_email,
      'contact_phone': contact_phone,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'is_deleted': is_deleted,
      'addresses': addresses.map((x) => x.toJson()).toList(),
      'bank_details': bank_details.map((x) => x.toJson()).toList(),
    };
  }

  SupplierModel copyWith({
    String? id,
    String? branch_id,
    String? name,
    String? avatar,
    String? tax_number,
    String? contact_email,
    String? contact_phone,
    String? status,
    String? created_at,
    String? updated_at,
    bool? is_deleted,
    List<AddressModel>? addresses,
    List<BankDetailModel>? bank_details,
  }) {
    return SupplierModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      tax_number: tax_number ?? this.tax_number,
      contact_email: contact_email ?? this.contact_email,
      contact_phone: contact_phone ?? this.contact_phone,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_deleted: is_deleted ?? this.is_deleted,
      addresses: addresses ?? this.addresses,
      bank_details: bank_details ?? this.bank_details,
    );
  }
}
