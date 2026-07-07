"use client";

import { useEffect, useMemo, useState } from 'react';
import { useRouter } from 'next/navigation';
import { PosCategoryScroll } from '@/components/ui/PosCategoryScroll';
import { PosProductCard } from '@/components/ui/PosProductCard';
import { useUserStore } from '@/core/store/user.store';
import { CustomerBottomBar } from '../components/CustomerBottomBar';
import { CustomerCartPanel } from '../components/CustomerCartPanel';
import { CustomerContextPanel } from '../components/CustomerContextPanel';
import { CustomerOffersPanel } from '../components/CustomerOffersPanel';
import { CustomerOrderHeader } from '../components/CustomerOrderHeader';
import {
  CUSTOMER_ORDER_TYPES,
  CUSTOMER_ORDERING_DEFAULTS,
  CUSTOMER_ORDERING_ROUTES,
  CUSTOMER_ORDERING_STORAGE_KEYS,
  CUSTOMER_ORDERING_TEXT,
} from '../constants/customer_ordering.constants';
import { CustomerOrderingApi } from '../services/customer_ordering.api';
import { CustomerMenuCategory, CustomerOrderingContext, CustomerTable } from '../types/customer_ordering.types';
import {
  buildCartItems,
  calculateSubtotal,
  calculateTax,
  flattenItems,
  imageForCategory,
  imageForItem,
  readOrderingContext,
} from '../utils/customer_ordering.utils';

export const CustomerMenuPage = () => {
  const router = useRouter();
  const { token, user, addresses } = useUserStore();
  const [orderingContext] = useState<CustomerOrderingContext | null>(() => (
    typeof window === 'undefined' ? null : readOrderingContext()
  ));
  const [categories, setCategories] = useState<CustomerMenuCategory[]>([]);
  const [tables, setTables] = useState<CustomerTable[]>([]);
  const [activeCategoryId, setActiveCategoryId] = useState<string>(CUSTOMER_ORDERING_DEFAULTS.ACTIVE_CATEGORY_ID);
  const [cart, setCart] = useState<Record<string, number>>(() => {
    if (typeof window === 'undefined') {
      return {};
    }
    const storedCart = sessionStorage.getItem(CUSTOMER_ORDERING_STORAGE_KEYS.CART);
    return storedCart ? JSON.parse(storedCart) as Record<string, number> : {};
  });
  const [selectedSeatIds, setSelectedSeatIds] = useState<string[]>(() => (
    orderingContext?.tableSideId ? [orderingContext.tableSideId] : []
  ));
  const [selectedAddressId, setSelectedAddressId] = useState('');
  const [isLoading, setIsLoading] = useState(Boolean(orderingContext?.branchId));
  const [isCartOpen, setIsCartOpen] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState('');
  const [notice, setNotice] = useState('');

  useEffect(() => {
    if (!orderingContext?.branchId) {
      return;
    }

    const loadData = async () => {
      setIsLoading(true);
      setError('');
      try {
        const [menuData, tableData] = await Promise.all([
          CustomerOrderingApi.getMenu(orderingContext.branchId),
          CustomerOrderingApi.getTables(orderingContext.branchId),
        ]);
        setCategories(menuData);
        setTables(tableData);
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
  const payable = subtotal + calculateTax(subtotal);
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

  const toggleSeat = (seatId: string) => {
    setSelectedSeatIds((current) => (
      current.includes(seatId)
        ? current.filter((selectedSeatId) => selectedSeatId !== seatId)
        : [...current, seatId]
    ));
  };

  const submitOrder = async () => {
    if (!orderingContext || cartItems.length === 0) {
      return;
    }

    if (!token) {
      router.push(`${CUSTOMER_ORDERING_ROUTES.LOGIN}?next=${encodeURIComponent(window.location.pathname + window.location.search)}`);
      return;
    }

    if (orderingContext.orderType === CUSTOMER_ORDER_TYPES.DINE_IN && selectedSeatIds.length === 0) {
      setError(CUSTOMER_ORDERING_TEXT.SEATS_REQUIRED);
      return;
    }

    if (orderingContext.orderType === CUSTOMER_ORDER_TYPES.DELIVERY && !selectedAddressId) {
      setError(CUSTOMER_ORDERING_TEXT.ADDRESS_REQUIRED);
      return;
    }

    setIsSubmitting(true);
    setError('');
    try {
      await CustomerOrderingApi.createOrder({
        branch_id: orderingContext.branchId,
        table_id: orderingContext.tableId || undefined,
        table_side_ids: selectedSeatIds,
        uid: user?.id,
        delivery_address_id: selectedAddressId || undefined,
        order_type: orderingContext.orderType,
        final_paying_price: payable,
        items: cartItems.map((cartItem) => ({
          menu_item_id: cartItem.item.id,
          quantity: cartItem.quantity,
          unit_price: cartItem.item.selling_price,
        })),
      });
      setCart({});
      setIsCartOpen(false);
      setNotice(CUSTOMER_ORDERING_TEXT.ORDER_PLACED);
      sessionStorage.removeItem(CUSTOMER_ORDERING_STORAGE_KEYS.CART);
    } catch {
      setError(CUSTOMER_ORDERING_TEXT.ORDER_FAILED);
    } finally {
      setIsSubmitting(false);
    }
  };

  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-pure-white">
        <div className="w-8 h-8 border-2 border-primary-green border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  if (!orderingContext?.branchId) {
    return (
      <div className="min-h-screen bg-pure-white flex items-center justify-center px-6 text-center">
        <p className="text-[15px] font-bold text-text-secondary">
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
          <div className="mb-3 rounded-xl bg-[#FFF5F5] border border-[#FFD1D1] px-4 py-3 text-[12px] font-bold text-[#B91C1C]">
            {error}
          </div>
        ) : null}
        {notice ? (
          <div className="mb-3 rounded-xl bg-[#E8F5E9] border border-primary-green/20 px-4 py-3 text-[12px] font-bold text-primary-green">
            {notice}
          </div>
        ) : null}
        {visibleItems.length === 0 ? (
          <div className="py-12 text-center text-[14px] font-bold text-text-secondary">
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

      <CustomerContextPanel
        context={orderingContext}
        selectedSeatIds={selectedSeatIds}
        selectedAddressId={selectedAddressId}
        addresses={addresses}
        tables={tables}
        onToggleSeat={toggleSeat}
        onSelectAddress={setSelectedAddressId}
      />

      <div className="w-full h-[8px] bg-soft-grey my-4" />

      <CustomerOffersPanel isLoggedIn={Boolean(token)} />

      <CustomerBottomBar
        totalItems={totalItems}
        payable={payable}
        onOpenCart={() => setIsCartOpen(true)}
      />

      <CustomerCartPanel
        isOpen={isCartOpen}
        items={cartItems}
        isSubmitting={isSubmitting}
        actionLabel={token ? CUSTOMER_ORDERING_TEXT.PLACE_ORDER : CUSTOMER_ORDERING_TEXT.LOGIN_TO_ORDER}
        error={error}
        onClose={() => setIsCartOpen(false)}
        onSubmit={submitOrder}
        onIncrement={(itemId) => updateCart(itemId, 1)}
        onDecrement={(itemId) => updateCart(itemId, -1)}
      />
    </div>
  );
};
