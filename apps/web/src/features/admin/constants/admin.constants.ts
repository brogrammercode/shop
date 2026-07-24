import { Boxes, Building2, ListChecks, Users } from "lucide-react";

export const ADMIN_ROUTES = {
  HOME: "/admin",
  USERS: "/admin/users",
  BRANCHES: "/admin/branches",
  ITEMS: "/admin/items",
  MENU_ITEMS: "/admin/menu-items",
} as const;

export const ADMIN_API_ENDPOINTS = {
  USERS: "/hr/users",
  USER: (id: string) => `/hr/users/${id}`,
  BRANCHES: "/hr/branches",
  BRANCH: (id: string) => `/hr/branches/${id}`,
  ITEM_CATEGORIES: "/inventory/item-categories",
  ITEM_CATEGORY: (id: string) => `/inventory/item-categories/${id}`,
  ITEMS: "/inventory/items",
  ITEM: (id: string) => `/inventory/items/${id}`,
  ITEM_VARIANTS: (id: string) => `/inventory/items/${id}/variants`,
  VARIANT: (id: string) => `/inventory/variants/${id}`,
  UOM: "/inventory/uom",
  MENU_CATEGORIES: "/catalog/menu-categories",
  MENU_CATEGORY: (id: string) => `/catalog/menu-categories/${id}`,
  MENU_ITEMS: "/catalog/menu-items",
  MENU_ITEM: (id: string) => `/catalog/menu-items/${id}`,
  MENU_ITEM_SALE_MODES: (id: string) => `/catalog/menu-items/${id}/sale-modes`,
} as const;

export const ADMIN_TEXT = {
  TITLE: "Admin Console",
  SUBTITLE: "Manage the operational data used by mobile, POS, catalog, and customer ordering.",
  USERS_TITLE: "Users",
  USERS_BODY: "Create customers or staff identities, edit profile data, and remove accounts with the backend cascade.",
  BRANCHES_TITLE: "Branches",
  BRANCHES_BODY: "Create and maintain restaurant branches with address, owner, status, and HQ controls.",
  ITEMS_TITLE: "Items and Variants",
  ITEMS_BODY: "Manage inventory master items, item categories, UOMs, and sellable variants.",
  MENU_ITEMS_TITLE: "Menu Items",
  MENU_ITEMS_BODY: "Publish POS/customer menu items from inventory variants with categories, prices, and sale modes.",
  CREATE: "Create",
  UPDATE: "Update",
  DELETE: "Delete",
  EDIT: "Edit",
  CANCEL: "Cancel",
  SAVE: "Save",
  RESET: "Reset",
  REFRESH: "Refresh",
  EMPTY: "No records found",
  LOADING: "Loading data",
  REQUIRED: "Required",
  ACTIVE: "ACTIVE",
  INACTIVE: "INACTIVE",
  SUSPENDED: "SUSPENDED",
  RAW_MATERIAL: "RAW_MATERIAL",
  SEMI_FINISHED: "SEMI_FINISHED",
  FINISHED_GOOD: "FINISHED_GOOD",
  ASSET: "ASSET",
  PACKAGING: "PACKAGING",
  OWNER: "Owner",
  EMPLOYEES: "Employees",
  COUNTS: "Counts",
  SALE_MODE: "Sale mode",
  DEFAULT: "Default",
  AUTO_GENERATED: "Auto-generated when empty",
} as const;

export const ADMIN_NAV_ITEMS = [
  { href: ADMIN_ROUTES.USERS, label: ADMIN_TEXT.USERS_TITLE, icon: Users },
  { href: ADMIN_ROUTES.BRANCHES, label: ADMIN_TEXT.BRANCHES_TITLE, icon: Building2 },
  { href: ADMIN_ROUTES.ITEMS, label: ADMIN_TEXT.ITEMS_TITLE, icon: Boxes },
  { href: ADMIN_ROUTES.MENU_ITEMS, label: ADMIN_TEXT.MENU_ITEMS_TITLE, icon: ListChecks },
] as const;

export const ADMIN_STATUS_OPTIONS = [ADMIN_TEXT.ACTIVE, ADMIN_TEXT.INACTIVE] as const;
export const ADMIN_BRANCH_STATUS_OPTIONS = [ADMIN_TEXT.ACTIVE, ADMIN_TEXT.INACTIVE, ADMIN_TEXT.SUSPENDED] as const;
export const ADMIN_ITEM_TYPE_OPTIONS = [
  ADMIN_TEXT.RAW_MATERIAL,
  ADMIN_TEXT.SEMI_FINISHED,
  ADMIN_TEXT.FINISHED_GOOD,
  ADMIN_TEXT.ASSET,
  ADMIN_TEXT.PACKAGING,
] as const;
