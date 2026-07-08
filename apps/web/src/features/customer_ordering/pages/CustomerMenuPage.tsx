"use client";

import { useEffect, useMemo, useState } from 'react';
import { useRouter } from 'next/navigation';
import { PosCategoryScroll } from '@/components/ui/PosCategoryScroll';
import { PosProductCard } from '@/components/ui/PosProductCard';
import { useUserStore } from '@/core/store/user.store';
import { ChevronRight } from 'lucide-react';
import { CustomerOrderHeader } from '../components/CustomerOrderHeader';
import {
  CUSTOMER_ORDER_TYPES,
  CUSTOMER_ORDERING_DEFAULTS,
  CUSTOMER_ORDERING_ROUTES,
  CUSTOMER_ORDERING_STORAGE_KEYS,
  CUSTOMER_ORDERING_TEXT,
} from '../constants/customer_ordering.constants';
import { CustomerOrderingApi } from '../services/customer_ordering.api';
import { CustomerMenuCategory, CustomerOrderingContext } from '../types/customer_ordering.types';
import {
  buildCartItems,
  calculateSubtotal,
  flattenItems,
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
  const [cart, setCart] = useState<Record<string, number>>(() => {
    if (typeof window === 'undefined') {
      return {};
    }
    const storedCart = sessionStorage.getItem(CUSTOMER_ORDERING_STORAGE_KEYS.CART);
    return storedCart ? JSON.parse(storedCart) as Record<string, number> : {};
  });
  const [isLoading, setIsLoading] = useState(Boolean(orderingContext?.branchId));
  const [error, setError] = useState('');
  const [isMounted, setIsMounted] = useState(false);

  useEffect(() => {
    setIsMounted(true);
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
  const visibleItems = useMemo(() => flattenItems(categories, activeCategoryId), [categories, activeCategoryId]);
  const cartItems = useMemo(() => buildCartItems(allItems, cart), [allItems, cart]);
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

  const updateCart = (itemId: string, delta: number) => {
    setCart((current) => {
      const nextQuantity = Math.max(0, (current[itemId] || 0) + delta);
      const next = { ...current };
      if (nextQuantity === 0) {
        delete next[itemId];
      } else {
        next[itemId] = nextQuantity;
      }
      return next;
    });
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
        {visibleItems.length === 0 ? (
          <div className="py-12 text-center text-[14px] font-medium text-text-secondary">
            {CUSTOMER_ORDERING_TEXT.EMPTY_MENU}
          </div>
        ) : (
          <div className="grid grid-cols-2 gap-4">
            {visibleItems.map((item) => (
              <PosProductCard
                key={item.id}
                title={item.display_name}
                price={item.selling_price}
                imageUrl={imageForItem(item)}
                quantity={cart[item.id] || 0}
                onAdd={() => updateCart(item.id, 1)}
                onIncrement={() => updateCart(item.id, 1)}
                onDecrement={() => updateCart(item.id, -1)}
              />
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
                ₹ {payable.toFixed(2)}
              </span>
            </div>
            <div className="flex items-center gap-1">
              <span className="text-[14px] font-bold text-pure-white">View Cart</span>
              <ChevronRight size={18} strokeWidth={2.5} className="text-pure-white" />
            </div>
          </button>
        </div>
      )}
    </div>
  );
};
