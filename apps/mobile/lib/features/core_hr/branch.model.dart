// Auto-generated Model file for Branch

import 'address.model.dart';
import '../finance/bank_detail.model.dart';

class BranchModel {
  final String id;
  final String name;
  final String code;
  final bool is_hq;
  final String status;
  final String created_at;
  final String updated_at;
  final String created_by;
  final String updated_by;
  final bool is_deleted;
  final String franchise;
  final List<AddressModel> addresses;
  final List<BankDetailModel> bank_details;

  const BranchModel({
    required this.id,
    required this.name,
    required this.code,
    required this.is_hq,
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.created_by,
    required this.updated_by,
    required this.is_deleted,
    required this.franchise,
    required this.addresses,
    required this.bank_details,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      is_hq: json['is_hq'] ?? false,
      status: json['status'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      created_by: json['created_by'] ?? '',
      updated_by: json['updated_by'] ?? '',
      is_deleted: json['is_deleted'] ?? false,
      franchise: json['franchise'] ?? '',
      addresses: (json['addresses'] as List<dynamic>? ?? []).map((x) => AddressModel.fromJson(x as Map<String, dynamic>)).toList(),
      bank_details: (json['bank_details'] as List<dynamic>? ?? []).map((x) => BankDetailModel.fromJson(x as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'is_hq': is_hq,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'created_by': created_by,
      'updated_by': updated_by,
      'is_deleted': is_deleted,
      'franchise': franchise,
      'addresses': addresses.map((x) => x.toJson()).toList(),
      'bank_details': bank_details.map((x) => x.toJson()).toList(),
    };
  }

  BranchModel copyWith({
    String? id,
    String? name,
    String? code,
    bool? is_hq,
    String? status,
    String? created_at,
    String? updated_at,
    String? created_by,
    String? updated_by,
    bool? is_deleted,
    String? franchise,
    List<AddressModel>? addresses,
    List<BankDetailModel>? bank_details,
  }) {
    return BranchModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      is_hq: is_hq ?? this.is_hq,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      created_by: created_by ?? this.created_by,
      updated_by: updated_by ?? this.updated_by,
      is_deleted: is_deleted ?? this.is_deleted,
      franchise: franchise ?? this.franchise,
      addresses: addresses ?? this.addresses,
      bank_details: bank_details ?? this.bank_details,
    );
  }
}
