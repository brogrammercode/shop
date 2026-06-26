// Auto-generated Model file for LedgerEntry

class LedgerEntryModel {
  final String id;
  final String branch_id;
  final String account_id;
  final double debit;
  final double credit;
  final String reference_type;
  final String reference_id;
  final String notes;
  final String created_at;
  final String updated_at;
  final String created_by;

  const LedgerEntryModel({
    required this.id,
    required this.branch_id,
    required this.account_id,
    required this.debit,
    required this.credit,
    required this.reference_type,
    required this.reference_id,
    required this.notes,
    required this.created_at,
    required this.updated_at,
    required this.created_by,
  });

  factory LedgerEntryModel.fromJson(Map<String, dynamic> json) {
    return LedgerEntryModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      account_id: json['account_id'] ?? '',
      debit: json['debit'] ?? 0.0,
      credit: json['credit'] ?? 0.0,
      reference_type: json['reference_type'] ?? '',
      reference_id: json['reference_id'] ?? '',
      notes: json['notes'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      created_by: json['created_by'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'account_id': account_id,
      'debit': debit,
      'credit': credit,
      'reference_type': reference_type,
      'reference_id': reference_id,
      'notes': notes,
      'created_at': created_at,
      'updated_at': updated_at,
      'created_by': created_by,
    };
  }

  LedgerEntryModel copyWith({
    String? id,
    String? branch_id,
    String? account_id,
    double? debit,
    double? credit,
    String? reference_type,
    String? reference_id,
    String? notes,
    String? created_at,
    String? updated_at,
    String? created_by,
  }) {
    return LedgerEntryModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      account_id: account_id ?? this.account_id,
      debit: debit ?? this.debit,
      credit: credit ?? this.credit,
      reference_type: reference_type ?? this.reference_type,
      reference_id: reference_id ?? this.reference_id,
      notes: notes ?? this.notes,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      created_by: created_by ?? this.created_by,
    );
  }
}
