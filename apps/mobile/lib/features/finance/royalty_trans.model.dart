// Auto-generated Model file for RoyaltyTrans

class RoyaltyTransModel {
  final String id;
  final String branch_id;
  final String franchise_id;
  final double calculated_amt;
  final String status;
  final String created_at;
  final String updated_at;

  const RoyaltyTransModel({
    required this.id,
    required this.branch_id,
    required this.franchise_id,
    required this.calculated_amt,
    required this.status,
    required this.created_at,
    required this.updated_at,
  });

  factory RoyaltyTransModel.fromJson(Map<String, dynamic> json) {
    return RoyaltyTransModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      franchise_id: json['franchise_id'] ?? '',
      calculated_amt: json['calculated_amt'] ?? 0.0,
      status: json['status'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'franchise_id': franchise_id,
      'calculated_amt': calculated_amt,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  RoyaltyTransModel copyWith({
    String? id,
    String? branch_id,
    String? franchise_id,
    double? calculated_amt,
    String? status,
    String? created_at,
    String? updated_at,
  }) {
    return RoyaltyTransModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      franchise_id: franchise_id ?? this.franchise_id,
      calculated_amt: calculated_amt ?? this.calculated_amt,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }
}
