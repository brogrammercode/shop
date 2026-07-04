// Auto-generated Model file for Item

class ItemModel {
  final String id;
  final String branch_id;
  final String category_id;
  final String name;
  final String item_type;
  final int shelf_life_days;
  final String status;
  final String created_at;
  final String updated_at;
  final bool is_deleted;

  const ItemModel({
    required this.id,
    required this.branch_id,
    required this.category_id,
    required this.name,
    required this.item_type,
    required this.shelf_life_days,
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.is_deleted,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      category_id: json['category_id'] ?? '',
      name: json['name'] ?? '',
      item_type: json['item_type'] ?? '',
      shelf_life_days: json['shelf_life_days'] ?? 0,
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
      'category_id': category_id,
      'name': name,
      'item_type': item_type,
      'shelf_life_days': shelf_life_days,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'is_deleted': is_deleted,
    };
  }

  ItemModel copyWith({
    String? id,
    String? branch_id,
    String? category_id,
    String? name,
    String? item_type,
    int? shelf_life_days,
    String? status,
    String? created_at,
    String? updated_at,
    bool? is_deleted,
  }) {
    return ItemModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      category_id: category_id ?? this.category_id,
      name: name ?? this.name,
      item_type: item_type ?? this.item_type,
      shelf_life_days: shelf_life_days ?? this.shelf_life_days,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_deleted: is_deleted ?? this.is_deleted,
    );
  }
}
