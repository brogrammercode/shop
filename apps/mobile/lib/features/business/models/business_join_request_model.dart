import 'package:mobile/features/business/models/branch_model.dart';
import 'package:mobile/features/business/models/business_model.dart';

class BusinessJoinRequestUserModel {
  final String id;
  final String name;
  final String email;
  final String username;
  final String image;

  const BusinessJoinRequestUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.image,
  });

  factory BusinessJoinRequestUserModel.fromJson(Map<String, dynamic> json) {
    return BusinessJoinRequestUserModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      username: (json['username'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'username': username,
      'image': image,
    };
  }
}

class BusinessJoinRequestModel {
  final String id;
  final String user_id;
  final String business_id;
  final String branch_id;
  final String requested_role_id;
  final String status;
  final String reviewed_by_id;
  final String created_at;
  final String updated_at;
  final BusinessJoinRequestUserModel? user;
  final BusinessModel? business;
  final BranchModel? branch;

  const BusinessJoinRequestModel({
    required this.id,
    required this.user_id,
    required this.business_id,
    required this.branch_id,
    required this.requested_role_id,
    required this.status,
    required this.reviewed_by_id,
    required this.created_at,
    required this.updated_at,
    this.user,
    this.business,
    this.branch,
  });

  factory BusinessJoinRequestModel.fromJson(Map<String, dynamic> json) {
    final businessJson = json['business'];
    final branchJson = json['branch'];
    final userJson = json['user'];

    return BusinessJoinRequestModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      user_id: (json['user_id'] ?? '').toString(),
      business_id: (json['business_id'] ?? '').toString(),
      branch_id: (json['branch_id'] ?? '').toString(),
      requested_role_id: (json['requested_role_id'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      reviewed_by_id: (json['reviewed_by_id'] ?? '').toString(),
      created_at: (json['created_at'] ?? '').toString(),
      updated_at: (json['updated_at'] ?? '').toString(),
      user: userJson is Map
          ? BusinessJoinRequestUserModel.fromJson(
              Map<String, dynamic>.from(userJson),
            )
          : null,
      business: businessJson is Map
          ? BusinessModel.fromJson(Map<String, dynamic>.from(businessJson))
          : null,
      branch: branchJson is Map
          ? BranchModel.fromJson(Map<String, dynamic>.from(branchJson))
          : null,
    );
  }

  BusinessJoinRequestModel copyWith({
    String? id,
    String? user_id,
    String? business_id,
    String? branch_id,
    String? requested_role_id,
    String? status,
    String? reviewed_by_id,
    String? created_at,
    String? updated_at,
    BusinessJoinRequestUserModel? user,
    BusinessModel? business,
    BranchModel? branch,
  }) {
    return BusinessJoinRequestModel(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      business_id: business_id ?? this.business_id,
      branch_id: branch_id ?? this.branch_id,
      requested_role_id: requested_role_id ?? this.requested_role_id,
      status: status ?? this.status,
      reviewed_by_id: reviewed_by_id ?? this.reviewed_by_id,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      user: user ?? this.user,
      business: business ?? this.business,
      branch: branch ?? this.branch,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': user_id,
      'business_id': business_id,
      'branch_id': branch_id,
      'requested_role_id': requested_role_id,
      'status': status,
      'reviewed_by_id': reviewed_by_id,
      'created_at': created_at,
      'updated_at': updated_at,
      'user': user?.toJson(),
      'business': business?.toJson(),
      'branch': branch?.toJson(),
    };
  }
}
