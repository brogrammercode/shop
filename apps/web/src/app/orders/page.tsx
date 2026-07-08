"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import {
  ChevronLeft,
  Package,
  Clock,
  CheckCircle2,
  XCircle,
  RotateCcw,
  Utensils,
  Truck,
  ShoppingBag,
  ChevronDown,
} from "lucide-react";
import { useUserStore } from "@/core/store/user.store";
import { apiClient } from "@/core/api/client";

type OrderStatus = "OPEN" | "BILLED" | "PAID" | "REFUNDED" | "CANCELLED" | "COMPLETED";
type OrderType = "DINE_IN" | "DELIVERY" | "TAKEAWAY";

interface OrderItem {
  id: string;
  qty: number;
  unit_price: number;
  total_price: number;
  menu_item: { id: string; display_name: string };
}

interface MyOrder {
  id: string;
  code: string | null;
  order_no: number;
  order_type: OrderType;
  status: OrderStatus;
  final_paying_price: number;
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
                            ₹{Math.round(order.final_paying_price).toLocaleString("en-IN")}
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

                  {/* Expanded breakdown */}
                  {isOpen && (
                    <div style={{ borderTop: "1px solid #F2F2F7" }}>
                      <div className="px-4 py-3 bg-[#FAFAFA]">
                        <p className="text-[10px] font-extrabold text-[#C7C7CC] uppercase tracking-widest mb-2">Items</p>
                        <div className="flex flex-col divide-y divide-[#F2F2F7]">
                          {order.items.map((item) => (
                            <div key={item.id} className="flex items-center justify-between py-2">
                              <div className="flex items-center gap-2 min-w-0">
                                <span className="w-5 h-5 rounded-full bg-[#F0FDF4] flex items-center justify-center text-[10px] font-bold text-[#1CB15A] shrink-0">
                                  {item.qty}
                                </span>
                                <span className="text-[13px] font-medium text-[#1C1C1E] truncate">
                                  {item.menu_item.display_name}
                                </span>
                              </div>
                              <span className="text-[12px] font-semibold text-[#8A8A8E] shrink-0 ml-3">
                                ₹{Math.round(item.total_price).toLocaleString("en-IN")}
                              </span>
                            </div>
                          ))}
                        </div>

                        {/* Total row */}
                        <div className="flex items-center justify-between mt-2 pt-2" style={{ borderTop: "1px solid #EBEBEB" }}>
                          <span className="text-[12px] font-bold text-[#1C1C1E]">Total Paid</span>
                          <span className="text-[14px] font-extrabold text-[#1C1C1E]">
                            ₹{Math.round(order.final_paying_price).toLocaleString("en-IN")}
                          </span>
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
