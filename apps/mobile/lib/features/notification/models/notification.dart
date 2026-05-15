// ignore_for_file: non_constant_identifier_names

class NotificationModel {
  final String id;
  final String user;
  final String type;
  final String module;
  final String title;
  final String description;
  final List<String> channels;
  final List<String> red_by;
  final String created_at;
  final String updated_at;

  const NotificationModel({
    required this.id,
    required this.user,
    required this.type,
    required this.module,
    required this.title,
    required this.description,
    required this.channels,
    required this.red_by,
    required this.created_at,
    required this.updated_at,
  });

  NotificationModel copyWith({
    String? id,
    String? user,
    String? type,
    String? module,
    String? title,
    String? description,
    List<String>? channels,
    List<String>? red_by,
    String? created_at,
    String? updated_at,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      user: user ?? this.user,
      type: type ?? this.type,
      module: module ?? this.module,
      title: title ?? this.title,
      description: description ?? this.description,
      channels: channels ?? this.channels,
      red_by: red_by ?? this.red_by,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      user: json['user'],
      type: json['type'],
      module: json['module'],
      title: json['title'],
      description: json['description'],
      channels: json['channels'] != null
          ? json['channels'].map<String>((x) => x.toString()).toList()
          : [],
      red_by: json['red_by'] != null
          ? json['red_by'].map<String>((x) => x.toString()).toList()
          : [],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
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
      'channels': channels,
      'red_by': red_by,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
