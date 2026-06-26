// Auto-generated DTO file for PurchaseOrder

export interface PurchaseOrderDTO {
  id: string;
  branch_id: string;
  supplier_id: string;
  status: string;
  total_amount: number;
  notes?: string;
  created_at: string | Date;
  updated_at: string | Date;
  created_by?: string;
  approved_by?: string;
}
