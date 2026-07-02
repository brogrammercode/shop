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
  final List<CreateOrderItemRequest> items;

  const CreateOrderRequest({
    required this.orderType,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
        'order_type': orderType,
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
