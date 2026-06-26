// Auto-generated DTO file for CashRegister

export interface CashRegisterDTO {
  id: string;
  branch_id: string;
  register_name: string;
  mac_address?: string;
  expected_cash: number;
  actual_cash?: number;
  status: string;
  created_at: string | Date;
  updated_at: string | Date;
  opened_by?: string;
  closed_by?: string;
}
