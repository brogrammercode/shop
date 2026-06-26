// Auto-generated Model file for TimeLog

class TimeLogModel {
  final String id;
  final String branch_id;
  final String employee_id;
  final String clock_in;
  final String clock_out;
  final double total_hours;
  final String created_at;
  final String updated_at;

  const TimeLogModel({
    required this.id,
    required this.branch_id,
    required this.employee_id,
    required this.clock_in,
    required this.clock_out,
    required this.total_hours,
    required this.created_at,
    required this.updated_at,
  });

  factory TimeLogModel.fromJson(Map<String, dynamic> json) {
    return TimeLogModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      employee_id: json['employee_id'] ?? '',
      clock_in: json['clock_in'] ?? '',
      clock_out: json['clock_out'] ?? '',
      total_hours: json['total_hours'] ?? 0.0,
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'employee_id': employee_id,
      'clock_in': clock_in,
      'clock_out': clock_out,
      'total_hours': total_hours,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  TimeLogModel copyWith({
    String? id,
    String? branch_id,
    String? employee_id,
    String? clock_in,
    String? clock_out,
    double? total_hours,
    String? created_at,
    String? updated_at,
  }) {
    return TimeLogModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      employee_id: employee_id ?? this.employee_id,
      clock_in: clock_in ?? this.clock_in,
      clock_out: clock_out ?? this.clock_out,
      total_hours: total_hours ?? this.total_hours,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }
}
