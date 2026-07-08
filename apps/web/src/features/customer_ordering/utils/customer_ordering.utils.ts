import {
  CUSTOMER_ORDER_TYPES,
  CUSTOMER_ORDERING_DEFAULTS,
  CUSTOMER_ORDERING_QUERY_KEYS,
  CUSTOMER_ORDERING_STORAGE_KEYS,
  CUSTOMER_ORDERING_TEXT,
} from '../constants/customer_ordering.constants';
import { CustomerCartItem, CustomerMenuCategory, CustomerMenuItem, CustomerOrderingContext, CustomerTable } from '../types/customer_ordering.types';

export const readOrderingContext = (): CustomerOrderingContext => {
  const params = new URLSearchParams(window.location.search);
  const branchId = readContextValue(params, CUSTOMER_ORDERING_QUERY_KEYS.BRANCH_ID, CUSTOMER_ORDERING_STORAGE_KEYS.BRANCH_ID);
  const tableId = readContextValue(params, CUSTOMER_ORDERING_QUERY_KEYS.TABLE_ID, CUSTOMER_ORDERING_STORAGE_KEYS.TABLE_ID);
  const tableSideId = readContextValue(params, CUSTOMER_ORDERING_QUERY_KEYS.TABLE_SIDE_ID, CUSTOMER_ORDERING_STORAGE_KEYS.TABLE_SIDE_ID);
  const orderType = readContextValue(params, CUSTOMER_ORDERING_QUERY_KEYS.ORDER_TYPE, CUSTOMER_ORDERING_STORAGE_KEYS.ORDER_TYPE) || inferOrderType(tableId);

  return {
    branchId,
    tableId: tableId || null,
    tableSideId: tableSideId || null,
    orderType,
  };
};

export const flattenItems = (categories: CustomerMenuCategory[], activeCategoryId: string): CustomerMenuItem[] => {
  if (activeCategoryId === CUSTOMER_ORDERING_DEFAULTS.ACTIVE_CATEGORY_ID) {
    return categories.flatMap((category) => category.items);
  }

  return categories.find((category) => category.id === activeCategoryId)?.items ?? [];
};

export const imageForCategory = (category: CustomerMenuCategory): string => {
  return category.images?.[0] || category.image_url || CUSTOMER_ORDERING_DEFAULTS.EMPTY_IMAGE;
};

export const imageForItem = (item: CustomerMenuItem): string => {
  return item.images?.[0] || item.image_url || CUSTOMER_ORDERING_DEFAULTS.EMPTY_IMAGE;
};

export const buildCartItems = (items: CustomerMenuItem[], cart: Record<string, number>): CustomerCartItem[] => {
  return Object.entries(cart)
    .map(([id, quantity]) => {
      const item = items.find((menuItem) => menuItem.id === id);
      return item ? { item, quantity } : null;
    })
    .filter((value): value is CustomerCartItem => Boolean(value));
};

export const calculateSubtotal = (cartItems: CustomerCartItem[]): number => {
  return cartItems.reduce((total, cartItem) => total + cartItem.item.selling_price * cartItem.quantity, 0);
};



export const formatAmount = (amount: number): string => {
  return `₹ ${Math.round(amount)}`;
};

export const seatOptionsForContext = (context: CustomerOrderingContext, tables: CustomerTable[]): { id: string; label: string }[] => {
  if (!context.tableId && tables.length === 0) {
    return [];
  }

  const sourceTables = tables.length > 0 ? tables : [{ id: context.tableId || '', table_number: context.tableId || '', side_count: CUSTOMER_ORDERING_DEFAULTS.TABLE_SIDE_COUNT, status: '' }];

  return sourceTables.flatMap((table) => {
    const count = table.side_count || CUSTOMER_ORDERING_DEFAULTS.TABLE_SIDE_COUNT;
    return Array.from({ length: count }, (_, index) => {
      const sideNumber = index + 1;
      const customLabel = table.side_labels?.[index];
      return {
        id: `${table.id}-${sideNumber}`,
        label: customLabel || `${table.table_number} ${CUSTOMER_ORDERING_TEXT.SIDE_PREFIX} ${sideNumber}`,
      };
    });
  });
};

const readContextValue = (params: URLSearchParams, queryKey: string, storageKey: string): string => {
  const queryValue = params.get(queryKey)?.trim() || '';
  if (queryValue) {
    sessionStorage.setItem(storageKey, queryValue);
    return queryValue;
  }

  return sessionStorage.getItem(storageKey) || '';
};

const inferOrderType = (tableId: string): string => {
  return tableId ? CUSTOMER_ORDER_TYPES.DINE_IN : CUSTOMER_ORDER_TYPES.DELIVERY;
};
