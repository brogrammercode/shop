// Auto-generated Model file for Franchise

import '../finance/bank_detail.model.dart';

class FranchiseModel {
  final String id;
  final String branch_id;
  final String owner_name;
  final double royalty_pct;
  final String agreement_doc;
  final String created_at;
  final String updated_at;
  final bool is_deleted;
  final List<BankDetailModel> bank_details;

  const FranchiseModel({
    required this.id,
    required this.branch_id,
    required this.owner_name,
    required this.royalty_pct,
    required this.agreement_doc,
    required this.created_at,
    required this.updated_at,
    required this.is_deleted,
    required this.bank_details,
  });

  factory FranchiseModel.fromJson(Map<String, dynamic> json) {
    return FranchiseModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      owner_name: json['owner_name'] ?? '',
      royalty_pct: json['royalty_pct'] ?? 0.0,
      agreement_doc: json['agreement_doc'] ?? '',
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
      'owner_name': owner_name,
      'royalty_pct': royalty_pct,
      'agreement_doc': agreement_doc,
      'created_at': created_at,
      'updated_at': updated_at,
      'is_deleted': is_deleted,
      'bank_details': bank_details.map((x) => x.toJson()).toList(),
    };
  }

  FranchiseModel copyWith({
    String? id,
    String? branch_id,
    String? owner_name,
    double? royalty_pct,
    String? agreement_doc,
    String? created_at,
    String? updated_at,
    bool? is_deleted,
    List<BankDetailModel>? bank_details,
  }) {
    return FranchiseModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      owner_name: owner_name ?? this.owner_name,
      royalty_pct: royalty_pct ?? this.royalty_pct,
      agreement_doc: agreement_doc ?? this.agreement_doc,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_deleted: is_deleted ?? this.is_deleted,
      bank_details: bank_details ?? this.bank_details,
    );
  }
}
