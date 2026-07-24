export interface AdminAddress {
  id?: string;
  area?: string;
  locality?: string;
  city?: string;
  state?: string;
  country?: string;
  pin_code?: string;
}

export interface AdminBankDetail {
  id?: string;
  bank_name?: string;
  account_name?: string;
  account_number?: string;
  ifsc_code?: string;
  swift_code?: string;
  branch_name?: string;
  is_primary?: boolean;
}

export interface AdminUser {
  id: string;
  name: string;
  avatar?: string;
  phone: string;
  email?: string;
  status: string;
  created_at: string;
  updated_at: string;
  is_deleted: boolean;
  employee?: unknown;
  employee_branch_name?: string;
  employee_role_name?: string;
  employee_department_name?: string;
  employee_post_name?: string;
  employee_shift_name?: string;
  addresses?: AdminAddress[];
  bank_details?: AdminBankDetail[];
  order_count?: number;
  session_count?: number;
  complaint_count?: number;
  loyalty_transaction_count?: number;
  device_token_count?: number;
  user_log_count?: number;
}

export interface AdminUserPayload {
  name: string;
  phone: string;
  email?: string | null;
  avatar?: string | null;
  status?: string;
}

export interface AdminBranch {
  id: string;
  name: string;
  code: string;
  is_hq: boolean;
  status: string;
  created_at: string;
  updated_at: string;
  created_by?: string;
  updated_by?: string;
  is_deleted: boolean;
  addresses?: AdminAddress[];
  bank_details?: AdminBankDetail[];
  employee_count?: number;
  owner?: {
    name?: string;
    phone?: string;
  } | null;
}

export interface AdminItemCategory {
  id: string;
  branch_id: string;
  name: string;
  description?: string;
  images?: string[];
  created_at: string;
  updated_at: string;
  is_deleted: boolean;
}

export interface AdminItem {
  id: string;
  branch_id: string;
  category_id: string;
  name: string;
  description?: string;
  images: string[];
  item_type: string;
  shelf_life_days?: number;
  status: string;
  created_at: string;
  updated_at: string;
  is_deleted: boolean;
}

export interface AdminUom {
  id: string;
  branch_id: string;
  code: string;
  description?: string;
  created_at: string;
  updated_at: string;
  is_deleted: boolean;
}

export interface AdminItemVariant {
  id: string;
  branch_id: string;
  item_id: string;
  uom_id: string;
  sku: string;
  barcode?: string;
  name?: string;
  images: string[];
  base_cost: number;
  min_stock_lvl: number;
  status: string;
  created_at: string;
  updated_at: string;
  is_deleted: boolean;
  uom?: AdminUom;
}

export interface AdminMenuCategory {
  id: string;
  branch_id: string;
  name: string;
  description?: string;
  images?: string[];
  display_order: number;
  status: string;
  created_at: string;
  updated_at: string;
  is_deleted: boolean;
}

export interface AdminMenuItemSaleMode {
  id?: string;
  branch_id?: string;
  menu_item_id?: string;
  uom_id: string;
  label: string;
  price_per_unit: number;
  min_qty: number;
  step_qty: number;
  allow_decimal: boolean;
  is_default: boolean;
  sort_order: number;
  status: string;
  created_at?: string;
  updated_at?: string;
  is_deleted?: boolean;
  uom?: AdminUom;
}

export interface AdminMenuItem {
  id: string;
  branch_id: string;
  category_id: string;
  variant_id: string;
  item_id?: string;
  display_name: string;
  description?: string;
  selling_price: number;
  videos: string[];
  images: string[];
  sale_modes: AdminMenuItemSaleMode[];
  status: string;
  created_at: string;
  updated_at: string;
  created_by?: string;
  is_deleted: boolean;
}

export interface ApiEnvelope<T> {
  data: T;
}
