class AddressModel {
  final String street;
  final String city;
  final String state;
  final String zip;
  final String country;

  const AddressModel({
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      street: (json['street'] ?? '').toString(),
      city: (json['city'] ?? '').toString(),
      state: (json['state'] ?? '').toString(),
      zip: (json['zip'] ?? '').toString(),
      country: (json['country'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
    };
  }
}
