export interface OrderItemDTO {
  id: string;
  branch_id: string;
  order_id: string;
  menu_item_id: string;
  sale_mode_id?: string;
  qty: number;
  unit_price: number;
  total_price: number;
  sale_mode_label?: string;
  quantity_uom_id?: string;
  quantity_uom_code?: string;
  base_quantity?: number;
  base_uom_id?: string;
  base_uom_code?: string;
  notes?: string;
  created_at: string | Date;
  updated_at: string | Date;
}
