// Auto-generated DTO file for AdvancePayment

export interface AdvancePaymentDTO {
  id: string;
  branch_id: string;
  order_id: string;
  amount_paid: number;
  payment_method: string;
  transaction_ref?: string;
  created_at: string | Date;
  updated_at: string | Date;
  processed_by?: string;
}
