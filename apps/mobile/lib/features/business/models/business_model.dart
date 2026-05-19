class BusinessModel {
  final String id;
  final String name;
  final String logo;
  final String email;
  final String phone;
  final String address;
  final String created_at;
  final String updated_at;

  const BusinessModel({
    required this.id,
    required this.name,
    required this.logo,
    required this.email,
    required this.phone,
    required this.address,
    required this.created_at,
    required this.updated_at,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      logo: (json['logo'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      created_at: (json['created_at'] ?? '').toString(),
      updated_at: (json['updated_at'] ?? '').toString(),
    );
  }

  BusinessModel copyWith({
    String? id,
    String? name,
    String? logo,
    String? email,
    String? phone,
    String? address,
    String? created_at,
    String? updated_at,
  }) {
    return BusinessModel(
      id: id ?? this.id,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'email': email,
      'phone': phone,
      'address': address,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
