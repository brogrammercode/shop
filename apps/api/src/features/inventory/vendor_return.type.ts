// Auto-generated DTO file for VendorReturn

export interface VendorReturnDTO {
  id: string;
  branch_id: string;
  po_id: string;
  return_reason: string;
  refund_value: number;
  status: string;
  created_at: string | Date;
  updated_at: string | Date;
  processed_by?: string;
}
