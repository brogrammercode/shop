// Auto-generated Model file for PurchaseOrder

class PurchaseOrderModel {
  final String id;
  final String branch_id;
  final String supplier_id;
  final String status;
  final double total_amount;
  final String notes;
  final String created_at;
  final String updated_at;
  final String created_by;
  final String approved_by;

  const PurchaseOrderModel({
    required this.id,
    required this.branch_id,
    required this.supplier_id,
    required this.status,
    required this.total_amount,
    required this.notes,
    required this.created_at,
    required this.updated_at,
    required this.created_by,
    required this.approved_by,
  });

  factory PurchaseOrderModel.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      supplier_id: json['supplier_id'] ?? '',
      status: json['status'] ?? '',
      total_amount: json['total_amount'] ?? 0.0,
      notes: json['notes'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      created_by: json['created_by'] ?? '',
      approved_by: json['approved_by'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'supplier_id': supplier_id,
      'status': status,
      'total_amount': total_amount,
      'notes': notes,
      'created_at': created_at,
      'updated_at': updated_at,
      'created_by': created_by,
      'approved_by': approved_by,
    };
  }

  PurchaseOrderModel copyWith({
    String? id,
    String? branch_id,
    String? supplier_id,
    String? status,
    double? total_amount,
    String? notes,
    String? created_at,
    String? updated_at,
    String? created_by,
    String? approved_by,
  }) {
    return PurchaseOrderModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      supplier_id: supplier_id ?? this.supplier_id,
      status: status ?? this.status,
      total_amount: total_amount ?? this.total_amount,
      notes: notes ?? this.notes,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      created_by: created_by ?? this.created_by,
      approved_by: approved_by ?? this.approved_by,
    );
  }
}
