// Auto-generated Model file for BankDetail

class BankDetailModel {
  final String id;
  final String entity_type;
  final String entity_id;
  final String bank_name;
  final String account_name;
  final String account_number;
  final String ifsc_code;
  final String swift_code;
  final String branch_name;
  final bool is_primary;
  final String created_at;
  final String updated_at;

  const BankDetailModel({
    required this.id,
    required this.entity_type,
    required this.entity_id,
    required this.bank_name,
    required this.account_name,
    required this.account_number,
    required this.ifsc_code,
    required this.swift_code,
    required this.branch_name,
    required this.is_primary,
    required this.created_at,
    required this.updated_at,
  });

  factory BankDetailModel.fromJson(Map<String, dynamic> json) {
    return BankDetailModel(
      id: json['id'] ?? '',
      entity_type: json['entity_type'] ?? '',
      entity_id: json['entity_id'] ?? '',
      bank_name: json['bank_name'] ?? '',
      account_name: json['account_name'] ?? '',
      account_number: json['account_number'] ?? '',
      ifsc_code: json['ifsc_code'] ?? '',
      swift_code: json['swift_code'] ?? '',
      branch_name: json['branch_name'] ?? '',
      is_primary: json['is_primary'] ?? false,
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entity_type': entity_type,
      'entity_id': entity_id,
      'bank_name': bank_name,
      'account_name': account_name,
      'account_number': account_number,
      'ifsc_code': ifsc_code,
      'swift_code': swift_code,
      'branch_name': branch_name,
      'is_primary': is_primary,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  BankDetailModel copyWith({
    String? id,
    String? entity_type,
    String? entity_id,
    String? bank_name,
    String? account_name,
    String? account_number,
    String? ifsc_code,
    String? swift_code,
    String? branch_name,
    bool? is_primary,
    String? created_at,
    String? updated_at,
  }) {
    return BankDetailModel(
      id: id ?? this.id,
      entity_type: entity_type ?? this.entity_type,
      entity_id: entity_id ?? this.entity_id,
      bank_name: bank_name ?? this.bank_name,
      account_name: account_name ?? this.account_name,
      account_number: account_number ?? this.account_number,
      ifsc_code: ifsc_code ?? this.ifsc_code,
      swift_code: swift_code ?? this.swift_code,
      branch_name: branch_name ?? this.branch_name,
      is_primary: is_primary ?? this.is_primary,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }
}
