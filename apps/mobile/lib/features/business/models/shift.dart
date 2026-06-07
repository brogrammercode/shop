class ShiftModel {
  final String id;
  final String branch_id;
  final String name;
  final String start_time;
  final String end_time;
  final String basis;
  final String type;
  final String created_at;
  final String updated_at;

  const ShiftModel({
    required this.id,
    required this.branch_id,
    required this.name,
    required this.start_time,
    required this.end_time,
    required this.basis,
    required this.type,
    required this.created_at,
    required this.updated_at,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      id: (json['id'] ?? '').toString(),
      branch_id: (json['branch_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      start_time: (json['start_time'] ?? '').toString(),
      end_time: (json['end_time'] ?? '').toString(),
      basis: (json['basis'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      created_at: (json['created_at'] ?? '').toString(),
      updated_at: (json['updated_at'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'name': name,
      'start_time': start_time,
      'end_time': end_time,
      'basis': basis,
      'type': type,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
