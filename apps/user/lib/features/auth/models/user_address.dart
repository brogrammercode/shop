class UserAddressModel {
  final String id;
  final String uid;
  final String phone_number;
  final String receiver_name;
  final String type;
  final String name;
  final String street;
  final String country_code;
  final String country;
  final String postal_code;
  final String administrative_area;
  final String sub_administrative_area;
  final String locality;
  final String sub_locality;
  final double latitude;
  final double longitude;
  final bool is_default;
  final String created_at;
  final String updated_at;

  const UserAddressModel({
    required this.id,
    required this.uid,
    required this.phone_number,
    required this.receiver_name,
    required this.type,
    required this.name,
    required this.street,
    required this.country_code,
    required this.country,
    required this.postal_code,
    required this.administrative_area,
    required this.sub_administrative_area,
    required this.locality,
    required this.sub_locality,
    required this.latitude,
    required this.longitude,
    required this.is_default,
    required this.created_at,
    required this.updated_at,
  });

  UserAddressModel copyWith({
    String? id,
    String? uid,
    String? phone_number,
    String? receiver_name,
    String? type,
    String? name,
    String? street,
    String? country_code,
    String? country,
    String? postal_code,
    String? administrative_area,
    String? sub_administrative_area,
    String? locality,
    String? sub_locality,
    bool? is_default,
    double? latitude,
    double? longitude,
    String? created_at,
    String? updated_at,
  }) {
    return UserAddressModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      phone_number: phone_number ?? this.phone_number,
      receiver_name: receiver_name ?? this.receiver_name,
      type: type ?? this.type,
      name: name ?? this.name,
      street: street ?? this.street,
      country_code: country_code ?? this.country_code,
      country: country ?? this.country,
      postal_code: postal_code ?? this.postal_code,
      administrative_area: administrative_area ?? this.administrative_area,
      sub_administrative_area:
          sub_administrative_area ?? this.sub_administrative_area,
      locality: locality ?? this.locality,
      sub_locality: sub_locality ?? this.sub_locality,
      is_default: is_default ?? this.is_default,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  factory UserAddressModel.fromJson(Map<String, dynamic> json) {
    return UserAddressModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      uid: (json['uid'] ?? '').toString(),
      phone_number: (json['phone_number'] ?? '').toString(),
      receiver_name: (json['receiver_name'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      street: (json['street'] ?? '').toString(),
      country_code: (json['country_code'] ?? json['isoCountryCode'] ?? '')
          .toString(),
      country: (json['country'] ?? '').toString(),
      postal_code: (json['postal_code'] ?? json['postalCode'] ?? '').toString(),
      administrative_area:
          (json['administrative_area'] ?? json['administrativeArea'] ?? '')
              .toString(),
      sub_administrative_area:
          (json['sub_administrative_area'] ??
                  json['subAdministrativeArea'] ??
                  '')
              .toString(),
      locality: (json['locality'] ?? '').toString(),
      sub_locality: (json['sub_locality'] ?? json['subLocality'] ?? '')
          .toString(),
      is_default: json['is_default'] == true,
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      created_at: (json['created_at'] ?? '').toString(),
      updated_at: (json['updated_at'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'phone_number': phone_number,
      'receiver_name': receiver_name,
      'type': type,
      'name': name,
      'street': street,
      'country_code': country_code,
      'country': country,
      'postal_code': postal_code,
      'administrative_area': administrative_area,
      'sub_administrative_area': sub_administrative_area,
      'locality': locality,
      'sub_locality': sub_locality,
      'is_default': is_default,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
