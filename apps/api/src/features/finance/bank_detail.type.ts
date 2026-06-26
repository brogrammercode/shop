// Auto-generated DTO file for BankDetail

export interface BankDetailDTO {
  id: string;
  entity_type: string;
  entity_id: string;
  bank_name: string;
  account_name: string;
  account_number: string;
  ifsc_code?: string;
  swift_code?: string;
  branch_name?: string;
  is_primary: boolean;
  created_at: string | Date;
  updated_at: string | Date;
}
