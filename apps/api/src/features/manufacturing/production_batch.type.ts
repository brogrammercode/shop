// Auto-generated DTO file for ProductionBatch

export interface ProductionBatchDTO {
  id: string;
  branch_id: string;
  bom_id: string;
  status: string;
  planned_qty: number;
  produced_qty: number;
  expiry_date?: string | Date;
  notes?: string;
  created_at: string | Date;
  updated_at: string | Date;
  started_by?: string;
  completed_by?: string;
}
