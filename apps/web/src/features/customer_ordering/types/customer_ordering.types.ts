export interface CustomerMenuItem {
  id: string;
  display_name: string;
  selling_price: number;
  image_url?: string;
  images?: string[];
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
  quantity: number;
  unit_price: number;
}

export interface CustomerOrderPayload {
  branch_id: string;
  table_id?: string;
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
  final_paying_price?: number;
}
