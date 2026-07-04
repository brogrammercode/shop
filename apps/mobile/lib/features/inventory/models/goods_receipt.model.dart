// Auto-generated Model file for GoodsReceipt

class GoodsReceiptModel {
  final String id;
  final String branch_id;
  final String po_id;
  final String received_date;
  final String invoice_number;
  final String notes;
  final String created_at;
  final String updated_at;
  final String received_by;

  const GoodsReceiptModel({
    required this.id,
    required this.branch_id,
    required this.po_id,
    required this.received_date,
    required this.invoice_number,
    required this.notes,
    required this.created_at,
    required this.updated_at,
    required this.received_by,
  });

  factory GoodsReceiptModel.fromJson(Map<String, dynamic> json) {
    return GoodsReceiptModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      po_id: json['po_id'] ?? '',
      received_date: json['received_date'] ?? '',
      invoice_number: json['invoice_number'] ?? '',
      notes: json['notes'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      received_by: json['received_by'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'po_id': po_id,
      'received_date': received_date,
      'invoice_number': invoice_number,
      'notes': notes,
      'created_at': created_at,
      'updated_at': updated_at,
      'received_by': received_by,
    };
  }

  GoodsReceiptModel copyWith({
    String? id,
    String? branch_id,
    String? po_id,
    String? received_date,
    String? invoice_number,
    String? notes,
    String? created_at,
    String? updated_at,
    String? received_by,
  }) {
    return GoodsReceiptModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      po_id: po_id ?? this.po_id,
      received_date: received_date ?? this.received_date,
      invoice_number: invoice_number ?? this.invoice_number,
      notes: notes ?? this.notes,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      received_by: received_by ?? this.received_by,
    );
  }
}
