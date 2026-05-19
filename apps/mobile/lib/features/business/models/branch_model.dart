class BranchModel {
  final String id;
  final String name;
  final String business_id;
  final String address;
  final String created_at;
  final String updated_at;

  const BranchModel({
    required this.id,
    required this.name,
    required this.business_id,
    required this.address,
    required this.created_at,
    required this.updated_at,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      business_id: (json['business_id'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      created_at: (json['created_at'] ?? '').toString(),
      updated_at: (json['updated_at'] ?? '').toString(),
    );
  }

  BranchModel copyWith({
    String? id,
    String? name,
    String? business_id,
    String? address,
    String? created_at,
    String? updated_at,
  }) {
    return BranchModel(
      id: id ?? this.id,
      name: name ?? this.name,
      business_id: business_id ?? this.business_id,
      address: address ?? this.address,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'business_id': business_id,
      'address': address,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
