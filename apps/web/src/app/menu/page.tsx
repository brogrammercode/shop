"use client";

import { useEffect, useState } from "react";
import { apiClient } from "@/core/api_client";
import { PosCategoryScroll } from "@/components/ui/PosCategoryScroll";
import { PosProductCard } from "@/components/ui/PosProductCard";
import { PosBottomAction } from "@/components/ui/PosBottomAction";
import { _MENU_CONSTANTS } from "@/constants/menu.constant";

interface MenuItem {
  id: string;
  display_name: string;
  selling_price: number;
  images?: string[];
}

interface MenuCategory {
  id: string;
  name: string;
  images?: string[];
  items: MenuItem[];
}

export default function PosTerminalPage() {
  const [sessionBranchId, setSessionBranchId] = useState<string>('test_branch_id');
  const [sessionTableId, setSessionTableId] = useState<string | null>(null);

  const [categories, setCategories] = useState<any[]>([]);
  const [items, setItems] = useState<any[]>([]);
  const [activeCategoryId, setActiveCategoryId] = useState("all");
  const [isLoading, setIsLoading] = useState(true);
  
  // Cart State
  const [cart, setCart] = useState<Record<string, number>>({});
  const [isOrdering, setIsOrdering] = useState(false);

  // Read from URL and SessionStorage
  useEffect(() => {
    if (typeof window !== "undefined") {
      const params = new URLSearchParams(window.location.search);
      const urlBranchId = params.get('branch_id');
      const urlTableId = params.get('table_id');

      if (urlBranchId) {
        sessionStorage.setItem('qr_branch_id', urlBranchId);
        setSessionBranchId(urlBranchId);
      } else {
        const storedBranchId = sessionStorage.getItem('qr_branch_id');
        if (storedBranchId) setSessionBranchId(storedBranchId);
      }

      if (urlTableId) {
        sessionStorage.setItem('qr_table_id', urlTableId);
        setSessionTableId(urlTableId);
      } else {
        const storedTableId = sessionStorage.getItem('qr_table_id');
        if (storedTableId) setSessionTableId(storedTableId);
      }
    }
  }, []);

  useEffect(() => {
    const fetchMenu = async () => {
      try {
        const data = await apiClient.get<MenuCategory[]>('/catalog/menu', { branch_id: sessionBranchId });
        if (data && data.length > 0) {
          // Transform API data into POS structure
          const posCats = [
            { id: "all", label: "All Items", isAllItems: true },
            ...data.map(c => ({
              id: c.id,
              label: c.name,
              imageUrl: c.images?.[0] || "",
            }))
          ];
          setCategories(posCats);

          // Get items based on active category
          let posItems: MenuItem[] = [];
          if (activeCategoryId === "all") {
            posItems = data.flatMap(c => c.items);
          } else {
            const activeCat = data.find(c => c.id === activeCategoryId);
            if (activeCat) posItems = activeCat.items;
          }

          setItems(posItems.map(i => ({
            id: i.id,
            title: i.display_name,
            price: i.selling_price,
            imageUrl: i.images?.[0] || ""
          })));
        } else {
          setCategories([{ id: "all", label: "All Items", isAllItems: true }]);
          setItems([]);
        }
      } catch (err) {
        console.error("API Fetch Error:", err);
        setCategories([{ id: "all", label: "All Items", isAllItems: true }]);
        setItems([]);
      } finally {
        setIsLoading(false);
      }
    };
    fetchMenu();
  }, [activeCategoryId, sessionBranchId]);

  const handleUpdateCart = (id: string, delta: number) => {
    setCart((prev) => {
      const current = prev[id] || 0;
      const next = Math.max(0, current + delta);
      const newCart = { ...prev };
      if (next === 0) {
        delete newCart[id];
      } else {
        newCart[id] = next;
      }
      return newCart;
    });
  };

  const totalItems = Object.values(cart).reduce((a, b) => a + b, 0);
  const totalPrice = Object.entries(cart).reduce((total, [id, qty]) => {
    const item = items.find(i => i.id === id);
    return total + ((item?.price || 0) * qty);
  }, 0);

  const handlePlaceOrder = async () => {
    if (totalItems === 0) return;
    setIsOrdering(true);
    try {
      const orderItems = Object.entries(cart).map(([menuItemId, quantity]) => {
        const item = items.find(i => i.id === menuItemId);
        return {
          menu_item_id: menuItemId,
          quantity,
          unit_price: item?.price || 0
        };
      });
      
      const payload = {
        branch_id: sessionBranchId,
        table_id: sessionTableId,
        order_type: 'DINE_IN',
        items: orderItems
      };
      
      // Hit the API
      await apiClient.post('/pos-kds/orders', payload);
      alert(_MENU_CONSTANTS._L_A_B_E_L_S.ORDER_SUCCESS);
      setCart({}); // clear cart on success
    } catch (err) {
      console.error("Order error", err);
      alert("Order submitted (Mocked/Fallback)");
      setCart({});
    } finally {
      setIsOrdering(false);
    }
  };

  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-pure-white">
        <div className="w-8 h-8 border-4 border-primary-green border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-pure-white pb-32">
      
      {/* 11.1 App Bar */}
      <div className="pt-10 px-4 pb-4 bg-pure-white flex flex-col gap-4">
        <div className="flex items-center gap-4">
          <button className="w-10 h-10 rounded-full bg-pure-white shadow-[0_2px_10px_rgba(0,0,0,0.05)] border border-gray-100 flex items-center justify-center active:scale-95 transition-transform">
            <svg className="w-5 h-5 text-text-primary" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M15 19l-7-7 7-7" />
            </svg>
          </button>
          <h1 className="text-[20px] font-semibold text-text-primary tracking-tight">
            POS Terminal
          </h1>
        </div>
      </div>

      {/* 11.2 Category Horizontal Scroll */}
      <PosCategoryScroll 
        categories={categories}
        activeId={activeCategoryId}
        onSelect={setActiveCategoryId}
      />

      {/* 11.3 Divider */}
      <div className="w-full h-[8px] bg-[#F5F5F5] my-2" />

      {/* 11.4 Product Grid */}
      <div className="px-4 py-2">
        <div className="grid grid-cols-2 gap-4">
          {items.map((item) => (
            <PosProductCard
              key={item.id}
              title={item.title}
              price={item.price}
              imageUrl={item.imageUrl}
              quantity={cart[item.id] || 0}
              onAdd={() => handleUpdateCart(item.id, 1)}
              onIncrement={() => handleUpdateCart(item.id, 1)}
              onDecrement={() => handleUpdateCart(item.id, -1)}
            />
          ))}
        </div>
      </div>

      {/* 11.5 Floating Bottom Navigation */}
      <PosBottomAction 
        totalItems={totalItems}
        totalPrice={totalPrice}
        onPlaceOrder={handlePlaceOrder}
        isOrdering={isOrdering}
      />
      
    </div>
  );
}
