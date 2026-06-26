// Auto-generated DTO file for StockLedger

export interface StockLedgerDTO {
  id: string;
  branch_id: string;
  variant_id: string;
  transaction_type: string;
  quantity_change: number;
  running_balance: number;
  reference_id?: string;
  created_at: string | Date;
  updated_at: string | Date;
  created_by?: string;
}
