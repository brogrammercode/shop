// Auto-generated Model file for ProductionBatch

class ProductionBatchModel {
  final String id;
  final String branch_id;
  final String bom_id;
  final String status;
  final double planned_qty;
  final double produced_qty;
  final String expiry_date;
  final String notes;
  final String created_at;
  final String updated_at;
  final String started_by;
  final String completed_by;

  const ProductionBatchModel({
    required this.id,
    required this.branch_id,
    required this.bom_id,
    required this.status,
    required this.planned_qty,
    required this.produced_qty,
    required this.expiry_date,
    required this.notes,
    required this.created_at,
    required this.updated_at,
    required this.started_by,
    required this.completed_by,
  });

  factory ProductionBatchModel.fromJson(Map<String, dynamic> json) {
    return ProductionBatchModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      bom_id: json['bom_id'] ?? '',
      status: json['status'] ?? '',
      planned_qty: json['planned_qty'] ?? 0.0,
      produced_qty: json['produced_qty'] ?? 0.0,
      expiry_date: json['expiry_date'] ?? '',
      notes: json['notes'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      started_by: json['started_by'] ?? '',
      completed_by: json['completed_by'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'bom_id': bom_id,
      'status': status,
      'planned_qty': planned_qty,
      'produced_qty': produced_qty,
      'expiry_date': expiry_date,
      'notes': notes,
      'created_at': created_at,
      'updated_at': updated_at,
      'started_by': started_by,
      'completed_by': completed_by,
    };
  }

  ProductionBatchModel copyWith({
    String? id,
    String? branch_id,
    String? bom_id,
    String? status,
    double? planned_qty,
    double? produced_qty,
    String? expiry_date,
    String? notes,
    String? created_at,
    String? updated_at,
    String? started_by,
    String? completed_by,
  }) {
    return ProductionBatchModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      bom_id: bom_id ?? this.bom_id,
      status: status ?? this.status,
      planned_qty: planned_qty ?? this.planned_qty,
      produced_qty: produced_qty ?? this.produced_qty,
      expiry_date: expiry_date ?? this.expiry_date,
      notes: notes ?? this.notes,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      started_by: started_by ?? this.started_by,
      completed_by: completed_by ?? this.completed_by,
    );
  }
}
