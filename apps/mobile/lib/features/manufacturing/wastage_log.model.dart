// Auto-generated Model file for WastageLog

class WastageLogModel {
  final String id;
  final String branch_id;
  final String variant_id;
  final String reason;
  final double quantity;
  final String created_at;
  final String updated_at;
  final String logged_by;

  const WastageLogModel({
    required this.id,
    required this.branch_id,
    required this.variant_id,
    required this.reason,
    required this.quantity,
    required this.created_at,
    required this.updated_at,
    required this.logged_by,
  });

  factory WastageLogModel.fromJson(Map<String, dynamic> json) {
    return WastageLogModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      variant_id: json['variant_id'] ?? '',
      reason: json['reason'] ?? '',
      quantity: json['quantity'] ?? 0.0,
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      logged_by: json['logged_by'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'variant_id': variant_id,
      'reason': reason,
      'quantity': quantity,
      'created_at': created_at,
      'updated_at': updated_at,
      'logged_by': logged_by,
    };
  }

  WastageLogModel copyWith({
    String? id,
    String? branch_id,
    String? variant_id,
    String? reason,
    double? quantity,
    String? created_at,
    String? updated_at,
    String? logged_by,
  }) {
    return WastageLogModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      variant_id: variant_id ?? this.variant_id,
      reason: reason ?? this.reason,
      quantity: quantity ?? this.quantity,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      logged_by: logged_by ?? this.logged_by,
    );
  }
}
