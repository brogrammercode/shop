export const CUSTOMER_ORDERING_ROUTES = {
  MENU: "/menu",
  LOGIN: "/login",
} as const;

export const CUSTOMER_ORDERING_CARD_QR = {
  QUERY_KEY: "qr",
  QUERY_VALUE: "card",
  BRANCH_ID: "1783064192233",
  ORDER_TYPE: "DELIVERY",
} as const;

export const CUSTOMER_ORDERING_STORAGE_KEYS = {
  BRANCH_ID: "qr_branch_id",
  TABLE_ID: "qr_table_id",
  TABLE_SIDE_ID: "qr_table_side_id",
  ORDER_TYPE: "qr_order_type",
  CART: "customer_ordering_cart",
} as const;

export const CUSTOMER_ORDERING_QUERY_KEYS = {
  BRANCH_ID: "branch_id",
  TABLE_ID: "table_id",
  TABLE_SIDE_ID: "table_side_id",
  ORDER_TYPE: "order_type",
} as const;

export const CUSTOMER_ORDERING_LEGACY_QUERY_KEYS = {
  BRANCH_ID: "b",
  TABLE_ID: "t",
  TABLE_SIDE_ID: "s",
} as const;

export const CUSTOMER_ORDERING_ENDPOINTS = {
  MENU: "/catalog/menu",
  PUBLIC_TABLES: "/pos-kds/public/tables",
  ORDERS: "/pos-kds/orders",
} as const;

export const CUSTOMER_ORDERING_TEXT = {
  APP_TITLE: "POS Terminal",
  ALL_ITEMS: "All Items",
  EMPTY_MENU: "No menu items found",
  CART_EMPTY: "Cart is empty",
  VIEW_CART: "View cart",
  PLACE_ORDER: "Place order",
  LOGIN_TO_ORDER: "Login to place order",
  ORDER_PLACED: "Order placed successfully",
  ORDER_FAILED: "Unable to place order",
  MENU_FAILED: "Unable to load menu",
  TABLE_CONTEXT: "Table order",
  DELIVERY_CONTEXT: "Delivery order",
  TAKEAWAY_CONTEXT: "Takeaway order",
  SELECT_SEATS: "Select seats",
  SELECT_ADDRESS: "Select address",
  ADDRESS_REQUIRED: "Select an address before placing delivery order",
  SEATS_REQUIRED: "Select at least one table side",
  OFFERS_TITLE: "Coupons and offers",
  OFFER_ONE_TITLE: "Welcome savings",
  OFFER_ONE_BODY:
    "Login to view eligible coupons and account offers before payment.",
  OFFER_TWO_TITLE: "Restaurant offers",
  OFFER_TWO_BODY:
    "Available offers are refreshed from your account at checkout.",
  PREVIOUS_ORDERS: "Previous orders",
  PREVIOUS_ORDERS_BODY:
    "Login to show your previous orders from this restaurant.",
  ITEM_COUNT: "items",
  SUBTOTAL: "Subtotal",
  TAX: "Tax",
  PAYABLE: "Payable",
  CONTINUE: "Continue",
  BILLING: "Billing",
  ORDERS: "Orders",
  MORE: "More",
  DELIVERY_FALLBACK: "Delivery",
  TABLE_FALLBACK: "Table",
  SIDE_PREFIX: "Side",
  CHANGE: "Change",
  CONTEXT_MISSING: "Scan a valid QR code to load this restaurant menu.",
  SELECT_SALE_MODE: "Select sale mode",
  DEFAULT_SALE_MODE: "Regular",
} as const;

export const CUSTOMER_ORDER_TYPES = {
  DINE_IN: "DINE_IN",
  DELIVERY: "DELIVERY",
  TAKEAWAY: "TAKEAWAY",
} as const;

export const CUSTOMER_ORDERING_DEFAULTS = {
  ACTIVE_CATEGORY_ID: "all",
  TAX_RATE: 0.1,
  TABLE_SIDE_COUNT: 4,
  EMPTY_IMAGE: "",
} as const;
