// ignore_for_file: non_constant_identifier_names

class UserModel {
  final String id;
  final String email;
  final String name;
  final String token;
  final String user_id;
  final String image;
  final String cover;
  final String bio;
  final String created_at;
  final String updated_at;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
    required this.user_id,
    required this.image,
    required this.cover,
    required this.bio,
    required this.created_at,
    required this.updated_at,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? token,
    String? user_id,
    String? image,
    String? cover,
    String? bio,
    String? created_at,
    String? updated_at,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      token: token ?? this.token,
      user_id: user_id ?? this.user_id,
      image: image ?? this.image,
      cover: cover ?? this.cover,
      bio: bio ?? this.bio,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      email: json['email'],
      name: json['name'],
      token: json['token'],
      user_id: json['user_id'],
      image: json['image'],
      cover: json['cover'],
      bio: json['bio'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'token': token,
      'user_id': user_id,
      'image': image,
      'cover': cover,
      'bio': bio,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
