"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import {
  ChevronLeft,
  Package,
  XCircle,
  Utensils,
  Truck,
  ShoppingBag,
  ChevronDown,
} from "lucide-react";
import { useUserStore } from "@/core/store/user.store";
import { apiClient } from "@/core/api/client";
import { formatInr, formatQuantityWithUnit } from "@/core/format";

type OrderStatus = "OPEN" | "BILLED" | "PAID" | "REFUNDED" | "CANCELLED" | "COMPLETED";
type OrderType = "DINE_IN" | "DELIVERY" | "TAKEAWAY";

interface OrderItem {
  id: string;
  qty: number;
  unit_price: number;
  total_price: number;
  quantity_uom_code?: string | null;
  base_uom_code?: string | null;
  menu_item: { id: string; display_name: string };
}

interface MyOrder {
  id: string;
  code: string | null;
  order_no: number;
  order_type: OrderType;
  status: OrderStatus;
  subtotal?: number;
  total_amount?: number;
  tax_amount?: number;
  discount_amount?: number;
  ladyluck_discount_id?: string | null;
  ladyluck_discount_amount?: number;
  final_paying_price: number;
  payment_proofs?: string[];
  created_at: string;
  branch: { id: string; name: string };
  items: OrderItem[];
}

const STATUS: Record<OrderStatus, { label: string; textColor: string; bgColor: string; dotColor: string }> = {
  OPEN:      { label: "Preparing",  textColor: "#B45309", bgColor: "#FFFBEB", dotColor: "#F59E0B" },
  BILLED:    { label: "Billed",     textColor: "#1D4ED8", bgColor: "#EFF6FF", dotColor: "#3B82F6" },
  PAID:      { label: "Paid",       textColor: "#15803D", bgColor: "#F0FDF4", dotColor: "#22C55E" },
  COMPLETED: { label: "Delivered",  textColor: "#15803D", bgColor: "#F0FDF4", dotColor: "#22C55E" },
  REFUNDED:  { label: "Refunded",   textColor: "#7E22CE", bgColor: "#FAF5FF", dotColor: "#A855F7" },
  CANCELLED: { label: "Cancelled",  textColor: "#DC2626", bgColor: "#FEF2F2", dotColor: "#EF4444" },
};

const ORDER_TYPE: Record<OrderType, { label: string; Icon: typeof Utensils }> = {
  DINE_IN:  { label: "Dine In",  Icon: Utensils },
  DELIVERY: { label: "Delivery", Icon: Truck },
  TAKEAWAY: { label: "Takeaway", Icon: ShoppingBag },
};

function formatDate(iso: string) {
  const d = new Date(iso);
  return {
    date: d.toLocaleDateString("en-IN", { day: "2-digit", month: "short", year: "numeric" }),
    time: d.toLocaleTimeString("en-IN", { hour: "2-digit", minute: "2-digit", hour12: true }).toUpperCase(),
  };
}

function orderSubtotal(order: MyOrder) {
  return Number(order.subtotal ?? order.items.reduce((total, item) => total + item.total_price, 0));
}

function orderSavedAmount(order: MyOrder) {
  return Number(order.ladyluck_discount_amount || order.discount_amount || 0);
}

function orderDiscountLabel(order: MyOrder) {
  return order.ladyluck_discount_id || Number(order.ladyluck_discount_amount || 0) > 0
    ? "Ladyluck discount"
    : "Discount";
}

export default function OrdersPage() {
  const router = useRouter();
  const { token } = useUserStore();
  const [orders, setOrders] = useState<MyOrder[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState("");
  const [expandedId, setExpandedId] = useState<string | null>(null);

  useEffect(() => {
    if (!token) { router.replace("/login"); return; }
    apiClient.get("/pos-kds/orders/my")
      .then((res) => setOrders(res.data.data || []))
      .catch(() => setError("Could not load your orders."))
      .finally(() => setIsLoading(false));
  }, [token, router]);

  return (
    <div className="min-h-screen bg-[#F4F5F7]">

      {/* ── Sticky Header ── */}
      <div className="bg-white sticky top-0 z-50" style={{ borderBottom: "1px solid #EBEBEB", boxShadow: "0 1px 0 #EBEBEB" }}>
        <div className="max-w-lg mx-auto px-4 h-14 flex items-center gap-2">
          <button
            type="button"
            onClick={() => router.back()}
            className="w-9 h-9 flex items-center justify-center rounded-full hover:bg-gray-100 active:scale-95 transition-all"
          >
            <ChevronLeft size={20} color="#1C1C1E" />
          </button>
          <h1 className="text-[17px] font-bold text-[#1C1C1E] flex-1">Your Orders</h1>
          {!isLoading && orders.length > 0 && (
            <span className="text-[12px] font-semibold text-[#8A8A8E] bg-[#F4F5F7] rounded-full px-3 py-1">
              {orders.length} orders
            </span>
          )}
        </div>
      </div>

      <div className="max-w-lg mx-auto px-4 py-5">

        {/* ── Loading ── */}
        {isLoading && (
          <div className="flex flex-col items-center py-24 gap-4">
            <div className="w-9 h-9 border-[2.5px] border-[#1CB15A] border-t-transparent rounded-full animate-spin" />
            <p className="text-[14px] font-medium text-[#8A8A8E]">Loading your orders…</p>
          </div>
        )}

        {/* ── Error ── */}
        {!isLoading && error && (
          <div className="flex flex-col items-center py-24 gap-4 text-center">
            <div className="w-16 h-16 rounded-2xl bg-[#FEF2F2] flex items-center justify-center">
              <XCircle size={30} color="#DC2626" />
            </div>
            <p className="text-[15px] font-bold text-[#1C1C1E]">{error}</p>
            <button
              onClick={() => window.location.reload()}
              className="mt-1 px-6 py-2.5 rounded-full bg-[#1CB15A] text-white text-[13px] font-semibold active:scale-95 transition-transform"
            >
              Try Again
            </button>
          </div>
        )}

        {/* ── Empty ── */}
        {!isLoading && !error && orders.length === 0 && (
          <div className="flex flex-col items-center py-24 gap-4 text-center">
            <div className="w-20 h-20 rounded-3xl bg-[#F0FDF4] flex items-center justify-center">
              <Package size={36} color="#1CB15A" strokeWidth={1.5} />
            </div>
            <div>
              <p className="text-[16px] font-bold text-[#1C1C1E]">No orders yet</p>
              <p className="text-[13px] font-medium text-[#8A8A8E] mt-1">Your order history will appear here.</p>
            </div>
            <button
              onClick={() => router.back()}
              className="mt-2 px-7 py-3 rounded-full bg-[#1CB15A] text-white text-[14px] font-semibold active:scale-95 transition-transform"
              style={{ boxShadow: "0 4px 14px rgba(28,177,90,0.35)" }}
            >
              Browse Menu
            </button>
          </div>
        )}

        {/* ── Orders List ── */}
        {!isLoading && !error && orders.length > 0 && (
          <div className="flex flex-col gap-3">
            {orders.map((order) => {
              const s = STATUS[order.status] ?? STATUS.OPEN;
              const t = ORDER_TYPE[order.order_type];
              const TypeIcon = t?.Icon ?? ShoppingBag;
              const isOpen = expandedId === order.id;
              const { date, time } = formatDate(order.created_at);
              const shortCode = order.code ? order.code.slice(-6) : `#${order.order_no}`;

              return (
                <div
                  key={order.id}
                  className="bg-white rounded-2xl overflow-hidden"
                  style={{ border: "1px solid #EBEBEB", boxShadow: "0 1px 4px rgba(0,0,0,0.06)" }}
                >
                  {/* Card header — tappable */}
                  <button
                    type="button"
                    className="w-full text-left px-4 pt-4 pb-3 flex items-start gap-3 active:bg-gray-50 transition-colors"
                    onClick={() => setExpandedId(isOpen ? null : order.id)}
                  >
                    {/* Type icon bubble */}
                    <div
                      className="w-11 h-11 rounded-xl flex items-center justify-center shrink-0 mt-0.5"
                      style={{ backgroundColor: s.bgColor }}
                    >
                      <TypeIcon size={18} color={s.textColor} strokeWidth={2} />
                    </div>

                    {/* Main info */}
                    <div className="flex-1 min-w-0">
                      <div className="flex items-start justify-between gap-2">
                        <div className="min-w-0">
                          <p className="text-[14px] font-bold text-[#1C1C1E] truncate leading-snug">{order.branch.name}</p>
                          <p className="text-[11px] font-medium text-[#8A8A8E] mt-0.5 leading-none">
                            {date} &nbsp;·&nbsp; {time}
                          </p>
                        </div>
                        <div className="flex flex-col items-end gap-1 shrink-0">
                          {/* Status badge */}
                          <span
                            className="flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] font-bold leading-none"
                            style={{ color: s.textColor, backgroundColor: s.bgColor }}
                          >
                            <span className="w-1.5 h-1.5 rounded-full inline-block" style={{ backgroundColor: s.dotColor }} />
                            {s.label}
                          </span>
                          {/* Amount */}
                          <span className="text-[15px] font-bold text-[#1C1C1E]">
                            {formatInr(order.final_paying_price)}
                          </span>
                        </div>
                      </div>

                      {/* Meta row */}
                      <div className="flex items-center gap-1.5 mt-2.5 flex-wrap">
                        <span className="flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] font-semibold text-[#8A8A8E] bg-[#F4F5F7]">
                          <TypeIcon size={9} /> {t?.label ?? order.order_type}
                        </span>
                        <span className="px-2 py-0.5 rounded-full text-[10px] font-bold text-[#1CB15A] bg-[#F0FDF4]">
                          {shortCode}
                        </span>
                        <span className="px-2 py-0.5 rounded-full text-[10px] font-semibold text-[#8A8A8E] bg-[#F4F5F7]">
                          {order.items.length} item{order.items.length !== 1 ? "s" : ""}
                        </span>
                      </div>
                    </div>

                    {/* Chevron */}
                    <ChevronDown
                      size={16}
                      color="#C7C7CC"
                      className="mt-2 shrink-0 transition-transform duration-200"
                      style={{ transform: isOpen ? "rotate(180deg)" : "rotate(0deg)" }}
                    />
                  </button>

                  {isOpen && (
                    <div style={{ borderTop: "1px solid #F2F2F7" }}>
                      <div className="px-4 py-3 bg-[#FAFAFA]">
                        <p className="text-[10px] font-semibold text-[#8A8A8E] uppercase mb-2">Receipt</p>
                        <div className="bg-white rounded-2xl border border-[#EBEBEB] px-4 py-4">
                          <div className="text-center">
                            <p className="text-[16px] font-semibold text-[#1C1C1E]">LadyLuck</p>
                            <p className="text-[11px] font-medium text-[#8A8A8E] mt-1">Order #{order.order_no}</p>
                          </div>
                          <div className="my-4 border-t border-dashed border-[#D8D8D8]" />
                        <div className="flex flex-col divide-y divide-[#F2F2F7]">
                          {order.items.map((item) => (
                            <div key={item.id} className="flex items-center justify-between py-2">
                              <div className="flex items-center gap-2 min-w-0">
                                <span className="min-w-8 h-5 px-1.5 rounded-full bg-[#F0FDF4] flex items-center justify-center text-[10px] font-bold text-[#1CB15A] shrink-0">
                                  {formatQuantityWithUnit(item.qty, item.quantity_uom_code || item.base_uom_code)}
                                </span>
                                <span className="text-[13px] font-medium text-[#1C1C1E] truncate">
                                  {item.menu_item.display_name}
                                </span>
                              </div>
                              <span className="text-[12px] font-semibold text-[#8A8A8E] shrink-0 ml-3">
                                {formatInr(item.total_price)}
                              </span>
                            </div>
                          ))}
                        </div>
                          <div className="my-4 border-t border-dashed border-[#D8D8D8]" />
                          <div className="flex flex-col gap-2">
                            <OrderReceiptRow label="Subtotal" value={formatInr(orderSubtotal(order))} />
                            {orderSavedAmount(order) > 0 ? (
                              <OrderReceiptRow label={orderDiscountLabel(order)} value={`-${formatInr(orderSavedAmount(order))}`} />
                            ) : null}
                            {Number(order.tax_amount || 0) > 0 ? (
                              <OrderReceiptRow label="Tax" value={formatInr(Number(order.tax_amount || 0))} />
                            ) : null}
                            <OrderReceiptRow label="Final paying" value={formatInr(order.final_paying_price || order.total_amount || orderSubtotal(order) - orderSavedAmount(order))} strong />
                          </div>
                          {orderSavedAmount(order) > 0 ? (
                            <div className="mt-4 rounded-xl border border-[#1CB15A] bg-[#F0FDF4] px-4 py-4 text-center">
                              <p className="text-[13px] font-semibold text-[#166534]">YOU SAVED</p>
                              <p className="mt-1 text-[32px] font-semibold leading-none text-[#1CB15A]">
                                {formatInr(orderSavedAmount(order))}
                              </p>
                              <p className="mt-2 text-[12px] font-medium text-[#166534]">Saved with Ladyluck</p>
                            </div>
                          ) : null}
                        </div>
                      </div>
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}

const OrderReceiptRow = ({
  label,
  value,
  strong = false,
}: {
  label: string;
  value: string;
  strong?: boolean;
}) => (
  <div className="flex items-center justify-between gap-3">
    <span className={`text-[12px] ${strong ? "font-semibold text-[#1C1C1E]" : "font-medium text-[#8A8A8E]"}`}>
      {label}
    </span>
    <span className={`shrink-0 text-[12px] ${strong ? "font-semibold text-[#1C1C1E]" : "font-medium text-[#1C1C1E]"}`}>
      {value}
    </span>
  </div>
);
