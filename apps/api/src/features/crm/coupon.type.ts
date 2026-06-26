// Auto-generated DTO file for Coupon

export interface CouponDTO {
  id: string;
  branch_id: string;
  code: string;
  discount_pct: number;
  min_order_val: number;
  max_discount?: number;
  valid_until?: string | Date;
  status: string;
  created_at: string | Date;
  updated_at: string | Date;
  is_deleted: boolean;
}
