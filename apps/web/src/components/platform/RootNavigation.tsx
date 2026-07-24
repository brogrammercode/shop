"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { CookingPot, Flame, Home, ReceiptText, User } from "lucide-react";
import { useMemo } from "react";

const ROOT_NAV_BADGES = {
  NEW: "New",
} as const;

const NAV_ITEMS = [
  { href: "/menu", label: "Menu", icon: Home },
  { href: "/orders", label: "Orders", icon: ReceiptText },
  {
    href: "/mess-tiffin",
    label: "Mess / Tiffin",
    icon: CookingPot,
    badge: ROOT_NAV_BADGES.NEW,
  },
  { href: "/profile", label: "Profile", icon: User },
] as const;

const HIDDEN_PATHS = ["/login", "/complete-phone"] as const;

export const RootNavigation = () => {
  const pathname = usePathname();

  const isHidden = useMemo(
    () => HIDDEN_PATHS.some((path) => pathname === path || pathname.startsWith(`${path}/`)),
    [pathname],
  );

  if (isHidden) {
    return null;
  }

  return (
    <nav
      aria-label="Platform navigation"
      className="fixed bottom-[20px] left-1/2 z-50 flex h-[59px] w-[280px] -translate-x-1/2 items-center justify-between rounded-full bg-black px-[18px] text-white shadow-[0_18px_34px_rgba(0,0,0,0.35)]"
    >
      {NAV_ITEMS.map((item) => {
        const Icon = item.icon;
        const isActive = pathname === item.href || pathname.startsWith(`${item.href}/`);

        return (
          <Link
            key={item.href}
            href={item.href}
            aria-label={item.label}
            aria-current={isActive ? "page" : undefined}
            className={`relative flex h-[43px] w-[43px] items-center justify-center rounded-full transition-all ${
              isActive
                ? "bg-[#ff7448] text-white shadow-[0_8px_20px_rgba(255,116,72,0.42)]"
                : "text-white/78 hover:bg-white/10 hover:text-white"
            }`}
          >
            <Icon size={18} strokeWidth={1.9} />
            {"badge" in item ? (
              <span
                title={item.badge}
                className="absolute -right-1 -top-1 flex h-[16px] w-[16px] items-center justify-center rounded-full bg-[#ff7448] text-white shadow-[0_5px_12px_rgba(255,116,72,0.38)] ring-2 ring-black"
              >
                <Flame size={9} fill="currentColor" strokeWidth={2.2} />
                <span className="sr-only">{item.badge}</span>
              </span>
            ) : null}
          </Link>
        );
      })}
    </nav>
  );
};
