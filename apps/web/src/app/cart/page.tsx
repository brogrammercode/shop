"use client";

import { useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import { BadgePercent, ChevronLeft, Gift } from "lucide-react";
import { useUserStore } from "@/core/store/user.store";
import { AuthRepo } from "@/features/auth/repo/auth.repo";
import { CustomerContextPanel } from "@/features/customer_ordering/components/CustomerContextPanel";
import { GreenStepper } from "@/components/ui/GreenStepper";
import {
  CUSTOMER_ORDER_TYPES,
  CUSTOMER_ORDERING_DEFAULTS,
  CUSTOMER_ORDERING_ROUTES,
  CUSTOMER_ORDERING_STORAGE_KEYS,
  CUSTOMER_ORDERING_TEXT,
} from "@/features/customer_ordering/constants/customer_ordering.constants";
import { CustomerOrderingApi } from "@/features/customer_ordering/services/customer_ordering.api";
import {
  CustomerCartLine,
  CustomerMenuCategory,
  CustomerOrderingContext,
  CustomerTable,
  LadyluckDiscount,
  LadyluckSummary,
} from "@/features/customer_ordering/types/customer_ordering.types";
import {
  buildCartItems,
  calculateSubtotal,
  flattenItems,
  formatQuantity,
  formatAmount,
  readOrderingContext,
} from "@/features/customer_ordering/utils/customer_ordering.utils";

export default function CartPage() {
  const router = useRouter();
  const { token, user, addresses, hasHydrated, requiresPhone } = useUserStore();

  const [isMounted, setIsMounted] = useState(false);
  const [orderingContext] = useState<CustomerOrderingContext | null>(() =>
    typeof window === "undefined" ? null : readOrderingContext(),
  );
  const [categories, setCategories] = useState<CustomerMenuCategory[]>([]);
  const [tables, setTables] = useState<CustomerTable[]>([]);
  const [cart, setCart] = useState<Record<string, CustomerCartLine>>(() => {
    if (typeof window === "undefined") return {};
    const storedCart = sessionStorage.getItem(
      CUSTOMER_ORDERING_STORAGE_KEYS.CART,
    );
    return storedCart ? normalizeStoredCart(JSON.parse(storedCart)) : {};
  });
  const [selectedSeatIds, setSelectedSeatIds] = useState<string[]>(() =>
    orderingContext?.tableSideId ? [orderingContext.tableSideId] : [],
  );
  const [selectedAddressId, setSelectedAddressId] = useState("");
  const [ladyluckSummary, setLadyluckSummary] = useState<LadyluckSummary | null>(null);
  const [selectedLadyluckDiscountId, setSelectedLadyluckDiscountId] = useState(() => {
    if (typeof window === "undefined") return "";
    return sessionStorage.getItem(CUSTOMER_ORDERING_STORAGE_KEYS.LADYLUCK_DISCOUNT_ID) || "";
  });

  const [isLoading, setIsLoading] = useState(
    Boolean(orderingContext?.branchId),
  );
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isLadyluckLoading, setIsLadyluckLoading] = useState(false);
  const [isScratching, setIsScratching] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    const timer = window.setTimeout(() => setIsMounted(true), 0);
    return () => window.clearTimeout(timer);
  }, []);

  useEffect(() => {
    if (!hasHydrated || !token) {
      return;
    }
    AuthRepo.loadCurrentUser().catch(() => undefined);
  }, [hasHydrated, token]);

  useEffect(() => {
    if (!orderingContext?.branchId) return;

    const loadData = async () => {
      setIsLoading(true);
      setError("");
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
    sessionStorage.setItem(
      CUSTOMER_ORDERING_STORAGE_KEYS.CART,
      JSON.stringify(cart),
    );
  }, [cart]);

  useEffect(() => {
    if (!hasHydrated || !token || !orderingContext?.branchId) return;

    const loadLadyluck = async () => {
      setIsLadyluckLoading(true);
      try {
        const summary = await CustomerOrderingApi.getLadyluckSummary(orderingContext.branchId);
        const storedDiscountId = sessionStorage.getItem(CUSTOMER_ORDERING_STORAGE_KEYS.LADYLUCK_DISCOUNT_ID) || "";
        const nextDiscount = summary.active_discounts.find((discount) => discount.id === storedDiscountId) || summary.active_discounts[0];
        setLadyluckSummary(summary);
        if (nextDiscount) {
          setSelectedLadyluckDiscountId(nextDiscount.id);
          sessionStorage.setItem(CUSTOMER_ORDERING_STORAGE_KEYS.LADYLUCK_DISCOUNT_ID, nextDiscount.id);
        } else {
          setSelectedLadyluckDiscountId("");
          sessionStorage.removeItem(CUSTOMER_ORDERING_STORAGE_KEYS.LADYLUCK_DISCOUNT_ID);
        }
      } catch {
        setLadyluckSummary(null);
        setSelectedLadyluckDiscountId("");
        sessionStorage.removeItem(CUSTOMER_ORDERING_STORAGE_KEYS.LADYLUCK_DISCOUNT_ID);
      } finally {
        setIsLadyluckLoading(false);
      }
    };

    loadLadyluck();
  }, [hasHydrated, token, orderingContext]);

  const allItems = useMemo(
    () =>
      flattenItems(categories, CUSTOMER_ORDERING_DEFAULTS.ACTIVE_CATEGORY_ID),
    [categories],
  );
  const cartItems = useMemo(
    () => buildCartItems(allItems, cart),
    [allItems, cart],
  );
  const subtotal = useMemo(() => calculateSubtotal(cartItems), [cartItems]);
  const activeLadyluckDiscount = useMemo(() => {
    if (!ladyluckSummary?.active_discounts.length) return null;
    return ladyluckSummary.active_discounts.find((discount) => discount.id === selectedLadyluckDiscountId) || ladyluckSummary.active_discounts[0];
  }, [ladyluckSummary, selectedLadyluckDiscountId]);
  const ladyluckDiscountAmount = useMemo(() => (
    activeLadyluckDiscount ? calculateLadyluckDiscount(activeLadyluckDiscount, subtotal) : 0
  ), [activeLadyluckDiscount, subtotal]);
  const payable = Math.max(0, subtotal - ladyluckDiscountAmount);
  const activeAddressId = selectedAddressId || addresses[0]?.id || "";
  const phoneRequiresCompletion =
    requiresPhone ||
    Boolean(user && (
      !user.phone ||
      user.phone.startsWith("no-phone-") ||
      user.phone.startsWith("merged_")
    ));

  const updateCart = (cartKey: string, delta: number) => {
    setCart((current) => {
      const line = current[cartKey];
      if (!line) return current;
      const cartItem = cartItems.find((item) => item.cartKey === cartKey);
      if (!cartItem) return current;
      const step = cartItem.saleMode.step_qty;
      const nextQuantity = Math.max(0, line.quantity + step * delta);
      const next = { ...current };
      if (nextQuantity === 0) delete next[cartKey];
      else {
        next[cartKey] = {
          ...line,
          quantity: cartItem.saleMode.allow_decimal
            ? Number(nextQuantity.toFixed(3))
            : Math.round(nextQuantity),
        };
      }
      return next;
    });
  };

  const toggleSeat = (seatId: string) => {
    setSelectedSeatIds((current) =>
      current.includes(seatId)
        ? current.filter((selectedSeatId) => selectedSeatId !== seatId)
        : [...current, seatId],
    );
  };

  const submitOrder = async () => {
    if (!orderingContext || cartItems.length === 0) return;

    if (!token) {
      router.push(
        `${CUSTOMER_ORDERING_ROUTES.LOGIN}?next=${encodeURIComponent(window.location.pathname + window.location.search)}`,
      );
      return;
    }

    if (!user) {
      setError("Loading your profile. Please try again.");
      AuthRepo.loadCurrentUser().catch(() => undefined);
      return;
    }

    if (phoneRequiresCompletion) {
      router.push(
        `${CUSTOMER_ORDERING_ROUTES.COMPLETE_PHONE}?next=${encodeURIComponent(window.location.pathname + window.location.search)}`,
      );
      return;
    }

    if (
      orderingContext.orderType === CUSTOMER_ORDER_TYPES.DINE_IN &&
      selectedSeatIds.length === 0
    ) {
      setError(CUSTOMER_ORDERING_TEXT.SEATS_REQUIRED);
      return;
    }

    if (
      orderingContext.orderType === CUSTOMER_ORDER_TYPES.DELIVERY &&
      !activeAddressId
    ) {
      setError(CUSTOMER_ORDERING_TEXT.ADDRESS_REQUIRED);
      return;
    }

    setIsSubmitting(true);
    setError("");
    try {
      await CustomerOrderingApi.createOrder({
        branch_id: orderingContext.branchId,
        table_id: orderingContext.tableId || undefined,
        table_side_ids: selectedSeatIds,
        uid: user?.id,
        delivery_address_id: activeAddressId || undefined,
        order_type: orderingContext.orderType,
        ladyluck_discount_id: ladyluckDiscountAmount > 0 ? activeLadyluckDiscount?.id : undefined,
        final_paying_price: payable,
        items: cartItems.map((cartItem) => ({
          menu_item_id: cartItem.item.id,
          sale_mode_id: cartItem.saleMode.id,
          sale_mode_label: cartItem.saleMode.label,
          quantity_uom_id: cartItem.saleMode.uom_id,
          quantity_uom_code: cartItem.saleMode.uom_code,
          quantity: cartItem.quantity,
          unit_price: cartItem.saleMode.price_per_unit,
        })),
      });
      setCart({});
      sessionStorage.removeItem(CUSTOMER_ORDERING_STORAGE_KEYS.CART);
      sessionStorage.removeItem(CUSTOMER_ORDERING_STORAGE_KEYS.LADYLUCK_DISCOUNT_ID);
      // Route back to menu (or a success page ideally)
      router.push("/menu");
    } catch {
      setError(CUSTOMER_ORDERING_TEXT.ORDER_FAILED);
    } finally {
      setIsSubmitting(false);
    }
  };

  const scratchLadyluckCard = async () => {
    const scratchCard = ladyluckSummary?.available_scratch_cards[0];
    if (!orderingContext?.branchId || !scratchCard) return;

    setIsScratching(true);
    setError("");
    try {
      const discount = await CustomerOrderingApi.scratchLadyluckCard(orderingContext.branchId, scratchCard.id);
      setSelectedLadyluckDiscountId(discount.id);
      sessionStorage.setItem(CUSTOMER_ORDERING_STORAGE_KEYS.LADYLUCK_DISCOUNT_ID, discount.id);
      const summary = await CustomerOrderingApi.getLadyluckSummary(orderingContext.branchId);
      setLadyluckSummary(summary);
    } catch {
      setError(CUSTOMER_ORDERING_TEXT.LADYLUCK_SCRATCH_FAILED);
    } finally {
      setIsScratching(false);
    }
  };

  if (!isMounted || !hasHydrated || isLoading) {
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
          <button
            type="button"
            onClick={() => router.back()}
            className="p-2 -ml-2"
          >
            <ChevronLeft size={24} className="text-text-primary" />
          </button>
        </div>
        <div className="flex-1 flex flex-col items-center justify-center px-6 text-center">
          <p className="text-[15px] font-medium text-text-secondary">
            {CUSTOMER_ORDERING_TEXT.CART_EMPTY}
          </p>
          <button
            onClick={() => router.push("/menu")}
            className="mt-4 px-6 py-2 border border-primary-green text-primary-green rounded-full text-sm font-semibold"
          >
            Go to Menu
          </button>
        </div>
      </div>
    );
  }

  if (!orderingContext) {
    return (
      <div className="min-h-screen bg-[#FAFAFA] flex flex-col">
        <div className="bg-[#FAFAFA] px-4 py-3 flex items-center">
          <button
            type="button"
            onClick={() => router.back()}
            className="p-2 -ml-2"
          >
            <ChevronLeft size={24} className="text-text-primary" />
          </button>
        </div>
        <div className="flex-1 flex flex-col items-center justify-center px-6 text-center">
          <p className="text-[15px] font-medium text-text-secondary">
            {CUSTOMER_ORDERING_TEXT.CONTEXT_MISSING}
          </p>
          <button
            onClick={() => router.push(CUSTOMER_ORDERING_ROUTES.MENU)}
            className="mt-4 px-6 py-2 border border-primary-green text-primary-green rounded-full text-sm font-semibold"
          >
            {CUSTOMER_ORDERING_TEXT.CONTINUE}
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-[#FAFAFA] pb-32">
      <div className="bg-[#FAFAFA] px-4 py-3 flex items-center">
        <button
          type="button"
          onClick={() => router.back()}
          className="p-2 -ml-2"
        >
          <ChevronLeft size={24} className="text-text-primary" />
        </button>
      </div>

      <div className="px-4 mb-6">
        <h2 className="text-[18px] font-semibold text-text-primary mb-4">
          {CUSTOMER_ORDERING_TEXT.BILLING}
        </h2>

        <div className="flex flex-col gap-3 bg-pure-white p-4 rounded-[14px] border border-border-grey shadow-sm">
          {cartItems.map((cartItem) => (
            <div
              key={cartItem.cartKey}
              className="border-b border-border-grey pb-3 last:border-0 last:pb-0"
            >
              <div className="flex items-start justify-between gap-3">
                <div className="min-w-0">
                  <p className="text-[14px] font-medium text-text-primary leading-tight">
                    {cartItem.item.display_name}
                  </p>
                  <p className="text-[12px] font-normal text-text-secondary mt-1">
                    {cartItem.saleMode.label} • {formatAmount(cartItem.saleMode.price_per_unit)} / {cartItem.saleMode.uom_code || CUSTOMER_ORDERING_TEXT.DEFAULT_SALE_MODE}
                  </p>
                </div>
                <p className="text-[13px] font-semibold text-text-primary">
                  {formatAmount(
                    cartItem.saleMode.price_per_unit * cartItem.quantity,
                  )}
                </p>
              </div>
              <div className="mt-3 flex">
                <GreenStepper
                  count={`${formatQuantity(cartItem.quantity)} ${cartItem.saleMode.uom_code || ""}`.trim()}
                  onIncrement={() => updateCart(cartItem.cartKey, 1)}
                  onDecrement={() => updateCart(cartItem.cartKey, -1)}
                />
              </div>
            </div>
          ))}

          <div className="mt-2 pt-4 border-t border-border-grey flex flex-col gap-2">
            <LadyluckPanel
              summary={ladyluckSummary}
              activeDiscount={activeLadyluckDiscount}
              discountAmount={ladyluckDiscountAmount}
              subtotal={subtotal}
              isLoading={isLadyluckLoading}
              isScratching={isScratching}
              onScratch={scratchLadyluckCard}
            />
            <BillRow
              label={CUSTOMER_ORDERING_TEXT.SUBTOTAL}
              value={formatAmount(subtotal)}
            />
            {ladyluckDiscountAmount > 0 ? (
              <BillRow
                label={CUSTOMER_ORDERING_TEXT.LADYLUCK_DISCOUNT}
                value={`-${formatAmount(ladyluckDiscountAmount)}`}
              />
            ) : null}
            <div className="h-px bg-border-grey my-1" />
            <BillRow
              label={CUSTOMER_ORDERING_TEXT.PAYABLE}
              value={formatAmount(payable)}
              strong
            />
          </div>
        </div>
      </div>

      <div className="w-full h-[8px] bg-soft-grey my-4" />

      <CustomerContextPanel
        context={orderingContext}
        selectedSeatIds={selectedSeatIds}
        selectedAddressId={activeAddressId}
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
            ) : token ? (
              CUSTOMER_ORDERING_TEXT.PLACE_ORDER
            ) : (
              CUSTOMER_ORDERING_TEXT.LOGIN_TO_ORDER
            )}
          </button>
        </div>
      </div>
    </div>
  );
}

const BillRow = ({
  label,
  value,
  strong = false,
}: {
  label: string;
  value: string;
  strong?: boolean;
}) => (
  <div className="flex items-center justify-between">
    <span
      className={`text-[13px] ${strong ? "font-semibold text-text-primary" : "font-medium text-text-secondary"}`}
    >
      {label}
    </span>
    <span
      className={`text-[13px] ${strong ? "font-semibold text-text-primary" : "font-medium text-text-primary"}`}
    >
      {value}
    </span>
  </div>
);

const LadyluckPanel = ({
  summary,
  activeDiscount,
  discountAmount,
  subtotal,
  isLoading,
  isScratching,
  onScratch,
}: {
  summary: LadyluckSummary | null;
  activeDiscount: LadyluckDiscount | null;
  discountAmount: number;
  subtotal: number;
  isLoading: boolean;
  isScratching: boolean;
  onScratch: () => void;
}) => {
  if (isLoading) {
    return (
      <div className="mb-3 rounded-[12px] border border-border-grey bg-[#FAFAFA] px-3 py-3 text-[12px] font-semibold text-text-secondary">
        {CUSTOMER_ORDERING_TEXT.LADYLUCK_LOADING}
      </div>
    );
  }

  if (!summary) {
    return null;
  }

  const scratchCard = summary.available_scratch_cards[0];
  const points = summary.account.points_balance || 0;
  const needsMinimum = activeDiscount && subtotal < activeDiscount.min_order_amount;

  return (
    <div className="mb-3 rounded-[12px] border border-[#FEF3C7] bg-[#FFFBEB] px-3 py-3">
      <div className="flex items-start justify-between gap-3">
        <div className="flex gap-2">
          <div className="w-8 h-8 rounded-full bg-[#FDE68A] flex items-center justify-center shrink-0">
            <Gift size={16} className="text-[#92400E]" />
          </div>
          <div>
            <p className="text-[13px] font-bold text-text-primary">
              {activeDiscount ? CUSTOMER_ORDERING_TEXT.LADYLUCK_APPLIED : CUSTOMER_ORDERING_TEXT.LADYLUCK_TITLE}
            </p>
            <p className="mt-1 text-[11px] font-medium text-text-secondary">
              {points} {CUSTOMER_ORDERING_TEXT.LADYLUCK_POINTS}
            </p>
          </div>
        </div>
        {scratchCard ? (
          <button
            type="button"
            onClick={onScratch}
            disabled={isScratching}
            className="h-8 px-3 rounded-full bg-primary-green text-pure-white text-[11px] font-bold disabled:opacity-60"
          >
            {isScratching ? CUSTOMER_ORDERING_TEXT.LADYLUCK_LOADING : CUSTOMER_ORDERING_TEXT.LADYLUCK_SCRATCH_ACTION}
          </button>
        ) : null}
      </div>

      {scratchCard ? (
        <p className="mt-2 text-[11px] font-semibold text-[#92400E]">
          {CUSTOMER_ORDERING_TEXT.LADYLUCK_SCRATCH_READY}. {CUSTOMER_ORDERING_TEXT.LADYLUCK_SCRATCH_BODY}
        </p>
      ) : null}

      {activeDiscount ? (
        <div className="mt-3 rounded-[10px] bg-pure-white border border-[#FEF3C7] px-3 py-2 flex items-center justify-between gap-3">
          <div className="flex items-center gap-2 min-w-0">
            <BadgePercent size={16} className="text-[#2563EB] shrink-0" />
            <div className="min-w-0">
              <p className="text-[12px] font-bold text-text-primary truncate">
                {formatLadyluckDiscount(activeDiscount)}
              </p>
              <p className="text-[10px] font-semibold text-text-secondary mt-0.5">
                {CUSTOMER_ORDERING_TEXT.LADYLUCK_MINIMUM} {formatAmount(activeDiscount.min_order_amount)}
              </p>
            </div>
          </div>
          <span className="text-[12px] font-bold text-primary-green whitespace-nowrap">
            {needsMinimum ? formatAmount(Math.max(0, activeDiscount.min_order_amount - subtotal)) : `-${formatAmount(discountAmount)}`}
          </span>
        </div>
      ) : !scratchCard ? (
        <p className="mt-2 text-[11px] font-semibold text-text-secondary">
          {CUSTOMER_ORDERING_TEXT.LADYLUCK_NO_CARD}
        </p>
      ) : null}
    </div>
  );
};

const calculateLadyluckDiscount = (discount: LadyluckDiscount, subtotal: number) => {
  if (subtotal < discount.min_order_amount) return 0;
  const rawAmount = discount.discount_type === "PERCENTAGE"
    ? subtotal * discount.discount_value / 100
    : discount.discount_value;
  const cappedAmount = discount.max_discount_amount ? Math.min(rawAmount, discount.max_discount_amount) : rawAmount;
  return Math.max(0, Math.min(subtotal, Number(cappedAmount.toFixed(2))));
};

const formatLadyluckDiscount = (discount: LadyluckDiscount) => {
  if (discount.discount_type === "PERCENTAGE") {
    const cap = discount.max_discount_amount ? ` up to ${formatAmount(discount.max_discount_amount)}` : "";
    return `${discount.discount_value}% off${cap}`;
  }
  return `${formatAmount(discount.discount_value)} off`;
};

const normalizeStoredCart = (value: unknown): Record<string, CustomerCartLine> => {
  if (!value || typeof value !== "object") {
    return {};
  }
  return Object.entries(value as Record<string, unknown>).reduce<Record<string, CustomerCartLine>>((next, [key, entry]) => {
    if (typeof entry === "number") {
      return next;
    }
    if (entry && typeof entry === "object") {
      const line = entry as CustomerCartLine;
      if (line.menu_item_id && line.sale_mode_id) {
        next[key] = line;
      }
    }
    return next;
  }, {});
};
