// Auto-generated Model file for TableZone

class TableZoneModel {
  final String id;
  final String branch_id;
  final String name;
  final String created_at;
  final String updated_at;
  final bool is_deleted;

  const TableZoneModel({
    required this.id,
    required this.branch_id,
    required this.name,
    required this.created_at,
    required this.updated_at,
    required this.is_deleted,
  });

  factory TableZoneModel.fromJson(Map<String, dynamic> json) {
    return TableZoneModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      name: json['name'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      is_deleted: json['is_deleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'name': name,
      'created_at': created_at,
      'updated_at': updated_at,
      'is_deleted': is_deleted,
    };
  }

  TableZoneModel copyWith({
    String? id,
    String? branch_id,
    String? name,
    String? created_at,
    String? updated_at,
    bool? is_deleted,
  }) {
    return TableZoneModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      name: name ?? this.name,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_deleted: is_deleted ?? this.is_deleted,
    );
  }
}
