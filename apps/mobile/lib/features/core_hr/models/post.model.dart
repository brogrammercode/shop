// Auto-generated Model file for Post

class PostModel {
  final String id;
  final String branch_id;
  final String department_id;
  final String name;
  final String description;
  final String status;
  final String created_at;
  final String updated_at;
  final bool is_deleted;

  const PostModel({
    required this.id,
    required this.branch_id,
    required this.department_id,
    required this.name,
    required this.description,
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.is_deleted,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      department_id: json['department_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
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
      'department_id': department_id,
      'name': name,
      'description': description,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'is_deleted': is_deleted,
    };
  }

  PostModel copyWith({
    String? id,
    String? branch_id,
    String? department_id,
    String? name,
    String? description,
    String? status,
    String? created_at,
    String? updated_at,
    bool? is_deleted,
  }) {
    return PostModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      department_id: department_id ?? this.department_id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_deleted: is_deleted ?? this.is_deleted,
    );
  }
}
