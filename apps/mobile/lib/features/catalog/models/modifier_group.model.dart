// Auto-generated Model file for ModifierGroup

class ModifierGroupModel {
  final String id;
  final String branch_id;
  final String name;
  final int min_select;
  final int max_select;
  final String status;
  final String created_at;
  final String updated_at;
  final bool is_deleted;

  const ModifierGroupModel({
    required this.id,
    required this.branch_id,
    required this.name,
    required this.min_select,
    required this.max_select,
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.is_deleted,
  });

  factory ModifierGroupModel.fromJson(Map<String, dynamic> json) {
    return ModifierGroupModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      name: json['name'] ?? '',
      min_select: json['min_select'] ?? 0,
      max_select: json['max_select'] ?? 0,
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
      'name': name,
      'min_select': min_select,
      'max_select': max_select,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'is_deleted': is_deleted,
    };
  }

  ModifierGroupModel copyWith({
    String? id,
    String? branch_id,
    String? name,
    int? min_select,
    int? max_select,
    String? status,
    String? created_at,
    String? updated_at,
    bool? is_deleted,
  }) {
    return ModifierGroupModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      name: name ?? this.name,
      min_select: min_select ?? this.min_select,
      max_select: max_select ?? this.max_select,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_deleted: is_deleted ?? this.is_deleted,
    );
  }
}
