// Auto-generated Model file for StockTransfer

class StockTransferModel {
  final String id;
  final String from_branch_id;
  final String to_branch_id;
  final String status;
  final String driver_name;
  final String created_at;
  final String updated_at;
  final String dispatched_by;
  final String received_by;

  const StockTransferModel({
    required this.id,
    required this.from_branch_id,
    required this.to_branch_id,
    required this.status,
    required this.driver_name,
    required this.created_at,
    required this.updated_at,
    required this.dispatched_by,
    required this.received_by,
  });

  factory StockTransferModel.fromJson(Map<String, dynamic> json) {
    return StockTransferModel(
      id: json['id'] ?? '',
      from_branch_id: json['from_branch_id'] ?? '',
      to_branch_id: json['to_branch_id'] ?? '',
      status: json['status'] ?? '',
      driver_name: json['driver_name'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      dispatched_by: json['dispatched_by'] ?? '',
      received_by: json['received_by'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from_branch_id': from_branch_id,
      'to_branch_id': to_branch_id,
      'status': status,
      'driver_name': driver_name,
      'created_at': created_at,
      'updated_at': updated_at,
      'dispatched_by': dispatched_by,
      'received_by': received_by,
    };
  }

  StockTransferModel copyWith({
    String? id,
    String? from_branch_id,
    String? to_branch_id,
    String? status,
    String? driver_name,
    String? created_at,
    String? updated_at,
    String? dispatched_by,
    String? received_by,
  }) {
    return StockTransferModel(
      id: id ?? this.id,
      from_branch_id: from_branch_id ?? this.from_branch_id,
      to_branch_id: to_branch_id ?? this.to_branch_id,
      status: status ?? this.status,
      driver_name: driver_name ?? this.driver_name,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      dispatched_by: dispatched_by ?? this.dispatched_by,
      received_by: received_by ?? this.received_by,
    );
  }
}
