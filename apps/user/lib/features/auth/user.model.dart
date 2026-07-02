class UserModel {
  final String id;
  final String name;
  final String phone_number;
  final String avatar_url;
  final String? email;
  final String created_at;
  final String updated_at;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone_number,
    required this.avatar_url,
    this.email,
    required this.created_at,
    required this.updated_at,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? phone_number,
    String? avatar_url,
    String? email,
    String? created_at,
    String? updated_at,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone_number: phone_number ?? this.phone_number,
      avatar_url: avatar_url ?? this.avatar_url,
      email: email ?? this.email,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      phone_number: (json['phone_number'] ?? '').toString(),
      avatar_url: (json['avatar_url'] ?? '').toString(),
      email: json['email']?.toString(),
      created_at: (json['created_at'] ?? '').toString(),
      updated_at: (json['updated_at'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phone_number,
      'avatar_url': avatar_url,
      if (email != null) 'email': email,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
