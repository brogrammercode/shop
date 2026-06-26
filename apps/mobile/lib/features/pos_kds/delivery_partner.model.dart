// Auto-generated Model file for DeliveryPartner

import '../core_hr/address.model.dart';
import '../finance/bank_detail.model.dart';

class DeliveryPartnerModel {
  final String id;
  final String branch_id;
  final String name;
  final String avatar;
  final double commission_pct;
  final String status;
  final String created_at;
  final String updated_at;
  final bool is_deleted;
  final List<AddressModel> addresses;
  final List<BankDetailModel> bank_details;

  const DeliveryPartnerModel({
    required this.id,
    required this.branch_id,
    required this.name,
    required this.avatar,
    required this.commission_pct,
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.is_deleted,
    required this.addresses,
    required this.bank_details,
  });

  factory DeliveryPartnerModel.fromJson(Map<String, dynamic> json) {
    return DeliveryPartnerModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      commission_pct: json['commission_pct'] ?? 0.0,
      status: json['status'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      is_deleted: json['is_deleted'] ?? false,
      addresses: (json['addresses'] as List<dynamic>? ?? []).map((x) => AddressModel.fromJson(x as Map<String, dynamic>)).toList(),
      bank_details: (json['bank_details'] as List<dynamic>? ?? []).map((x) => BankDetailModel.fromJson(x as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'name': name,
      'avatar': avatar,
      'commission_pct': commission_pct,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'is_deleted': is_deleted,
      'addresses': addresses.map((x) => x.toJson()).toList(),
      'bank_details': bank_details.map((x) => x.toJson()).toList(),
    };
  }

  DeliveryPartnerModel copyWith({
    String? id,
    String? branch_id,
    String? name,
    String? avatar,
    double? commission_pct,
    String? status,
    String? created_at,
    String? updated_at,
    bool? is_deleted,
    List<AddressModel>? addresses,
    List<BankDetailModel>? bank_details,
  }) {
    return DeliveryPartnerModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      commission_pct: commission_pct ?? this.commission_pct,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_deleted: is_deleted ?? this.is_deleted,
      addresses: addresses ?? this.addresses,
      bank_details: bank_details ?? this.bank_details,
    );
  }
}
