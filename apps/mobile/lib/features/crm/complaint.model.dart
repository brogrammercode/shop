// Auto-generated Model file for Complaint

class ComplaintModel {
  final String id;
  final String branch_id;
  final String uid;
  final String order_id;
  final String subject;
  final String description;
  final String status;
  final String created_at;
  final String updated_at;
  final String resolved_by;
  final String resolution_notes;

  const ComplaintModel({
    required this.id,
    required this.branch_id,
    required this.uid,
    required this.order_id,
    required this.subject,
    required this.description,
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.resolved_by,
    required this.resolution_notes,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      uid: json['uid'] ?? '',
      order_id: json['order_id'] ?? '',
      subject: json['subject'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      resolved_by: json['resolved_by'] ?? '',
      resolution_notes: json['resolution_notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'uid': uid,
      'order_id': order_id,
      'subject': subject,
      'description': description,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'resolved_by': resolved_by,
      'resolution_notes': resolution_notes,
    };
  }

  ComplaintModel copyWith({
    String? id,
    String? branch_id,
    String? uid,
    String? order_id,
    String? subject,
    String? description,
    String? status,
    String? created_at,
    String? updated_at,
    String? resolved_by,
    String? resolution_notes,
  }) {
    return ComplaintModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      uid: uid ?? this.uid,
      order_id: order_id ?? this.order_id,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      resolved_by: resolved_by ?? this.resolved_by,
      resolution_notes: resolution_notes ?? this.resolution_notes,
    );
  }
}
