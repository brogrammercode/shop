// Auto-generated Model file for UserLog

class UserLogModel {
  final String id;
  final String uid;
  final String action;
  final String ip_address;
  final String device_info;
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
    required this.action,
    required this.ip_address,
    required this.device_info,
    required this.type,
    required this.module,
    required this.title,
    required this.description,
    required this.meta,
    required this.ref_link,
    required this.created_at,
    required this.updated_at,
  });

  factory UserLogModel.fromJson(Map<String, dynamic> json) {
    return UserLogModel(
      id: json['id'] ?? '',
      uid: json['uid'] ?? '',
      action: json['action'] ?? '',
      ip_address: json['ip_address'] ?? '',
      device_info: json['device_info'] ?? '',
      type: json['type'] ?? '',
      module: json['module'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      meta: json['meta'] ?? {},
      ref_link: json['ref_link'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'action': action,
      'ip_address': ip_address,
      'device_info': device_info,
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

  UserLogModel copyWith({
    String? id,
    String? uid,
    String? action,
    String? ip_address,
    String? device_info,
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
      action: action ?? this.action,
      ip_address: ip_address ?? this.ip_address,
      device_info: device_info ?? this.device_info,
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
}
