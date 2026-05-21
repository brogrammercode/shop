import 'package:mobile/features/business/models/branch_model.dart';
import 'package:mobile/features/business/models/business_model.dart';
import 'package:mobile/features/order/models/bill_model.dart';
import 'package:mobile/features/order/models/order_item_model.dart';

class ReceiptModel {
  final String id;
  final String branch_id;
  final String employee_id;
  final String type;
  final String status;
  final double total_amount;
  final String notes;
  final String created_at;
  final String updated_at;
  final List<OrderItemModel> items;
  final BillModel? bill;
  final BranchModel branch;
  final BusinessModel business;

  const ReceiptModel({
    required this.id,
    required this.branch_id,
    required this.employee_id,
    required this.type,
    required this.status,
    required this.total_amount,
    required this.notes,
    required this.created_at,
    required this.updated_at,
    required this.items,
    required this.bill,
    required this.branch,
    required this.business,
  });

  factory ReceiptModel.fromJson(Map<String, dynamic> json) {
    final branchJson = Map<String, dynamic>.from(json['branch'] ?? {});
    final businessJson = Map<String, dynamic>.from(
      branchJson['business'] ?? {},
    );

    return ReceiptModel(
      id: json['id']?.toString() ?? '',
      branch_id: json['branch_id']?.toString() ?? '',
      employee_id: json['employee_id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      total_amount:
          double.tryParse(json['total_amount']?.toString() ?? '') ?? 0,
      notes: json['notes']?.toString() ?? '',
      created_at: json['created_at']?.toString() ?? '',
      updated_at: json['updated_at']?.toString() ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map<OrderItemModel>(
            (item) => OrderItemModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
      bill: json['bill'] == null
          ? null
          : BillModel.fromJson(Map<String, dynamic>.from(json['bill'])),
      branch: BranchModel.fromJson(branchJson),
      business: BusinessModel.fromJson(businessJson),
    );
  }
}
