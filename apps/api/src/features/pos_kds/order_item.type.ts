// Auto-generated DTO file for OrderItem

export interface OrderItemDTO {
  id: string;
  branch_id: string;
  order_id: string;
  menu_item_id: string;
  qty: number;
  unit_price: number;
  total_price: number;
  notes?: string;
  created_at: string | Date;
  updated_at: string | Date;
}
