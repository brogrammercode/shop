class TableModel {
  final String id;
  final String branch_id;
  final String zone_id;
  final String table_number;
  final int capacity;
  final int side_count;
  final List<String> side_labels;
  final String status;
  final String created_at;
  final String updated_at;
  final bool is_deleted;

  const TableModel({
    required this.id,
    required this.branch_id,
    required this.zone_id,
    required this.table_number,
    required this.capacity,
    required this.side_count,
    required this.side_labels,
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.is_deleted,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      zone_id: json['zone_id'] ?? '',
      table_number: json['table_number'] ?? '',
      capacity: json['capacity'] ?? 0,
      side_count: json['side_count'] ?? 4,
      side_labels:
          (json['side_labels'] as List?)
              ?.map<String>((value) => value.toString())
              .toList() ??
          const [],
      status: json['status'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      is_deleted: json['is_deleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'zone_id': zone_id,
      'table_number': table_number,
      'capacity': capacity,
      'side_count': side_count,
      'side_labels': side_labels,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'is_deleted': is_deleted,
    };
  }

  TableModel copyWith({
    String? id,
    String? branch_id,
    String? zone_id,
    String? table_number,
    int? capacity,
    int? side_count,
    List<String>? side_labels,
    String? status,
    String? created_at,
    String? updated_at,
    bool? is_deleted,
  }) {
    return TableModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      zone_id: zone_id ?? this.zone_id,
      table_number: table_number ?? this.table_number,
      capacity: capacity ?? this.capacity,
      side_count: side_count ?? this.side_count,
      side_labels: side_labels ?? this.side_labels,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_deleted: is_deleted ?? this.is_deleted,
    );
  }
}
