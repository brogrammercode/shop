class UserModel {
  final String id;
  final String email;
  final String name;
  final String token;
  final String username;
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
    required this.username,
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
    String? username,
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
      username: username ?? this.username,
      image: image ?? this.image,
      cover: cover ?? this.cover,
      bio: bio ?? this.bio,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      token: (json['token'] ?? json['accessToken'] ?? '').toString(),
      username: (json['username'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      cover: (json['cover'] ?? '').toString(),
      bio: (json['bio'] ?? '').toString(),
      created_at: (json['created_at'] ?? '').toString(),
      updated_at: (json['updated_at'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'token': token,
      'username': username,
      'image': image,
      'cover': cover,
      'bio': bio,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
