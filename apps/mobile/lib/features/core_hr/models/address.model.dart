// Auto-generated Model file for Address

class AddressModel {
  final String id;
  final String entity_type;
  final String entity_id;
  final double lat;
  final double long;
  final String area;
  final String locality;
  final String city;
  final String state;
  final String country;
  final String pin_code;
  final String created_at;
  final String updated_at;

  const AddressModel({
    required this.id,
    required this.entity_type,
    required this.entity_id,
    required this.lat,
    required this.long,
    required this.area,
    required this.locality,
    required this.city,
    required this.state,
    required this.country,
    required this.pin_code,
    required this.created_at,
    required this.updated_at,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? '',
      entity_type: json['entity_type'] ?? '',
      entity_id: json['entity_id'] ?? '',
      lat: json['lat'] ?? 0.0,
      long: json['long'] ?? 0.0,
      area: json['area'] ?? '',
      locality: json['locality'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      pin_code: json['pin_code'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entity_type': entity_type,
      'entity_id': entity_id,
      'lat': lat,
      'long': long,
      'area': area,
      'locality': locality,
      'city': city,
      'state': state,
      'country': country,
      'pin_code': pin_code,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  AddressModel copyWith({
    String? id,
    String? entity_type,
    String? entity_id,
    double? lat,
    double? long,
    String? area,
    String? locality,
    String? city,
    String? state,
    String? country,
    String? pin_code,
    String? created_at,
    String? updated_at,
  }) {
    return AddressModel(
      id: id ?? this.id,
      entity_type: entity_type ?? this.entity_type,
      entity_id: entity_id ?? this.entity_id,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      area: area ?? this.area,
      locality: locality ?? this.locality,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      pin_code: pin_code ?? this.pin_code,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }
}
