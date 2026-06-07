class PostModel {
  final String id;
  final String name;
  final String department_id;
  final String created_at;
  final String updated_at;

  const PostModel({
    required this.id,
    required this.name,
    required this.department_id,
    required this.created_at,
    required this.updated_at,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      department_id: (json['department_id'] ?? '').toString(),
      created_at: (json['created_at'] ?? '').toString(),
      updated_at: (json['updated_at'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'department_id': department_id,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
