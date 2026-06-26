// Auto-generated DTO file for StockTransfer

export interface StockTransferDTO {
  id: string;
  from_branch_id: string;
  to_branch_id: string;
  status: string;
  driver_name?: string;
  created_at: string | Date;
  updated_at: string | Date;
  dispatched_by?: string;
  received_by?: string;
}
