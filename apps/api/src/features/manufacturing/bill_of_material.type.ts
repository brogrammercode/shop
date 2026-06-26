// Auto-generated DTO file for BillOfMaterial

export interface BillOfMaterialDTO {
  id: string;
  branch_id: string;
  output_variant_id: string;
  yield_quantity: number;
  instructions?: string;
  status: string;
  created_at: string | Date;
  updated_at: string | Date;
  created_by?: string;
  is_deleted: boolean;
}
