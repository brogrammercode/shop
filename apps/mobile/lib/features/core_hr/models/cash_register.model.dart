// Auto-generated Model file for CashRegister

class CashRegisterModel {
  final String id;
  final String branch_id;
  final String register_name;
  final String mac_address;
  final double expected_cash;
  final double actual_cash;
  final String status;
  final String created_at;
  final String updated_at;
  final String opened_by;
  final String closed_by;

  const CashRegisterModel({
    required this.id,
    required this.branch_id,
    required this.register_name,
    required this.mac_address,
    required this.expected_cash,
    required this.actual_cash,
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.opened_by,
    required this.closed_by,
  });

  factory CashRegisterModel.fromJson(Map<String, dynamic> json) {
    return CashRegisterModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      register_name: json['register_name'] ?? '',
      mac_address: json['mac_address'] ?? '',
      expected_cash: json['expected_cash'] ?? 0.0,
      actual_cash: json['actual_cash'] ?? 0.0,
      status: json['status'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      opened_by: json['opened_by'] ?? '',
      closed_by: json['closed_by'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'register_name': register_name,
      'mac_address': mac_address,
      'expected_cash': expected_cash,
      'actual_cash': actual_cash,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'opened_by': opened_by,
      'closed_by': closed_by,
    };
  }

  CashRegisterModel copyWith({
    String? id,
    String? branch_id,
    String? register_name,
    String? mac_address,
    double? expected_cash,
    double? actual_cash,
    String? status,
    String? created_at,
    String? updated_at,
    String? opened_by,
    String? closed_by,
  }) {
    return CashRegisterModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      register_name: register_name ?? this.register_name,
      mac_address: mac_address ?? this.mac_address,
      expected_cash: expected_cash ?? this.expected_cash,
      actual_cash: actual_cash ?? this.actual_cash,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      opened_by: opened_by ?? this.opened_by,
      closed_by: closed_by ?? this.closed_by,
    );
  }
}
