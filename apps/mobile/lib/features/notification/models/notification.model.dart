class AppNotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final String time;
  final bool read;
  final String ref_type;
  final String ref_link;
  final String module;
  final String actor_id;
  final List<String> receipent_ids;
  final List<String> channels;

  const AppNotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.time,
    required this.read,
    required this.ref_type,
    required this.ref_link,
    required this.module,
    required this.actor_id,
    required this.receipent_ids,
    required this.channels,
  });

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    return AppNotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      time:
          json['time']?.toString() ??
          json['created_at']?.toString() ??
          json['updated_at']?.toString() ??
          '',
      read: json['read'] == true,
      ref_type: json['ref_type']?.toString() ?? '',
      ref_link: json['ref_link']?.toString() ?? '',
      module: json['module']?.toString() ?? '',
      actor_id: json['actor_id']?.toString() ?? '',
      receipent_ids: _stringList(json['receipent_ids']),
      channels: _stringList(json['channels']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'time': time,
      'read': read,
      'ref_type': ref_type,
      'ref_link': ref_link,
      'module': module,
      'actor_id': actor_id,
      'receipent_ids': receipent_ids,
      'channels': channels,
    };
  }

  AppNotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    String? time,
    bool? read,
    String? ref_type,
    String? ref_link,
    String? module,
    String? actor_id,
    List<String>? receipent_ids,
    List<String>? channels,
  }) {
    return AppNotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      time: time ?? this.time,
      read: read ?? this.read,
      ref_type: ref_type ?? this.ref_type,
      ref_link: ref_link ?? this.ref_link,
      module: module ?? this.module,
      actor_id: actor_id ?? this.actor_id,
      receipent_ids: receipent_ids ?? this.receipent_ids,
      channels: channels ?? this.channels,
    );
  }

  static List<String> _stringList(dynamic value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    return const [];
  }
}
