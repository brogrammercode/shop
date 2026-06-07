class OtpModel {
  final String id;
  final String actor;
  final String otp;
  final String type;
  final String valid_till;
  final String created_at;
  final String updated_at;

  const OtpModel({
    required this.id,
    required this.actor,
    required this.otp,
    required this.type,
    required this.valid_till,
    required this.created_at,
    required this.updated_at,
  });

  factory OtpModel.fromJson(Map<String, dynamic> json) {
    return OtpModel(
      id: json['id'] ?? '',
      actor: json['actor'] ?? '',
      otp: json['otp'] ?? '',
      type: json['type'] ?? '',
      valid_till: json['valid_till'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'actor': actor,
      'otp': otp,
      'type': type,
      'valid_till': valid_till,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  OtpModel copyWith({
    String? id,
    String? actor,
    String? otp,
    String? type,
    String? valid_till,
    String? created_at,
    String? updated_at,
  }) {
    return OtpModel(
      id: id ?? this.id,
      actor: actor ?? this.actor,
      otp: otp ?? this.otp,
      type: type ?? this.type,
      valid_till: valid_till ?? this.valid_till,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }
}
