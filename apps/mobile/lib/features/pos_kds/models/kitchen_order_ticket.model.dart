// Auto-generated Model file for KitchenOrderTicket

class KitchenOrderTicketModel {
  final String id;
  final String branch_id;
  final String order_id;
  final String station;
  final String status;
  final int print_count;
  final String created_at;
  final String updated_at;

  const KitchenOrderTicketModel({
    required this.id,
    required this.branch_id,
    required this.order_id,
    required this.station,
    required this.status,
    required this.print_count,
    required this.created_at,
    required this.updated_at,
  });

  factory KitchenOrderTicketModel.fromJson(Map<String, dynamic> json) {
    return KitchenOrderTicketModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      order_id: json['order_id'] ?? '',
      station: json['station'] ?? '',
      status: json['status'] ?? '',
      print_count: json['print_count'] ?? 0,
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'order_id': order_id,
      'station': station,
      'status': status,
      'print_count': print_count,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  KitchenOrderTicketModel copyWith({
    String? id,
    String? branch_id,
    String? order_id,
    String? station,
    String? status,
    int? print_count,
    String? created_at,
    String? updated_at,
  }) {
    return KitchenOrderTicketModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      order_id: order_id ?? this.order_id,
      station: station ?? this.station,
      status: status ?? this.status,
      print_count: print_count ?? this.print_count,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }
}
