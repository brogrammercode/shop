// Auto-generated Model file for VendorReturn

class VendorReturnModel {
  final String id;
  final String branch_id;
  final String po_id;
  final String return_reason;
  final double refund_value;
  final String status;
  final String created_at;
  final String updated_at;
  final String processed_by;

  const VendorReturnModel({
    required this.id,
    required this.branch_id,
    required this.po_id,
    required this.return_reason,
    required this.refund_value,
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.processed_by,
  });

  factory VendorReturnModel.fromJson(Map<String, dynamic> json) {
    return VendorReturnModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      po_id: json['po_id'] ?? '',
      return_reason: json['return_reason'] ?? '',
      refund_value: json['refund_value'] ?? 0.0,
      status: json['status'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      processed_by: json['processed_by'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'po_id': po_id,
      'return_reason': return_reason,
      'refund_value': refund_value,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'processed_by': processed_by,
    };
  }

  VendorReturnModel copyWith({
    String? id,
    String? branch_id,
    String? po_id,
    String? return_reason,
    double? refund_value,
    String? status,
    String? created_at,
    String? updated_at,
    String? processed_by,
  }) {
    return VendorReturnModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      po_id: po_id ?? this.po_id,
      return_reason: return_reason ?? this.return_reason,
      refund_value: refund_value ?? this.refund_value,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      processed_by: processed_by ?? this.processed_by,
    );
  }
}
