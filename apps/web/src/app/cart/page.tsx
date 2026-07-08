"use client";

import { useEffect, useMemo, useState } from 'react';
import { useRouter } from 'next/navigation';
import { ChevronLeft } from 'lucide-react';
import { useUserStore } from '@/core/store/user.store';
import { CustomerContextPanel } from '@/features/customer_ordering/components/CustomerContextPanel';
import { GreenStepper } from '@/components/ui/GreenStepper';
import {
  CUSTOMER_ORDER_TYPES,
  CUSTOMER_ORDERING_DEFAULTS,
  CUSTOMER_ORDERING_ROUTES,
  CUSTOMER_ORDERING_STORAGE_KEYS,
  CUSTOMER_ORDERING_TEXT,
} from '@/features/customer_ordering/constants/customer_ordering.constants';
import { CustomerOrderingApi } from '@/features/customer_ordering/services/customer_ordering.api';
import { CustomerMenuCategory, CustomerOrderingContext, CustomerTable } from '@/features/customer_ordering/types/customer_ordering.types';
import {
  buildCartItems,
  calculateSubtotal,
  flattenItems,
  formatAmount,
  readOrderingContext,
} from '@/features/customer_ordering/utils/customer_ordering.utils';

export default function CartPage() {
  const router = useRouter();
  const { token, user, addresses } = useUserStore();
  
  const [isMounted, setIsMounted] = useState(false);
  const [orderingContext] = useState<CustomerOrderingContext | null>(() => (
    typeof window === 'undefined' ? null : readOrderingContext()
  ));
  const [categories, setCategories] = useState<CustomerMenuCategory[]>([]);
  const [tables, setTables] = useState<CustomerTable[]>([]);
  const [cart, setCart] = useState<Record<string, number>>(() => {
    if (typeof window === 'undefined') return {};
    const storedCart = sessionStorage.getItem(CUSTOMER_ORDERING_STORAGE_KEYS.CART);
    return storedCart ? JSON.parse(storedCart) as Record<string, number> : {};
  });
  const [selectedSeatIds, setSelectedSeatIds] = useState<string[]>(() => (
    orderingContext?.tableSideId ? [orderingContext.tableSideId] : []
  ));
  const [selectedAddressId, setSelectedAddressId] = useState('');
  
  const [isLoading, setIsLoading] = useState(Boolean(orderingContext?.branchId));
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    setIsMounted(true);
  }, []);

  useEffect(() => {
    if (!orderingContext?.branchId) return;

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
  const cartItems = useMemo(() => buildCartItems(allItems, cart), [allItems, cart]);
  const subtotal = useMemo(() => calculateSubtotal(cartItems), [cartItems]);
  const payable = subtotal;

  const updateCart = (itemId: string, delta: number) => {
    setCart((current) => {
      const nextQuantity = Math.max(0, (current[itemId] || 0) + delta);
      const next = { ...current };
      if (nextQuantity === 0) delete next[itemId];
      else next[itemId] = nextQuantity;
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
    if (!orderingContext || cartItems.length === 0) return;

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
      sessionStorage.removeItem(CUSTOMER_ORDERING_STORAGE_KEYS.CART);
      // Route back to menu (or a success page ideally)
      router.push('/menu');
    } catch {
      setError(CUSTOMER_ORDERING_TEXT.ORDER_FAILED);
    } finally {
      setIsSubmitting(false);
    }
  };

  if (!isMounted || isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-[#FAFAFA]">
        <div className="w-8 h-8 border-2 border-primary-green border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  if (cartItems.length === 0) {
    return (
      <div className="min-h-screen bg-[#FAFAFA] flex flex-col">
        <div className="bg-[#FAFAFA] px-4 py-3 flex items-center">
          <button type="button" onClick={() => router.back()} className="p-2 -ml-2">
            <ChevronLeft size={24} className="text-text-primary" />
          </button>
        </div>
        <div className="flex-1 flex flex-col items-center justify-center px-6 text-center">
          <p className="text-[15px] font-medium text-text-secondary">
            {CUSTOMER_ORDERING_TEXT.CART_EMPTY}
          </p>
          <button 
            onClick={() => router.push('/menu')}
            className="mt-4 px-6 py-2 border border-primary-green text-primary-green rounded-full text-sm font-semibold"
          >
            Go to Menu
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-[#FAFAFA] pb-32">
      <div className="bg-[#FAFAFA] px-4 py-3 flex items-center">
        <button type="button" onClick={() => router.back()} className="p-2 -ml-2">
          <ChevronLeft size={24} className="text-text-primary" />
        </button>
      </div>

      <div className="px-4 mb-6">
        <h2 className="text-[18px] font-semibold text-text-primary mb-4">
          {CUSTOMER_ORDERING_TEXT.BILLING}
        </h2>
        
        <div className="flex flex-col gap-3 bg-pure-white p-4 rounded-[14px] border border-border-grey shadow-sm">
          {cartItems.map((cartItem) => (
            <div key={cartItem.item.id} className="border-b border-border-grey pb-3 last:border-0 last:pb-0">
              <div className="flex items-start justify-between gap-3">
                <div className="min-w-0">
                  <p className="text-[14px] font-medium text-text-primary leading-tight">
                    {cartItem.item.display_name}
                  </p>
                  <p className="text-[12px] font-normal text-text-secondary mt-1">
                    {formatAmount(cartItem.item.selling_price)}
                  </p>
                </div>
                <p className="text-[13px] font-semibold text-text-primary">
                  {formatAmount(cartItem.item.selling_price * cartItem.quantity)}
                </p>
              </div>
              <div className="mt-3 flex">
                <GreenStepper 
                  count={cartItem.quantity}
                  onIncrement={() => updateCart(cartItem.item.id, 1)}
                  onDecrement={() => updateCart(cartItem.item.id, -1)}
                />
              </div>
            </div>
          ))}

          <div className="mt-2 pt-4 border-t border-border-grey flex flex-col gap-2">
            <BillRow label={CUSTOMER_ORDERING_TEXT.SUBTOTAL} value={formatAmount(subtotal)} />
            <div className="h-px bg-border-grey my-1" />
            <BillRow label={CUSTOMER_ORDERING_TEXT.PAYABLE} value={formatAmount(payable)} strong />
          </div>
        </div>
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

      <div className="fixed bottom-0 left-0 right-0 z-50 p-6 pointer-events-none">
        <div className="w-full relative shadow-upward bg-transparent pointer-events-auto">
          {error ? (
            <div className="absolute bottom-full left-0 right-0 mb-3 rounded-xl bg-[#FFF5F5] border border-[#FFD1D1] px-4 py-3 text-[12px] font-medium text-[#B91C1C] shadow-sm">
              {error}
            </div>
          ) : null}
          <button
            type="button"
            onClick={submitOrder}
            disabled={isSubmitting}
            className="w-full h-12 rounded-[16px] bg-primary-green text-pure-white text-[15px] font-semibold disabled:opacity-60 flex items-center justify-center shadow-elevated"
          >
            {isSubmitting ? (
              <span className="w-5 h-5 rounded-full border-2 border-pure-white border-t-transparent animate-spin" />
            ) : (
              token ? CUSTOMER_ORDERING_TEXT.PLACE_ORDER : CUSTOMER_ORDERING_TEXT.LOGIN_TO_ORDER
            )}
          </button>
        </div>
      </div>
    </div>
  );
}

const BillRow = ({ label, value, strong = false }: { label: string; value: string; strong?: boolean }) => (
  <div className="flex items-center justify-between">
    <span className={`text-[13px] ${strong ? 'font-semibold text-text-primary' : 'font-medium text-text-secondary'}`}>
      {label}
    </span>
    <span className={`text-[13px] ${strong ? 'font-semibold text-text-primary' : 'font-medium text-text-primary'}`}>
      {value}
    </span>
  </div>
);
