import {
  CUSTOMER_ORDER_TYPES,
  CUSTOMER_ORDERING_DEFAULTS,
  CUSTOMER_ORDERING_LEGACY_QUERY_KEYS,
  CUSTOMER_ORDERING_QUERY_KEYS,
  CUSTOMER_ORDERING_STORAGE_KEYS,
  CUSTOMER_ORDERING_TEXT,
} from "../constants/customer_ordering.constants";
import {
  CustomerCartItem,
  CustomerCartLine,
  CustomerMenuCategory,
  CustomerMenuItem,
  CustomerMenuItemSaleMode,
  CustomerOrderingContext,
  CustomerTable,
} from "../types/customer_ordering.types";
import { formatInr, formatQuantity as formatCoreQuantity } from "@/core/format";

export const readOrderingContext = (): CustomerOrderingContext => {
  const params = new URLSearchParams(window.location.search);
  const branchId = readContextValue(
    params,
    CUSTOMER_ORDERING_QUERY_KEYS.BRANCH_ID,
    CUSTOMER_ORDERING_STORAGE_KEYS.BRANCH_ID,
    CUSTOMER_ORDERING_LEGACY_QUERY_KEYS.BRANCH_ID,
  );
  const tableId = readContextValue(
    params,
    CUSTOMER_ORDERING_QUERY_KEYS.TABLE_ID,
    CUSTOMER_ORDERING_STORAGE_KEYS.TABLE_ID,
    CUSTOMER_ORDERING_LEGACY_QUERY_KEYS.TABLE_ID,
  );
  const tableSideId = readContextValue(
    params,
    CUSTOMER_ORDERING_QUERY_KEYS.TABLE_SIDE_ID,
    CUSTOMER_ORDERING_STORAGE_KEYS.TABLE_SIDE_ID,
    CUSTOMER_ORDERING_LEGACY_QUERY_KEYS.TABLE_SIDE_ID,
  );
  const orderType =
    readContextValue(
      params,
      CUSTOMER_ORDERING_QUERY_KEYS.ORDER_TYPE,
      CUSTOMER_ORDERING_STORAGE_KEYS.ORDER_TYPE,
    ) || inferOrderType(tableId);

  return {
    branchId,
    tableId: tableId || null,
    tableSideId: tableSideId || null,
    orderType,
  };
};

export const flattenItems = (
  categories: CustomerMenuCategory[],
  activeCategoryId: string,
): CustomerMenuItem[] => {
  if (activeCategoryId === CUSTOMER_ORDERING_DEFAULTS.ACTIVE_CATEGORY_ID) {
    return categories.flatMap((category) => category.items);
  }

  return (
    categories.find((category) => category.id === activeCategoryId)?.items ?? []
  );
};

export const imageForCategory = (category: CustomerMenuCategory): string => {
  return (
    category.images?.[0] ||
    category.image_url ||
    CUSTOMER_ORDERING_DEFAULTS.EMPTY_IMAGE
  );
};

export const imageForItem = (item: CustomerMenuItem): string => {
  return (
    item.images?.[0] || item.image_url || CUSTOMER_ORDERING_DEFAULTS.EMPTY_IMAGE
  );
};

export const buildCartItems = (
  items: CustomerMenuItem[],
  cart: Record<string, CustomerCartLine>,
): CustomerCartItem[] => {
  return Object.entries(cart)
    .map(([cartKey, line]) => {
      const item = items.find((menuItem) => menuItem.id === line.menu_item_id);
      if (!item) {
        return null;
      }
      const saleMode =
        activeSaleModes(item).find((mode) => mode.id === line.sale_mode_id) ||
        defaultSaleMode(item);
      return item ? { item, quantity: line.quantity, saleMode, cartKey } : null;
    })
    .filter((value): value is CustomerCartItem => Boolean(value));
};

export const calculateSubtotal = (cartItems: CustomerCartItem[]): number => {
  return cartItems.reduce(
    (total, cartItem) =>
      total + cartItem.saleMode.price_per_unit * cartItem.quantity,
    0,
  );
};

export const activeSaleModes = (
  item: CustomerMenuItem,
): CustomerMenuItemSaleMode[] => {
  const modes = (item.sale_modes || [])
    .filter((mode) => !mode.is_deleted && mode.status === "ACTIVE")
    .sort((a, b) => a.sort_order - b.sort_order);
  return modes.length ? modes : [defaultSaleMode(item)];
};

export const defaultSaleMode = (
  item: CustomerMenuItem,
): CustomerMenuItemSaleMode => {
  return (
    (item.sale_modes || []).find((mode) => mode.is_default) ||
    (item.sale_modes || [])[0] || {
      id: `default-${item.id}`,
      label: CUSTOMER_ORDERING_TEXT.DEFAULT_SALE_MODE,
      uom_id: "",
      uom_code: "",
      price_per_unit: item.selling_price,
      min_qty: 1,
      step_qty: 1,
      allow_decimal: false,
      is_default: true,
      sort_order: 0,
      status: "ACTIVE",
      is_deleted: false,
    }
  );
};

export const cartKeyFor = (
  item: CustomerMenuItem,
  saleMode: CustomerMenuItemSaleMode,
): string => {
  return `${item.id}:${saleMode.id}`;
};

export const formatQuantity = (quantity: number): string => {
  return formatCoreQuantity(quantity);
};

export const formatAmount = (amount: number): string => {
  return formatInr(amount);
};

export const seatOptionsForContext = (
  context: CustomerOrderingContext,
  tables: CustomerTable[],
): { id: string; label: string }[] => {
  if (!context.tableId && tables.length === 0) {
    return [];
  }

  const sourceTables =
    tables.length > 0
      ? tables
      : [
          {
            id: context.tableId || "",
            table_number: context.tableId || "",
            side_count: CUSTOMER_ORDERING_DEFAULTS.TABLE_SIDE_COUNT,
            status: "",
          },
        ];

  return sourceTables.flatMap((table) => {
    const count =
      table.side_count || CUSTOMER_ORDERING_DEFAULTS.TABLE_SIDE_COUNT;
    return Array.from({ length: count }, (_, index) => {
      const sideNumber = index + 1;
      const customLabel = table.side_labels?.[index];
      const label =
        customLabel ||
        `${table.table_number} ${CUSTOMER_ORDERING_TEXT.SIDE_PREFIX} ${sideNumber}`;
      return {
        id: customLabel || `${table.id}-${sideNumber}`,
        label,
      };
    });
  });
};

const readContextValue = (
  params: URLSearchParams,
  queryKey: string,
  storageKey: string,
  legacyQueryKey?: string,
): string => {
  const queryValue =
    params.get(queryKey)?.trim() ||
    (legacyQueryKey ? params.get(legacyQueryKey)?.trim() : "") ||
    "";
  if (queryValue) {
    sessionStorage.setItem(storageKey, queryValue);
    return queryValue;
  }

  return sessionStorage.getItem(storageKey) || "";
};

const inferOrderType = (tableId: string): string => {
  return tableId ? CUSTOMER_ORDER_TYPES.DINE_IN : CUSTOMER_ORDER_TYPES.DELIVERY;
};
