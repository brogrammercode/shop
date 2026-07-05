// Auto-generated DTO file for MenuItem

export interface MenuItemDTO {
  id: string;
  branch_id: string;
  category_id: string;
  variant_id: string;
  display_name: string;
  description?: string;
  images?: string[];
  selling_price: number;
  videos?: string[];
  status: string;
  created_at: string | Date;
  updated_at: string | Date;
  created_by?: string;
  is_deleted: boolean;
}
