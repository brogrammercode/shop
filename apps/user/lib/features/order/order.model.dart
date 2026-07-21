import 'package:user/features/home/dummy_data.dart';

class CartItemModel {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String sizeInfo;
  final bool isVeg;
  final int quantity;
  final List<CartSubItem> subItems;

  const CartItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.sizeInfo,
    required this.isVeg,
    required this.quantity,
    this.subItems = const [],
  });

  CartItemModel copyWith({
    String? id,
    String? name,
    double? price,
    String? imageUrl,
    String? sizeInfo,
    bool? isVeg,
    int? quantity,
    List<CartSubItem>? subItems,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      sizeInfo: sizeInfo ?? this.sizeInfo,
      isVeg: isVeg ?? this.isVeg,
      quantity: quantity ?? this.quantity,
      subItems: subItems ?? this.subItems,
    );
  }
}

class CartAddress {
  final String title;
  final String fullAddress;
  final String phoneNumber;
  final bool deliversTo;

  const CartAddress({
    required this.title,
    required this.fullAddress,
    required this.phoneNumber,
    required this.deliversTo,
  });
}

class PaymentMethod {
  final String id;
  final String name;
  final String iconType;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.iconType,
  });
}

class PairingDish {
  final String name;
  final double price;
  final String imageUrl;
  final String sizeInfo;
  final bool isVeg;

  const PairingDish({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.sizeInfo,
    required this.isVeg,
  });
}

class CreateOrderRequest {
  final String orderType;
  final String branchId;
  final String? ladyluckDiscountId;
  final double finalPayingPrice;
  final List<CreateOrderItemRequest> items;

  const CreateOrderRequest({
    required this.orderType,
    required this.branchId,
    required this.finalPayingPrice,
    this.ladyluckDiscountId,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
        'branch_id': branchId,
        'order_type': orderType,
        'final_paying_price': finalPayingPrice,
        if (ladyluckDiscountId != null) 'ladyluck_discount_id': ladyluckDiscountId,
        'items': items.map((e) => e.toJson()).toList(),
      };
}

class CreateOrderItemRequest {
  final String menuItemId;
  final int quantity;
  final String? notes;

  const CreateOrderItemRequest({
    required this.menuItemId,
    required this.quantity,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'menu_item_id': menuItemId,
        'quantity': quantity,
        if (notes != null) 'notes': notes,
      };
}

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

class OrderModel {
  final String id;
  final String code; // New field as requested
  final String status;
  final String date;
  final double totalAmount;
  final String restaurantName;
  final String restaurantImageUrl;
  final List<String> itemSummaries;

  const OrderModel({
    required this.id,
    required this.code,
    required this.status,
    required this.date,
    required this.totalAmount,
    required this.restaurantName,
    required this.restaurantImageUrl,
    required this.itemSummaries,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      status: json['status'] ?? 'pending',
      date: json['date'] ?? '',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      restaurantName: json['restaurant_name'] ?? '',
      restaurantImageUrl: json['restaurant_image_url'] ?? '',
      itemSummaries: List<String>.from(json['item_summaries'] ?? []),
    );
  }
}
