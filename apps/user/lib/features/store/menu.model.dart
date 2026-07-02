class MenuCategory {
  final String id;
  final String branch_id;
  final String name;
  final String? description;
  final int display_order;
  final String status;
  final DateTime created_at;
  final DateTime updated_at;
  final bool is_deleted;
  final List<MenuItem> items;

  const MenuCategory({
    required this.id,
    required this.branch_id,
    required this.name,
    this.description,
    required this.display_order,
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.is_deleted,
    required this.items,
  });

  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    return MenuCategory(
      id: json['id'] as String,
      branch_id: json['branch_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      display_order: json['display_order'] as int,
      status: json['status'] as String,
      created_at: DateTime.parse(json['created_at'].toString()),
      updated_at: DateTime.parse(json['updated_at'].toString()),
      is_deleted: json['is_deleted'] as bool,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

class MenuItem {
  final String id;
  final String branch_id;
  final String category_id;
  final String variant_id;
  final String display_name;
  final String? description;
  final num selling_price;
  final String? image_url;
  final String status;
  final DateTime created_at;
  final DateTime updated_at;
  final String? created_by;
  final bool is_deleted;

  const MenuItem({
    required this.id,
    required this.branch_id,
    required this.category_id,
    required this.variant_id,
    required this.display_name,
    this.description,
    required this.selling_price,
    this.image_url,
    required this.status,
    required this.created_at,
    required this.updated_at,
    this.created_by,
    required this.is_deleted,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      branch_id: json['branch_id'] as String,
      category_id: json['category_id'] as String,
      variant_id: json['variant_id'] as String,
      display_name: json['display_name'] as String,
      description: json['description'] as String?,
      selling_price: json['selling_price'] as num,
      image_url: json['image_url'] as String?,
      status: json['status'] as String,
      created_at: DateTime.parse(json['created_at'].toString()),
      updated_at: DateTime.parse(json['updated_at'].toString()),
      created_by: json['created_by'] as String?,
      is_deleted: json['is_deleted'] as bool,
    );
  }
}
