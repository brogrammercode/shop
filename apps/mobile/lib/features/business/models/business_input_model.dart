class BusinessInputModel {
  final String name;
  final String email;
  final String phone;
  final String address;

  const BusinessInputModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'phone': phone, 'address': address};
  }
}
