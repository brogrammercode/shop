// ignore_for_file: non_constant_identifier_names

class UserActivityModel {
  final String id;
  final String user;
  final String type;
  final String module;
  final String title;
  final String description;
  final String created_at;
  final String updated_at;

  const UserActivityModel({
    required this.id,
    required this.user,
    required this.type,
    required this.module,
    required this.title,
    required this.description,
    required this.created_at,
    required this.updated_at,
  });

  UserActivityModel copyWith({
    String? id,
    String? user,
    String? type,
    String? module,
    String? title,
    String? description,
    String? created_at,
    String? updated_at,
  }) {
    return UserActivityModel(
      id: id ?? this.id,
      user: user ?? this.user,
      type: type ?? this.type,
      module: module ?? this.module,
      title: title ?? this.title,
      description: description ?? this.description,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  factory UserActivityModel.fromJson(Map<String, dynamic> json) {
    return UserActivityModel(
      id: json['_id'] ?? '',
      user: json['user'] ?? '',
      type: json['type'] ?? '',
      module: json['module'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'type': type,
      'module': module,
      'title': title,
      'description': description,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
