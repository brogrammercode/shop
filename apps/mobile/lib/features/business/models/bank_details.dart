class BankDetailsModel {
  final String account_name;
  final String account_number;
  final String bank_name;
  final String ifsc_code;

  const BankDetailsModel({
    required this.account_name,
    required this.account_number,
    required this.bank_name,
    required this.ifsc_code,
  });

  factory BankDetailsModel.fromJson(Map<String, dynamic> json) {
    return BankDetailsModel(
      account_name: (json['account_name'] ?? '').toString(),
      account_number: (json['account_number'] ?? '').toString(),
      bank_name: (json['bank_name'] ?? '').toString(),
      ifsc_code: (json['ifsc_code'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_name': account_name,
      'account_number': account_number,
      'bank_name': bank_name,
      'ifsc_code': ifsc_code,
    };
  }
}
