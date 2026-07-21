"use client";

import { useEffect, useMemo, useState } from 'react';
import { useRouter } from 'next/navigation';
import { PosCategoryScroll } from '@/components/ui/PosCategoryScroll';
import { PosProductCard } from '@/components/ui/PosProductCard';
import { ChevronRight } from 'lucide-react';
import { CustomerOrderHeader } from '../components/CustomerOrderHeader';
import {
  CUSTOMER_ORDERING_DEFAULTS,
  CUSTOMER_ORDERING_STORAGE_KEYS,
  CUSTOMER_ORDERING_TEXT,
} from '../constants/customer_ordering.constants';
import { CustomerOrderingApi } from '../services/customer_ordering.api';
import { CustomerCartItem, CustomerCartLine, CustomerMenuCategory, CustomerMenuItem, CustomerOrderingContext } from '../types/customer_ordering.types';
import {
  activeSaleModes,
  buildCartItems,
  calculateSubtotal,
  cartKeyFor,
  defaultSaleMode,
  flattenItems,
  formatAmount,
  formatQuantity,
  imageForCategory,
  imageForItem,
  readOrderingContext,
} from '../utils/customer_ordering.utils';

export const CustomerMenuPage = () => {
  const router = useRouter();
  const [orderingContext] = useState<CustomerOrderingContext | null>(() => (
    typeof window === 'undefined' ? null : readOrderingContext()
  ));
  const [categories, setCategories] = useState<CustomerMenuCategory[]>([]);
  const [activeCategoryId, setActiveCategoryId] = useState<string>(CUSTOMER_ORDERING_DEFAULTS.ACTIVE_CATEGORY_ID);
  const [cart, setCart] = useState<Record<string, CustomerCartLine>>(() => {
    if (typeof window === 'undefined') {
      return {};
    }
    const storedCart = sessionStorage.getItem(CUSTOMER_ORDERING_STORAGE_KEYS.CART);
    return storedCart ? normalizeStoredCart(JSON.parse(storedCart)) : {};
  });
  const [saleModeItem, setSaleModeItem] = useState<CustomerMenuItem | null>(null);
  const [isLoading, setIsLoading] = useState(Boolean(orderingContext?.branchId));
  const [error, setError] = useState('');
  const [isMounted, setIsMounted] = useState(false);

  useEffect(() => {
    const timer = window.setTimeout(() => setIsMounted(true), 0);
    return () => window.clearTimeout(timer);
  }, []);

  useEffect(() => {
    if (!orderingContext?.branchId) {
      return;
    }

    const loadData = async () => {
      setIsLoading(true);
      setError('');
      try {
        const [menuData] = await Promise.all([
          CustomerOrderingApi.getMenu(orderingContext.branchId),
        ]);
        setCategories(menuData);
      } catch {
        setError(CUSTOMER_ORDERING_TEXT.MENU_FAILED);
      } finally {
        setIsLoading(false);
      }
    };

    loadData();
  }, [orderingContext]);

  useEffect(() => {
    sessionStorage.setItem(CUSTOMER_ORDERING_STORAGE_KEYS.CART, JSON.stringify(cart));
  }, [cart]);

  const allItems = useMemo(() => flattenItems(categories, CUSTOMER_ORDERING_DEFAULTS.ACTIVE_CATEGORY_ID), [categories]);
  const visibleCategorySections = useMemo(() => {
    if (activeCategoryId === CUSTOMER_ORDERING_DEFAULTS.ACTIVE_CATEGORY_ID) {
      return categories.filter((category) => category.items.length > 0);
    }
    const category = categories.find((item) => item.id === activeCategoryId);
    return category ? [category] : [];
  }, [categories, activeCategoryId]);
  const cartItems = useMemo(() => buildCartItems(allItems, cart), [allItems, cart]);
  const cartItemsByMenuItem = useMemo(() => cartItems.reduce<Record<string, CustomerCartItem[]>>((next, cartItem) => {
    next[cartItem.item.id] = [...(next[cartItem.item.id] || []), cartItem];
    return next;
  }, {}), [cartItems]);
  const subtotal = useMemo(() => calculateSubtotal(cartItems), [cartItems]);
  const payable = subtotal;
  const totalItems = cartItems.reduce((total, item) => total + item.quantity, 0);

  const categoryTabs = useMemo(() => [
    { id: CUSTOMER_ORDERING_DEFAULTS.ACTIVE_CATEGORY_ID, label: CUSTOMER_ORDERING_TEXT.ALL_ITEMS, isAllItems: true },
    ...categories.map((category) => ({
      id: category.id,
      label: category.name,
      imageUrl: imageForCategory(category),
    })),
  ], [categories]);

  const updateCart = (item: CustomerMenuItem, saleMode = defaultSaleMode(item), delta: number) => {
    setCart((current) => {
      const cartKey = cartKeyFor(item, saleMode);
      const currentLine = current[cartKey];
      const currentQuantity = currentLine?.quantity || 0;
      const nextQuantity = Math.max(0, currentQuantity + saleMode.step_qty * delta);
      const next = { ...current };
      if (nextQuantity === 0) {
        delete next[cartKey];
      } else {
        next[cartKey] = {
          menu_item_id: item.id,
          sale_mode_id: saleMode.id,
          quantity: saleMode.allow_decimal ? Number(nextQuantity.toFixed(3)) : Math.round(nextQuantity),
        };
      }
      return next;
    });
  };

  const handleAdd = (item: CustomerMenuItem) => {
    const modes = activeSaleModes(item);
    if (modes.length <= 1) {
      updateCart(item, modes[0], 1);
      return;
    }
    setSaleModeItem(item);
  };

  const primaryCartItemFor = (item: CustomerMenuItem) => {
    const lines = cartItemsByMenuItem[item.id] || [];
    const fallbackSaleMode = defaultSaleMode(item);
    return lines.find((line) => line.saleMode.id === fallbackSaleMode.id) || lines[0] || null;
  };

  const quantityLabelFor = (item: CustomerMenuItem) => {
    const lines = cartItemsByMenuItem[item.id] || [];
    if (lines.length === 0) {
      return "";
    }
    if (lines.length === 1) {
      return formatQuantity(lines[0].quantity);
    }
    return formatQuantity(lines.reduce((total, line) => total + line.quantity, 0));
  };

  if (!isMounted || isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-pure-white">
        <div className="w-8 h-8 border-2 border-primary-green border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  if (!orderingContext?.branchId) {
    return (
      <div className="min-h-screen bg-pure-white flex items-center justify-center px-6 text-center">
        <p className="text-[15px] font-medium text-text-secondary">
          {CUSTOMER_ORDERING_TEXT.CONTEXT_MISSING}
        </p>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-pure-white pb-32">
      <CustomerOrderHeader context={orderingContext} />

      <PosCategoryScroll
        categories={categoryTabs}
        activeId={activeCategoryId}
        onSelect={setActiveCategoryId}
      />

      <div className="w-full h-[8px] bg-soft-grey my-2" />

      <div className="px-4 py-2">
        {error ? (
          <div className="mb-3 rounded-xl bg-[#FFF5F5] border border-[#FFD1D1] px-4 py-3 text-[12px] font-medium text-[#B91C1C]">
            {error}
          </div>
        ) : null}
        {visibleCategorySections.length === 0 ? (
          <div className="py-12 text-center text-[14px] font-medium text-text-secondary">
            {CUSTOMER_ORDERING_TEXT.EMPTY_MENU}
          </div>
        ) : (
          <div className="flex flex-col gap-6">
            {visibleCategorySections.map((category) => (
              <section key={category.id} className="flex flex-col gap-3">
                <h2 className="text-[16px] font-black text-text-primary">
                  {category.name}
                </h2>
                <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
                  {category.items.map((item) => {
                    const cartItem = primaryCartItemFor(item);
                    const saleMode = cartItem?.saleMode || defaultSaleMode(item);
                    return (
                      <PosProductCard
                        key={item.id}
                        title={item.display_name}
                        description={`${saleMode.label} - ${formatAmount(saleMode.price_per_unit)} / ${saleMode.uom_code || CUSTOMER_ORDERING_TEXT.DEFAULT_SALE_MODE}`}
                        priceLabel={formatAmount(saleMode.price_per_unit)}
                        imageUrl={imageForItem(item)}
                        quantityLabel={quantityLabelFor(item)}
                        actionLabel={CUSTOMER_ORDERING_TEXT.ORDER_NOW}
                        favoriteLabel={CUSTOMER_ORDERING_TEXT.FAVORITE_ITEM}
                        onAdd={() => handleAdd(item)}
                        onIncrement={() => {
                          if (cartItem && activeSaleModes(item).length <= 1) {
                            updateCart(item, cartItem.saleMode, 1);
                          } else {
                            handleAdd(item);
                          }
                        }}
                        onDecrement={() => {
                          if (cartItem) updateCart(item, cartItem.saleMode, -1);
                        }}
                      />
                    );
                  })}
                </div>
              </section>
            ))}
          </div>
        )}
      </div>

      <div className="w-full h-[8px] bg-soft-grey my-4" />

      {totalItems > 0 && (
        <div className="fixed bottom-0 left-0 right-0 z-50 p-4 pointer-events-none">
          <button
            type="button"
            onClick={() => router.push('/cart')}
            className="w-full h-14 bg-primary-green rounded-[16px] shadow-elevated flex items-center justify-between px-5 pointer-events-auto active:scale-95 transition-transform"
          >
            <div className="flex items-center gap-2">
              <span className="text-[14px] font-semibold text-pure-white">
                {totalItems} {totalItems === 1 ? 'Item' : 'Items'}
              </span>
              <div className="w-[1px] h-3 bg-pure-white/30" />
              <span className="text-[14px] font-semibold text-pure-white">
                {formatAmount(payable)}
              </span>
            </div>
            <div className="flex items-center gap-1">
              <span className="text-[14px] font-bold text-pure-white">View Cart</span>
              <ChevronRight size={18} strokeWidth={2.5} className="text-pure-white" />
            </div>
          </button>
        </div>
      )}

      {saleModeItem ? (
        <div className="fixed inset-0 z-[60] bg-black/40 flex items-end">
          <div className="w-full bg-pure-white rounded-t-[24px] px-5 pt-4 pb-6">
            <div className="w-10 h-1 bg-border-grey rounded-full mx-auto mb-5" />
            <h2 className="text-[18px] font-bold text-text-primary">
              {CUSTOMER_ORDERING_TEXT.SELECT_SALE_MODE}
            </h2>
            <p className="text-[13px] font-medium text-text-secondary mt-1 mb-4">
              {saleModeItem.display_name}
            </p>
            <div className="flex flex-col gap-3">
              {activeSaleModes(saleModeItem).map((mode) => (
                <button
                  key={mode.id}
                  type="button"
                  onClick={() => {
                    updateCart(saleModeItem, mode, 1);
                    setSaleModeItem(null);
                  }}
                  className="w-full rounded-[14px] border border-border-grey bg-[#FAFAFA] px-4 py-3 flex items-center justify-between text-left"
                >
                  <span>
                    <span className="block text-[14px] font-bold text-text-primary">
                      {mode.label}
                    </span>
                    <span className="block text-[12px] font-medium text-text-secondary mt-1">
                      {formatAmount(mode.price_per_unit)} / {mode.uom_code || CUSTOMER_ORDERING_TEXT.DEFAULT_SALE_MODE}
                    </span>
                  </span>
                  <span className="text-primary-green text-[13px] font-bold">
                    ADD
                  </span>
                </button>
              ))}
            </div>
            <button
              type="button"
              onClick={() => setSaleModeItem(null)}
              className="w-full mt-4 h-11 rounded-[14px] border border-border-grey text-[14px] font-semibold text-text-secondary"
            >
              {CUSTOMER_ORDERING_TEXT.CONTINUE}
            </button>
          </div>
        </div>
      ) : null}
    </div>
  );
};

const normalizeStoredCart = (value: unknown): Record<string, CustomerCartLine> => {
  if (!value || typeof value !== 'object') {
    return {};
  }
  return Object.entries(value as Record<string, unknown>).reduce<Record<string, CustomerCartLine>>((next, [key, entry]) => {
    if (typeof entry === 'number') {
      return next;
    }
    if (entry && typeof entry === 'object') {
      const line = entry as CustomerCartLine;
      if (line.menu_item_id && line.sale_mode_id) {
        next[key] = line;
      }
    }
    return next;
  }, {});
};
