class AdBannerModel {
  final String id;
  final String image_url;
  final String link_url;
  final String type;
  final String status;
  final String valid_from;
  final String valid_to;
  final String created_at;
  final String updated_at;

  const AdBannerModel({
    required this.id,
    required this.image_url,
    required this.link_url,
    required this.type,
    required this.status,
    required this.valid_from,
    required this.valid_to,
    required this.created_at,
    required this.updated_at,
  });

  AdBannerModel copyWith({
    String? id,
    String? image_url,
    String? link_url,
    String? type,
    String? status,
    String? valid_from,
    String? valid_to,
    String? created_at,
    String? updated_at,
  }) {
    return AdBannerModel(
      id: id ?? this.id,
      image_url: image_url ?? this.image_url,
      link_url: link_url ?? this.link_url,
      type: type ?? this.type,
      status: status ?? this.status,
      valid_from: valid_from ?? this.valid_from,
      valid_to: valid_to ?? this.valid_to,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  factory AdBannerModel.fromJson(Map<String, dynamic> json) {
    return AdBannerModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      image_url: (json['image_url'] ?? json['imageUrl'] ?? '').toString(),
      link_url: (json['link_url'] ?? json['linkUrl'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      valid_from: (json['valid_from'] ?? json['validFrom'] ?? '').toString(),
      valid_to: (json['valid_to'] ?? json['validTo'] ?? '').toString(),
      created_at: (json['created_at'] ?? '').toString(),
      updated_at: (json['updated_at'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': image_url,
      'link_url': link_url,
      'type': type,
      'status': status,
      'valid_from': valid_from,
      'valid_to': valid_to,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
