// Auto-generated Model file for QCAudit

class QCAuditModel {
  final String id;
  final String branch_id;
  final String batch_id;
  final String audit_type;
  final String result_value;
  final String notes;
  final String created_at;
  final String updated_at;
  final String auditor_name;

  const QCAuditModel({
    required this.id,
    required this.branch_id,
    required this.batch_id,
    required this.audit_type,
    required this.result_value,
    required this.notes,
    required this.created_at,
    required this.updated_at,
    required this.auditor_name,
  });

  factory QCAuditModel.fromJson(Map<String, dynamic> json) {
    return QCAuditModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      batch_id: json['batch_id'] ?? '',
      audit_type: json['audit_type'] ?? '',
      result_value: json['result_value'] ?? '',
      notes: json['notes'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      auditor_name: json['auditor_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'batch_id': batch_id,
      'audit_type': audit_type,
      'result_value': result_value,
      'notes': notes,
      'created_at': created_at,
      'updated_at': updated_at,
      'auditor_name': auditor_name,
    };
  }

  QCAuditModel copyWith({
    String? id,
    String? branch_id,
    String? batch_id,
    String? audit_type,
    String? result_value,
    String? notes,
    String? created_at,
    String? updated_at,
    String? auditor_name,
  }) {
    return QCAuditModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      batch_id: batch_id ?? this.batch_id,
      audit_type: audit_type ?? this.audit_type,
      result_value: result_value ?? this.result_value,
      notes: notes ?? this.notes,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      auditor_name: auditor_name ?? this.auditor_name,
    );
  }
}
