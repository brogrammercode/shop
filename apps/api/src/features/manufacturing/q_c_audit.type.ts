// Auto-generated DTO file for QCAudit

export interface QCAuditDTO {
  id: string;
  branch_id: string;
  batch_id?: string;
  audit_type: string;
  result_value: string;
  notes?: string;
  created_at: string | Date;
  updated_at: string | Date;
  auditor_name?: string;
}
