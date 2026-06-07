class UserSessionModel {
  final String id;
  final String uid;
  final String platform;
  final String device_info;
  final String ip_address;
  final String status;
  final String created_at;
  final String updated_at;

  const UserSessionModel({
    required this.id,
    required this.uid,
    required this.platform,
    required this.device_info,
    required this.ip_address,
    required this.status,
    required this.created_at,
    required this.updated_at,
  });

  UserSessionModel copyWith({
    String? id,
    String? uid,
    String? platform,
    String? device_info,
    String? ip_address,
    String? status,
    String? created_at,
    String? updated_at,
  }) {
    return UserSessionModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      platform: platform ?? this.platform,
      device_info: device_info ?? this.device_info,
      ip_address: ip_address ?? this.ip_address,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  factory UserSessionModel.fromJson(Map<String, dynamic> json) {
    return UserSessionModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      uid: (json['uid'] ?? '').toString(),
      platform: (json['platform'] ?? '').toString(),
      device_info: (json['device_info'] ?? json['deviceInfo'] ?? '').toString(),
      ip_address: (json['ip_address'] ?? json['ipAddress'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      created_at: (json['created_at'] ?? '').toString(),
      updated_at: (json['updated_at'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'platform': platform,
      'device_info': device_info,
      'ip_address': ip_address,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}

