// Auto-generated Model file for Coupon

class CouponModel {
  final String id;
  final String branch_id;
  final String code;
  final double discount_pct;
  final double min_order_val;
  final double max_discount;
  final String valid_until;
  final String status;
  final String created_at;
  final String updated_at;
  final bool is_deleted;

  const CouponModel({
    required this.id,
    required this.branch_id,
    required this.code,
    required this.discount_pct,
    required this.min_order_val,
    required this.max_discount,
    required this.valid_until,
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.is_deleted,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      code: json['code'] ?? '',
      discount_pct: json['discount_pct'] ?? 0.0,
      min_order_val: json['min_order_val'] ?? 0.0,
      max_discount: json['max_discount'] ?? 0.0,
      valid_until: json['valid_until'] ?? '',
      status: json['status'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      is_deleted: json['is_deleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'code': code,
      'discount_pct': discount_pct,
      'min_order_val': min_order_val,
      'max_discount': max_discount,
      'valid_until': valid_until,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'is_deleted': is_deleted,
    };
  }

  CouponModel copyWith({
    String? id,
    String? branch_id,
    String? code,
    double? discount_pct,
    double? min_order_val,
    double? max_discount,
    String? valid_until,
    String? status,
    String? created_at,
    String? updated_at,
    bool? is_deleted,
  }) {
    return CouponModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      code: code ?? this.code,
      discount_pct: discount_pct ?? this.discount_pct,
      min_order_val: min_order_val ?? this.min_order_val,
      max_discount: max_discount ?? this.max_discount,
      valid_until: valid_until ?? this.valid_until,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_deleted: is_deleted ?? this.is_deleted,
    );
  }
}
