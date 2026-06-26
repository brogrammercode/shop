// Auto-generated DTO file for Complaint

export interface ComplaintDTO {
  id: string;
  branch_id: string;
  uid: string;
  order_id: string;
  subject: string;
  description?: string;
  status: string;
  created_at: string | Date;
  updated_at: string | Date;
  resolved_by?: string;
  resolution_notes?: string;
}
