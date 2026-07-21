"use client";

import { useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import { BadgePercent, ChevronLeft, X } from "lucide-react";
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
  CustomerCartItem,
  CustomerCartLine,
  CustomerMenuCategory,
  CustomerOrderResponse,
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
  imageForItem,
  readOrderingContext,
} from "@/features/customer_ordering/utils/customer_ordering.utils";

type LadyluckPopupMode = "scratch" | "discount";

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
  const [ladyluckPopup, setLadyluckPopup] = useState<LadyluckPopupMode | null>(null);

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
        const hasScratchCard = summary.account.points_balance >= CUSTOMER_ORDERING_DEFAULTS.LADYLUCK_POINTS_PER_CARD && summary.available_scratch_cards.length > 0;
        setLadyluckSummary(summary);
        if (nextDiscount) {
          setSelectedLadyluckDiscountId(nextDiscount.id);
          sessionStorage.setItem(CUSTOMER_ORDERING_STORAGE_KEYS.LADYLUCK_DISCOUNT_ID, nextDiscount.id);
          setLadyluckPopup("discount");
        } else {
          setSelectedLadyluckDiscountId("");
          sessionStorage.removeItem(CUSTOMER_ORDERING_STORAGE_KEYS.LADYLUCK_DISCOUNT_ID);
          setLadyluckPopup(hasScratchCard ? "scratch" : null);
        }
      } catch {
        setLadyluckSummary(null);
        setSelectedLadyluckDiscountId("");
        setLadyluckPopup(null);
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
      setError(CUSTOMER_ORDERING_TEXT.PROFILE_LOADING);
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
    const submittedAt = Date.now();
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
    } catch {
      const wasPlaced = await confirmOrderPlaced({
        submittedAt,
        orderingContext,
        cartItems,
        subtotal,
        payable,
        activeAddressId,
      }).catch(() => false);
      if (!wasPlaced) {
        setError(CUSTOMER_ORDERING_TEXT.ORDER_FAILED);
        setIsSubmitting(false);
        return;
      }
    }

    try {
      setCart({});
      sessionStorage.removeItem(CUSTOMER_ORDERING_STORAGE_KEYS.CART);
      sessionStorage.removeItem(CUSTOMER_ORDERING_STORAGE_KEYS.LADYLUCK_DISCOUNT_ID);
      router.push(CUSTOMER_ORDERING_ROUTES.MENU);
    } finally {
      setIsSubmitting(false);
    }
  };

  const scratchLadyluckCard = async () => {
    const points = ladyluckSummary?.account.points_balance || 0;
    const scratchCard = ladyluckSummary?.available_scratch_cards[0];
    if (
      !orderingContext?.branchId ||
      !scratchCard ||
      points < CUSTOMER_ORDERING_DEFAULTS.LADYLUCK_POINTS_PER_CARD
    ) return;

    setIsScratching(true);
    setError("");
    try {
      const discount = await CustomerOrderingApi.scratchLadyluckCard(orderingContext.branchId, scratchCard.id);
      setSelectedLadyluckDiscountId(discount.id);
      sessionStorage.setItem(CUSTOMER_ORDERING_STORAGE_KEYS.LADYLUCK_DISCOUNT_ID, discount.id);
      const summary = await CustomerOrderingApi.getLadyluckSummary(orderingContext.branchId);
      setLadyluckSummary(summary);
      setLadyluckPopup("discount");
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

      <div className="mx-auto max-w-lg px-4 mb-6">
        <h2 className="text-[20px] font-semibold text-text-primary mb-4">
          {CUSTOMER_ORDERING_TEXT.CART_TITLE}
        </h2>

        <div className="flex flex-col gap-3">
          <div className="rounded-[20px] border border-border-grey bg-pure-white p-4 shadow-sm">
            <div className="mb-3 flex items-center justify-between">
              <p className="text-[12px] font-semibold uppercase text-text-tertiary">
                {CUSTOMER_ORDERING_TEXT.CART_ITEMS_TITLE}
              </p>
              <p className="text-[12px] font-medium text-text-secondary">
                {cartItems.length} {CUSTOMER_ORDERING_TEXT.ITEM_COUNT}
              </p>
            </div>
            {cartItems.map((cartItem) => (
              <div
                key={cartItem.cartKey}
                className="flex gap-3 border-b border-border-grey py-3 first:pt-0 last:border-0 last:pb-0"
              >
                <div className="h-[74px] w-[74px] shrink-0 overflow-hidden rounded-[16px] bg-soft-grey">
                  {imageForItem(cartItem.item) ? (
                    <img
                      src={imageForItem(cartItem.item)}
                      alt={cartItem.item.display_name}
                      className="h-full w-full object-cover"
                    />
                  ) : null}
                </div>
                <div className="min-w-0 flex-1">
                  <div className="flex items-start justify-between gap-3">
                    <div className="min-w-0">
                      <p className="text-[15px] font-medium leading-tight text-text-primary">
                        {cartItem.item.display_name}
                      </p>
                      <p className="mt-1 text-[12px] font-normal text-text-secondary">
                        {cartItem.saleMode.label} - {formatAmount(cartItem.saleMode.price_per_unit)} / {cartItem.saleMode.uom_code || CUSTOMER_ORDERING_TEXT.DEFAULT_SALE_MODE}
                      </p>
                    </div>
                    <p className="shrink-0 text-[14px] font-semibold text-text-primary">
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
              </div>
            ))}
          </div>

          <div className="rounded-[20px] border border-border-grey bg-pure-white p-4 shadow-sm">
            <LadyluckPanel
              summary={ladyluckSummary}
              activeDiscount={activeLadyluckDiscount}
              discountAmount={ladyluckDiscountAmount}
              subtotal={subtotal}
              isLoading={isLadyluckLoading}
              isScratching={isScratching}
              onShowDetails={() => setLadyluckPopup(activeLadyluckDiscount ? "discount" : "scratch")}
            />
            <OrderReceipt
              cartItems={cartItems}
              subtotal={subtotal}
              ladyluckDiscountAmount={ladyluckDiscountAmount}
              payable={payable}
              activeDiscount={activeLadyluckDiscount}
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
      {ladyluckPopup ? (
        <LadyluckRewardPopup
          mode={ladyluckPopup}
          summary={ladyluckSummary}
          activeDiscount={activeLadyluckDiscount}
          discountAmount={ladyluckDiscountAmount}
          subtotal={subtotal}
          isScratching={isScratching}
          onScratch={scratchLadyluckCard}
          onClose={() => setLadyluckPopup(null)}
        />
      ) : null}
    </div>
  );
}

const OrderReceipt = ({
  cartItems,
  subtotal,
  ladyluckDiscountAmount,
  payable,
  activeDiscount,
}: {
  cartItems: CustomerCartItem[];
  subtotal: number;
  ladyluckDiscountAmount: number;
  payable: number;
  activeDiscount: LadyluckDiscount | null;
}) => (
  <div className="mt-4 rounded-[16px] border border-border-grey bg-[#FAFAFA] p-4">
    <div className="text-center">
      <p className="text-[11px] font-semibold uppercase text-text-tertiary">
        {CUSTOMER_ORDERING_TEXT.ORDER_RECEIPT}
      </p>
      <p className="mt-2 text-[17px] font-semibold text-text-primary">
        {CUSTOMER_ORDERING_TEXT.RECEIPT_STORE_NAME}
      </p>
      <p className="mt-1 text-[11px] font-medium text-text-secondary">
        {CUSTOMER_ORDERING_TEXT.RECEIPT_ORDER_MODE}
      </p>
    </div>
    <div className="my-4 border-t border-dashed border-border-grey" />
    <div className="flex flex-col gap-2">
      {cartItems.map((cartItem) => (
        <div key={cartItem.cartKey} className="flex items-start justify-between gap-3">
          <div className="min-w-0">
            <p className="truncate text-[12px] font-medium text-text-primary">
              {cartItem.item.display_name}
            </p>
            <p className="mt-0.5 text-[11px] font-normal text-text-secondary">
              {formatQuantity(cartItem.quantity)} {cartItem.saleMode.uom_code || CUSTOMER_ORDERING_TEXT.DEFAULT_SALE_MODE} x {formatAmount(cartItem.saleMode.price_per_unit)}
            </p>
          </div>
          <span className="shrink-0 text-[12px] font-semibold text-text-primary">
            {formatAmount(cartItem.saleMode.price_per_unit * cartItem.quantity)}
          </span>
        </div>
      ))}
    </div>
    <div className="my-4 border-t border-dashed border-border-grey" />
    <div className="flex flex-col gap-2">
      <ReceiptAmountRow
        label={CUSTOMER_ORDERING_TEXT.RECEIPT_SUBTOTAL}
        value={formatAmount(subtotal)}
      />
      {ladyluckDiscountAmount > 0 ? (
        <ReceiptAmountRow
          label={CUSTOMER_ORDERING_TEXT.LADYLUCK_DISCOUNT}
          value={`-${formatAmount(ladyluckDiscountAmount)}`}
        />
      ) : null}
      {activeDiscount && ladyluckDiscountAmount === 0 ? (
        <ReceiptAmountRow
          label={formatLadyluckDiscount(activeDiscount)}
          value={CUSTOMER_ORDERING_TEXT.RECEIPT_ESTIMATE}
        />
      ) : null}
      <ReceiptAmountRow
        label={CUSTOMER_ORDERING_TEXT.RECEIPT_FINAL_PAYING}
        value={formatAmount(payable)}
        strong
      />
    </div>
    <SavingsCallout amount={ladyluckDiscountAmount} />
  </div>
);

const ReceiptAmountRow = ({
  label,
  value,
  strong = false,
}: {
  label: string;
  value: string;
  strong?: boolean;
}) => (
  <div className="flex items-center justify-between gap-3">
    <span className={`text-[12px] ${strong ? "font-semibold text-text-primary" : "font-medium text-text-secondary"}`}>
      {label}
    </span>
    <span className={`shrink-0 text-[12px] ${strong ? "font-semibold text-text-primary" : "font-medium text-text-primary"}`}>
      {value}
    </span>
  </div>
);

const SavingsCallout = ({ amount }: { amount: number }) => {
  if (amount <= 0) {
    return null;
  }

  return (
    <div className="mt-4 rounded-[14px] border border-primary-green bg-[#F0FDF4] px-4 py-4 text-center">
      <p className="text-[13px] font-semibold text-[#166534]">
        {CUSTOMER_ORDERING_TEXT.LADYLUCK_YOU_SAVED}
      </p>
      <p className="mt-1 text-[34px] font-semibold leading-none text-primary-green">
        {formatAmount(amount)}
      </p>
      <p className="mt-2 text-[12px] font-medium text-[#166534]">
        {CUSTOMER_ORDERING_TEXT.LADYLUCK_SAVED_WITH}
      </p>
    </div>
  );
};

const LadyluckLogoMark = ({ size = "large" }: { size?: "small" | "large" }) => {
  const wrapperClass = size === "small" ? "h-8 w-8" : "h-14 w-14";
  const backgroundSize = size === "small" ? "122px 122px" : "214px 214px";
  const backgroundPosition = size === "small" ? "-24px -48px" : "-42px -84px";

  return (
    <span
      role="img"
      aria-label={CUSTOMER_ORDERING_TEXT.LADYLUCK_MASCOT}
      className={`block ${wrapperClass} shrink-0 rounded-full bg-[#1C1C1C]`}
      style={{
        backgroundImage: "url('/logo_transparent.png')",
        backgroundSize,
        backgroundPosition,
        backgroundRepeat: "no-repeat",
      }}
    >
      <span className="sr-only">
        {CUSTOMER_ORDERING_TEXT.LADYLUCK_MASCOT}
      </span>
    </span>
  );
};

const LadyluckPanel = ({
  summary,
  activeDiscount,
  discountAmount,
  subtotal,
  isLoading,
  isScratching,
  onShowDetails,
}: {
  summary: LadyluckSummary | null;
  activeDiscount: LadyluckDiscount | null;
  discountAmount: number;
  subtotal: number;
  isLoading: boolean;
  isScratching: boolean;
  onShowDetails: () => void;
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

  const points = summary.account.points_balance || 0;
  const canScratch = points >= CUSTOMER_ORDERING_DEFAULTS.LADYLUCK_POINTS_PER_CARD;
  const scratchCard = canScratch ? summary.available_scratch_cards[0] : null;
  const needsMinimum = activeDiscount && subtotal < activeDiscount.min_order_amount;
  const pointsToGo = Math.max(0, CUSTOMER_ORDERING_DEFAULTS.LADYLUCK_POINTS_PER_CARD - points);
  const progress = Math.min(100, points / CUSTOMER_ORDERING_DEFAULTS.LADYLUCK_POINTS_PER_CARD * 100);

  return (
    <div className="mb-3 rounded-[12px] border border-[#FEF3C7] bg-[#FFFBEB] px-3 py-3">
      <div className="flex items-start justify-between gap-3">
        <div className="flex gap-2">
          <LadyluckLogoMark size="small" />
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
            onClick={onShowDetails}
            disabled={isScratching}
            className="h-8 px-3 rounded-full bg-primary-green text-pure-white text-[11px] font-bold disabled:opacity-60"
          >
            {isScratching ? CUSTOMER_ORDERING_TEXT.LADYLUCK_LOADING : CUSTOMER_ORDERING_TEXT.LADYLUCK_SCRATCH_ACTION}
          </button>
        ) : null}
      </div>
      <div className="mt-3">
        <div className="h-2 overflow-hidden rounded-full bg-[#FEF3C7]">
          <div
            className="h-full rounded-full bg-primary-green transition-all"
            style={{ width: `${progress}%` }}
          />
        </div>
        <div className="mt-2 flex items-center justify-between gap-3">
          <span className="text-[11px] font-medium text-text-secondary">
            {points}/{CUSTOMER_ORDERING_DEFAULTS.LADYLUCK_POINTS_PER_CARD} {CUSTOMER_ORDERING_TEXT.LADYLUCK_POINTS_SHORT}
          </span>
          <span className="text-right text-[11px] font-semibold text-[#92400E]">
            {canScratch ? CUSTOMER_ORDERING_TEXT.LADYLUCK_MILESTONE_UNLOCKED : `${pointsToGo} ${CUSTOMER_ORDERING_TEXT.LADYLUCK_POINTS_TO_GO}`}
          </span>
        </div>
      </div>

      {scratchCard ? (
        <p className="mt-2 text-[11px] font-semibold text-[#92400E]">
          {CUSTOMER_ORDERING_TEXT.LADYLUCK_SCRATCH_READY}. {CUSTOMER_ORDERING_TEXT.LADYLUCK_SCRATCH_BODY}
        </p>
      ) : null}

      {activeDiscount ? (
        <button
          type="button"
          onClick={onShowDetails}
          className="mt-3 w-full rounded-[10px] bg-pure-white border border-[#FEF3C7] px-3 py-2 flex items-center justify-between gap-3 text-left"
        >
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
        </button>
      ) : !scratchCard ? (
        <p className="mt-2 text-[11px] font-semibold text-text-secondary">
          {CUSTOMER_ORDERING_TEXT.LADYLUCK_NO_CARD}
        </p>
      ) : null}
    </div>
  );
};

const LadyluckRewardPopup = ({
  mode,
  summary,
  activeDiscount,
  discountAmount,
  subtotal,
  isScratching,
  onScratch,
  onClose,
}: {
  mode: LadyluckPopupMode;
  summary: LadyluckSummary | null;
  activeDiscount: LadyluckDiscount | null;
  discountAmount: number;
  subtotal: number;
  isScratching: boolean;
  onScratch: () => void;
  onClose: () => void;
}) => {
  const points = summary?.account.points_balance || 0;
  const scratchCard = points >= CUSTOMER_ORDERING_DEFAULTS.LADYLUCK_POINTS_PER_CARD ? summary?.available_scratch_cards[0] : null;
  const discount = activeDiscount;

  if (mode === "scratch" && !scratchCard) {
    return null;
  }

  if (mode === "discount" && !discount) {
    return null;
  }

  const title = mode === "scratch"
    ? CUSTOMER_ORDERING_TEXT.LADYLUCK_POPUP_READY_TITLE
    : CUSTOMER_ORDERING_TEXT.LADYLUCK_POPUP_UNLOCKED_TITLE;
  const code = `${CUSTOMER_ORDERING_TEXT.LADYLUCK_CODE_PREFIX}${(scratchCard?.id || discount?.id || CUSTOMER_ORDERING_TEXT.LADYLUCK_POPUP_READY_CODE).slice(-8).toUpperCase()}`;
  const body = mode === "scratch"
    ? CUSTOMER_ORDERING_TEXT.LADYLUCK_POPUP_READY_BODY
    : `${formatLadyluckDiscount(discount as LadyluckDiscount)}. ${CUSTOMER_ORDERING_TEXT.LADYLUCK_MINIMUM} ${formatAmount((discount as LadyluckDiscount).min_order_amount)}.`;
  const appliedSaving = mode === "discount" && discountAmount > 0;

  return (
    <div className="fixed inset-0 z-[70] flex items-end justify-center bg-black/45 px-4 pb-6" onClick={onClose}>
      <div
        className="relative w-full max-w-[360px] overflow-visible rounded-[26px] bg-gradient-to-br from-[#FDE047] via-[#F59E0B] to-[#F97316] px-5 pb-5 pt-9 text-center shadow-elevated"
        onClick={(event) => event.stopPropagation()}
      >
        <button
          type="button"
          onClick={onClose}
          className="absolute -right-2 -top-2 flex h-9 w-9 items-center justify-center rounded-full bg-[#FEF3C7] text-[#F97316] shadow-sm"
        >
          <X size={18} strokeWidth={2.5} />
        </button>
        <div className="absolute left-10 top-7 h-0 w-0 rotate-[-22deg] border-b-[14px] border-l-[18px] border-t-[5px] border-b-pure-white/60 border-l-transparent border-t-transparent" />
        <div className="absolute right-12 top-8 h-0 w-0 rotate-[24deg] border-b-[16px] border-l-[20px] border-t-[6px] border-b-pure-white/55 border-l-transparent border-t-transparent" />
        <div className="mb-4 flex justify-center">
          <LadyluckLogoMark />
        </div>
        <h3 className="text-[24px] font-black leading-tight text-pure-white">
          {title}
        </h3>
        <p className="mt-3 text-[23px] font-black text-pure-white">
          {code}
        </p>
        {appliedSaving ? (
          <div className="mt-4 rounded-[16px] bg-pure-white/20 px-4 py-3">
            <p className="text-[12px] font-black text-pure-white">
              {CUSTOMER_ORDERING_TEXT.LADYLUCK_YOU_SAVED}
            </p>
            <p className="mt-1 text-[34px] font-black leading-none text-pure-white">
              {formatAmount(discountAmount)}
            </p>
          </div>
        ) : null}
        <p className="mx-auto mt-4 max-w-[280px] text-[13px] font-bold leading-relaxed text-pure-white">
          {body}
        </p>
        {mode === "discount" && discount && subtotal < discount.min_order_amount ? (
          <p className="mt-2 text-[12px] font-bold text-pure-white/90">
            {CUSTOMER_ORDERING_TEXT.LADYLUCK_ADD_MORE}: {formatAmount(discount.min_order_amount - subtotal)}
          </p>
        ) : null}
        <button
          type="button"
          onClick={mode === "scratch" ? onScratch : onClose}
          disabled={isScratching}
          className="mt-6 h-12 w-full rounded-[8px] border border-pure-white bg-transparent text-[13px] font-black text-pure-white disabled:opacity-70"
        >
          {isScratching ? CUSTOMER_ORDERING_TEXT.LADYLUCK_LOADING : mode === "scratch" ? CUSTOMER_ORDERING_TEXT.LADYLUCK_SCRATCH_ACTION : CUSTOMER_ORDERING_TEXT.LADYLUCK_POPUP_ACTION}
        </button>
      </div>
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

const confirmOrderPlaced = async ({
  submittedAt,
  orderingContext,
  cartItems,
  subtotal,
  payable,
  activeAddressId,
}: {
  submittedAt: number;
  orderingContext: CustomerOrderingContext;
  cartItems: CustomerCartItem[];
  subtotal: number;
  payable: number;
  activeAddressId: string;
}) => {
  for (let attempt = 0; attempt < CUSTOMER_ORDERING_DEFAULTS.ORDER_CONFIRMATION_RETRY_COUNT; attempt += 1) {
    if (attempt > 0) {
      await wait(CUSTOMER_ORDERING_DEFAULTS.ORDER_CONFIRMATION_RETRY_DELAY_MS);
    }
    const orders = await CustomerOrderingApi.getMyOrders();
    const matchedOrder = orders.find((order) =>
      isMatchingSubmittedOrder(order, {
        submittedAt,
        orderingContext,
        cartItems,
        subtotal,
        payable,
        activeAddressId,
      }),
    );
    if (matchedOrder) {
      return true;
    }
  }
  return false;
};

const isMatchingSubmittedOrder = (
  order: CustomerOrderResponse,
  input: {
    submittedAt: number;
    orderingContext: CustomerOrderingContext;
    cartItems: CustomerCartItem[];
    subtotal: number;
    payable: number;
    activeAddressId: string;
  },
) => {
  const branchId = order.branch_id || order.branch?.id || "";
  if (branchId !== input.orderingContext.branchId) {
    return false;
  }

  if (order.order_type && order.order_type !== input.orderingContext.orderType) {
    return false;
  }

  if (
    input.orderingContext.orderType === CUSTOMER_ORDER_TYPES.DELIVERY &&
    input.activeAddressId &&
    order.delivery_address_id &&
    order.delivery_address_id !== input.activeAddressId
  ) {
    return false;
  }

  const touchedAt = Date.parse(order.updated_at || order.created_at || "");
  if (
    Number.isFinite(touchedAt) &&
    touchedAt < input.submittedAt - CUSTOMER_ORDERING_DEFAULTS.ORDER_CONFIRMATION_WINDOW_MS
  ) {
    return false;
  }

  const amount = Number(order.final_paying_price ?? order.total_amount ?? order.subtotal ?? 0);
  const amountMatches =
    isCloseAmount(amount, input.payable) ||
    isCloseAmount(amount, input.subtotal);
  return amountMatches || hasSubmittedCartItems(order, input.cartItems);
};

const hasSubmittedCartItems = (
  order: CustomerOrderResponse,
  cartItems: CustomerCartItem[],
) => {
  const orderItems = order.items || [];
  if (orderItems.length === 0) {
    return false;
  }

  return cartItems.every((cartItem) =>
    orderItems.some((orderItem) => {
      const menuItemId = orderItem.menu_item_id || orderItem.menu_item?.id || "";
      const sameMenuItem = menuItemId === cartItem.item.id;
      const sameSaleMode = !orderItem.sale_mode_id || orderItem.sale_mode_id === cartItem.saleMode.id;
      const enoughQuantity = Number(orderItem.qty || 0) >= cartItem.quantity;
      return sameMenuItem && sameSaleMode && enoughQuantity;
    }),
  );
};

const isCloseAmount = (left: number, right: number) => {
  return Number.isFinite(left) &&
    Number.isFinite(right) &&
    Math.abs(left - right) <= CUSTOMER_ORDERING_DEFAULTS.ORDER_AMOUNT_TOLERANCE;
};

const wait = (duration: number) => new Promise((resolve) => window.setTimeout(resolve, duration));

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
