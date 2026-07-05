import { OrderItemDTO } from './order_item.type';

export interface OrderDTO {
  id: string;
  branch_id: string;
  table_id?: string;
  uid?: string;
  delivery_address_id?: string;
  employee_id?: string;
  partner_id?: string;
  order_type: string;
  status: string;
  subtotal: number;
  tax_amount: number;
  discount_amount: number;
  price_addition_amount?: number;
  price_reduction_amount?: number;
  total_amount: number;
  final_paying_price?: number;
  fulfillment_date?: string | Date;
  notes?: string;
  created_at: string | Date;
  updated_at: string | Date;
  items?: OrderItemDTO[];
}
