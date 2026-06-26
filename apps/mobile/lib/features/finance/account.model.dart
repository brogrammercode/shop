// Auto-generated Model file for Account

import 'bank_detail.model.dart';

class AccountModel {
  final String id;
  final String branch_id;
  final String name;
  final String avatar;
  final String account_type;
  final String status;
  final String created_at;
  final String updated_at;
  final bool is_deleted;
  final List<BankDetailModel> bank_details;

  const AccountModel({
    required this.id,
    required this.branch_id,
    required this.name,
    required this.avatar,
    required this.account_type,
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.is_deleted,
    required this.bank_details,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      account_type: json['account_type'] ?? '',
      status: json['status'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      is_deleted: json['is_deleted'] ?? false,
      bank_details: (json['bank_details'] as List<dynamic>? ?? []).map((x) => BankDetailModel.fromJson(x as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'name': name,
      'avatar': avatar,
      'account_type': account_type,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'is_deleted': is_deleted,
      'bank_details': bank_details.map((x) => x.toJson()).toList(),
    };
  }

  AccountModel copyWith({
    String? id,
    String? branch_id,
    String? name,
    String? avatar,
    String? account_type,
    String? status,
    String? created_at,
    String? updated_at,
    bool? is_deleted,
    List<BankDetailModel>? bank_details,
  }) {
    return AccountModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      account_type: account_type ?? this.account_type,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_deleted: is_deleted ?? this.is_deleted,
      bank_details: bank_details ?? this.bank_details,
    );
  }
}
