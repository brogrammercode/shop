// Auto-generated DTO file for LedgerEntry

export interface LedgerEntryDTO {
  id: string;
  branch_id: string;
  account_id: string;
  debit: number;
  credit: number;
  reference_type: string;
  reference_id: string;
  notes?: string;
  created_at: string | Date;
  updated_at: string | Date;
  created_by?: string;
}
