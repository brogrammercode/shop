export interface CustomerMenuItem {
  id: string;
  display_name: string;
  selling_price: number;
  image_url?: string;
  images?: string[];
  sale_modes?: CustomerMenuItemSaleMode[];
}

export interface CustomerMenuItemSaleMode {
  id: string;
  label: string;
  uom_id: string;
  uom_code?: string;
  price_per_unit: number;
  min_qty: number;
  step_qty: number;
  allow_decimal: boolean;
  is_default: boolean;
  sort_order: number;
  status: string;
  is_deleted: boolean;
}

export interface CustomerMenuCategory {
  id: string;
  name: string;
  image_url?: string;
  images?: string[];
  items: CustomerMenuItem[];
}

export interface CustomerCartItem {
  item: CustomerMenuItem;
  quantity: number;
  saleMode: CustomerMenuItemSaleMode;
  cartKey: string;
}

export interface CustomerCartLine {
  menu_item_id: string;
  sale_mode_id: string;
  quantity: number;
}

export interface CustomerTable {
  id: string;
  table_number: string;
  side_count?: number;
  side_labels?: string[];
  status: string;
}

export interface CustomerOrderingContext {
  branchId: string;
  tableId: string | null;
  tableSideId: string | null;
  orderType: string;
}

export interface CustomerAddress {
  id: string;
  address_line_1: string;
  address_line_2?: string;
  city: string;
  state: string;
  postal_code: string;
}

export interface CustomerOrderPayloadItem {
  menu_item_id: string;
  sale_mode_id?: string;
  sale_mode_label?: string;
  quantity_uom_id?: string;
  quantity_uom_code?: string;
  quantity: number;
  unit_price: number;
}

export interface CustomerOrderPayload {
  branch_id: string;
  table_id?: string;
  table_session_id?: string;
  table_side_ids?: string[];
  uid?: string;
  delivery_address_id?: string;
  order_type: string;
  final_paying_price: number;
  items: CustomerOrderPayloadItem[];
}

export interface CustomerOrderResponse {
  id: string;
  order_no: number;
  code?: string;
  table_session_id?: string;
  final_paying_price?: number;
  payment_proofs?: string[];
}
