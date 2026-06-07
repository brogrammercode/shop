class UserLogModel {
  final String id;
  final String uid;
  final String type;
  final String module;
  final String title;
  final String description;
  final Map<String, dynamic> meta;
  final String ref_link;
  final String created_at;
  final String updated_at;

  const UserLogModel({
    required this.id,
    required this.uid,
    required this.type,
    required this.module,
    required this.title,
    required this.description,
    required this.meta,
    required this.ref_link,
    required this.created_at,
    required this.updated_at,
  });

  UserLogModel copyWith({
    String? id,
    String? uid,
    String? type,
    String? module,
    String? title,
    String? description,
    Map<String, dynamic>? meta,
    String? ref_link,
    String? created_at,
    String? updated_at,
  }) {
    return UserLogModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      type: type ?? this.type,
      module: module ?? this.module,
      title: title ?? this.title,
      description: description ?? this.description,
      meta: meta ?? this.meta,
      ref_link: ref_link ?? this.ref_link,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  factory UserLogModel.fromJson(Map<String, dynamic> json) {
    return UserLogModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      uid: (json['uid'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      module: (json['module'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      meta: Map<String, dynamic>.from(json['meta'] ?? {}),
      ref_link: (json['ref_link'] ?? '').toString(),
      created_at: (json['created_at'] ?? '').toString(),
      updated_at: (json['updated_at'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'type': type,
      'module': module,
      'title': title,
      'description': description,
      'meta': meta,
      'ref_link': ref_link,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}

