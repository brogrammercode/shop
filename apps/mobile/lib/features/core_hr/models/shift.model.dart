// Auto-generated Model file for Shift

class ShiftModel {
  final String id;
  final String branch_id;
  final String name;
  final String start_time;
  final String end_time;
  final String status;
  final String created_at;
  final String updated_at;
  final bool is_deleted;

  const ShiftModel({
    required this.id,
    required this.branch_id,
    required this.name,
    required this.start_time,
    required this.end_time,
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.is_deleted,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      name: json['name'] ?? '',
      start_time: json['start_time'] ?? '',
      end_time: json['end_time'] ?? '',
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
      'start_time': start_time,
      'end_time': end_time,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'is_deleted': is_deleted,
    };
  }

  ShiftModel copyWith({
    String? id,
    String? branch_id,
    String? name,
    String? start_time,
    String? end_time,
    String? status,
    String? created_at,
    String? updated_at,
    bool? is_deleted,
  }) {
    return ShiftModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      name: name ?? this.name,
      start_time: start_time ?? this.start_time,
      end_time: end_time ?? this.end_time,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_deleted: is_deleted ?? this.is_deleted,
    );
  }
}
