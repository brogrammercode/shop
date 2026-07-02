// Auto-generated Model file for Role

class RoleModel {
  final String id;
  final String branch_id;
  final String name;
  final List<String> permissions;
  final String status;
  final String created_at;
  final String updated_at;
  final bool is_deleted;

  const RoleModel({
    required this.id,
    required this.branch_id,
    required this.name,
    required this.permissions,
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.is_deleted,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      name: json['name'] ?? '',
      permissions: List<String>.from(json['permissions'] ?? []),
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
      'name': name,
      'permissions': permissions,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'is_deleted': is_deleted,
    };
  }

  RoleModel copyWith({
    String? id,
    String? branch_id,
    String? name,
    List<String>? permissions,
    String? status,
    String? created_at,
    String? updated_at,
    bool? is_deleted,
  }) {
    return RoleModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      name: name ?? this.name,
      permissions: permissions ?? this.permissions,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_deleted: is_deleted ?? this.is_deleted,
    );
  }
}
