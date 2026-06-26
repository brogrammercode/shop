// Auto-generated Model file for LoyaltyTrans

class LoyaltyTransModel {
  final String id;
  final String branch_id;
  final String uid;
  final String order_id;
  final int points;
  final String trans_type;
  final String created_at;
  final String updated_at;
  final String created_by;

  const LoyaltyTransModel({
    required this.id,
    required this.branch_id,
    required this.uid,
    required this.order_id,
    required this.points,
    required this.trans_type,
    required this.created_at,
    required this.updated_at,
    required this.created_by,
  });

  factory LoyaltyTransModel.fromJson(Map<String, dynamic> json) {
    return LoyaltyTransModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      uid: json['uid'] ?? '',
      order_id: json['order_id'] ?? '',
      points: json['points'] ?? 0,
      trans_type: json['trans_type'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      created_by: json['created_by'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'uid': uid,
      'order_id': order_id,
      'points': points,
      'trans_type': trans_type,
      'created_at': created_at,
      'updated_at': updated_at,
      'created_by': created_by,
    };
  }

  LoyaltyTransModel copyWith({
    String? id,
    String? branch_id,
    String? uid,
    String? order_id,
    int? points,
    String? trans_type,
    String? created_at,
    String? updated_at,
    String? created_by,
  }) {
    return LoyaltyTransModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      uid: uid ?? this.uid,
      order_id: order_id ?? this.order_id,
      points: points ?? this.points,
      trans_type: trans_type ?? this.trans_type,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      created_by: created_by ?? this.created_by,
    );
  }
}
