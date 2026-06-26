// Auto-generated DTO file for Order

export interface OrderDTO {
  id: string;
  branch_id: string;
  table_id?: string;
  uid?: string;
  employee_id?: string;
  partner_id?: string;
  order_type: string;
  status: string;
  subtotal: number;
  tax_amount: number;
  discount_amount: number;
  total_amount: number;
  fulfillment_date?: string | Date;
  notes?: string;
  created_at: string | Date;
  updated_at: string | Date;
}
