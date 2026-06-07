class RoleModel {
  final String id;
  final String branch_id;
  final String name;
  final List<String> permissions;
  final String created_at;
  final String updated_at;

  const RoleModel({
    required this.id,
    required this.branch_id,
    required this.name,
    required this.permissions,
    required this.created_at,
    required this.updated_at,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: (json['id'] ?? '').toString(),
      branch_id: (json['branch_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      permissions: List<String>.from(json['permissions'] ?? []),
      created_at: (json['created_at'] ?? '').toString(),
      updated_at: (json['updated_at'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'name': name,
      'permissions': permissions,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
