export interface MenuItemSaleModeDTO {
  id: string;
  branch_id: string;
  menu_item_id: string;
  uom_id: string;
  label: string;
  price_per_unit: number;
  min_qty: number;
  step_qty: number;
  allow_decimal: boolean;
  is_default: boolean;
  sort_order: number;
  status: string;
  created_at: string | Date;
  updated_at: string | Date;
  is_deleted: boolean;
  uom?: {
    id: string;
    code: string;
    description?: string;
  };
}
