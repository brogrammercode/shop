class DepartmentModel {
  final String id;
  final String name;
  final String branch_id;
  final String created_at;
  final String updated_at;

  const DepartmentModel({
    required this.id,
    required this.name,
    required this.branch_id,
    required this.created_at,
    required this.updated_at,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      branch_id: (json['branch_id'] ?? '').toString(),
      created_at: (json['created_at'] ?? '').toString(),
      updated_at: (json['updated_at'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'branch_id': branch_id,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
