class ProductVariantModel {
  final String name;
  final double price;

  const ProductVariantModel({required this.name, required this.price});

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      name: json['name']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0,
    );
  }

  ProductVariantModel copyWith({String? name, double? price}) {
    return ProductVariantModel(
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'price': price};
  }
}
