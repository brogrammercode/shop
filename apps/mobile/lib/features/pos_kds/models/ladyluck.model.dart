class LadyluckAccountModel {
  final int points_balance;
  final int lifetime_points;

  const LadyluckAccountModel({
    required this.points_balance,
    required this.lifetime_points,
  });

  factory LadyluckAccountModel.fromJson(Map<String, dynamic> json) {
    return LadyluckAccountModel(
      points_balance: (json['points_balance'] as num?)?.toInt() ?? 0,
      lifetime_points: (json['lifetime_points'] as num?)?.toInt() ?? 0,
    );
  }
}

class LadyluckScratchCardModel {
  final String id;
  final String status;
  final int points_spent;
  final String expires_at;

  const LadyluckScratchCardModel({
    required this.id,
    required this.status,
    required this.points_spent,
    required this.expires_at,
  });

  factory LadyluckScratchCardModel.fromJson(Map<String, dynamic> json) {
    return LadyluckScratchCardModel(
      id: json['id'] ?? '',
      status: json['status'] ?? '',
      points_spent: (json['points_spent'] as num?)?.toInt() ?? 0,
      expires_at: json['expires_at'] ?? '',
    );
  }
}

class LadyluckDiscountModel {
  final String id;
  final String discount_type;
  final double discount_value;
  final double min_order_amount;
  final double max_discount_amount;
  final String status;
  final String valid_until;

  const LadyluckDiscountModel({
    required this.id,
    required this.discount_type,
    required this.discount_value,
    required this.min_order_amount,
    required this.max_discount_amount,
    required this.status,
    required this.valid_until,
  });

  factory LadyluckDiscountModel.fromJson(Map<String, dynamic> json) {
    return LadyluckDiscountModel(
      id: json['id'] ?? '',
      discount_type: json['discount_type'] ?? '',
      discount_value: (json['discount_value'] as num?)?.toDouble() ?? 0.0,
      min_order_amount: (json['min_order_amount'] as num?)?.toDouble() ?? 0.0,
      max_discount_amount: (json['max_discount_amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? '',
      valid_until: json['valid_until'] ?? '',
    );
  }
}

class LadyluckSummaryModel {
  final LadyluckAccountModel account;
  final List<LadyluckScratchCardModel> available_scratch_cards;
  final List<LadyluckDiscountModel> active_discounts;

  const LadyluckSummaryModel({
    required this.account,
    required this.available_scratch_cards,
    required this.active_discounts,
  });

  factory LadyluckSummaryModel.empty() {
    return const LadyluckSummaryModel(
      account: LadyluckAccountModel(points_balance: 0, lifetime_points: 0),
      available_scratch_cards: [],
      active_discounts: [],
    );
  }

  factory LadyluckSummaryModel.fromJson(Map<String, dynamic> json) {
    return LadyluckSummaryModel(
      account: LadyluckAccountModel.fromJson((json['account'] as Map<String, dynamic>?) ?? {}),
      available_scratch_cards: ((json['available_scratch_cards'] as List?) ?? [])
          .map((item) => LadyluckScratchCardModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      active_discounts: ((json['active_discounts'] as List?) ?? [])
          .map((item) => LadyluckDiscountModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
