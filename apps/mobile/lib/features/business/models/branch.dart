import 'package:mobile/features/business/models/address.dart';

class BranchModel {
  final String id;
  final String name;
  final String branch_code;
  final AddressModel? address;
  final String created_at;
  final String updated_at;

  const BranchModel({
    required this.id,
    required this.name,
    required this.branch_code,
    this.address,
    required this.created_at,
    required this.updated_at,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      branch_code: (json['branch_code'] ?? '').toString(),
      address: json['address'] != null ? AddressModel.fromJson(json['address']) : null,
      created_at: (json['created_at'] ?? '').toString(),
      updated_at: (json['updated_at'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'branch_code': branch_code,
      'address': address?.toJson(),
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
