class EmployeeModel {
  final String id;
  final String user_id;
  final String name;
  final String email;
  final String phone;
  final String branch_id;
  final String role_id;
  final String shift_id;
  final String post_id;
  final Map<String, dynamic> bank_details;
  final Map<String, dynamic> address;
  final String created_at;
  final String updated_at;

  const EmployeeModel({
    required this.id,
    required this.user_id,
    required this.name,
    required this.email,
    required this.phone,
    required this.branch_id,
    required this.role_id,
    required this.shift_id,
    required this.post_id,
    required this.bank_details,
    required this.address,
    required this.created_at,
    required this.updated_at,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      user_id: (json['user_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      branch_id: (json['branch_id'] ?? '').toString(),
      role_id: (json['role_id'] ?? '').toString(),
      shift_id: (json['shift_id'] ?? '').toString(),
      post_id: (json['post_id'] ?? '').toString(),
      bank_details: Map<String, dynamic>.from(json['bank_details'] ?? {}),
      address: Map<String, dynamic>.from(json['address'] ?? {}),
      created_at: (json['created_at'] ?? '').toString(),
      updated_at: (json['updated_at'] ?? '').toString(),
    );
  }

  EmployeeModel copyWith({
    String? id,
    String? user_id,
    String? name,
    String? email,
    String? phone,
    String? branch_id,
    String? role_id,
    String? shift_id,
    String? post_id,
    Map<String, dynamic>? bank_details,
    Map<String, dynamic>? address,
    String? created_at,
    String? updated_at,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      branch_id: branch_id ?? this.branch_id,
      role_id: role_id ?? this.role_id,
      shift_id: shift_id ?? this.shift_id,
      post_id: post_id ?? this.post_id,
      bank_details: bank_details ?? this.bank_details,
      address: address ?? this.address,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': user_id,
      'name': name,
      'email': email,
      'phone': phone,
      'branch_id': branch_id,
      'role_id': role_id,
      'shift_id': shift_id,
      'post_id': post_id,
      'bank_details': bank_details,
      'address': address,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
