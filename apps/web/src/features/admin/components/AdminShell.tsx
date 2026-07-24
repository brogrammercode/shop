"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { ADMIN_NAV_ITEMS, ADMIN_TEXT } from "../constants/admin.constants";

interface AdminShellProps {
  children: React.ReactNode;
}

export const AdminShell = ({ children }: AdminShellProps) => {
  const pathname = usePathname();

  return (
    <main className="min-h-screen w-full bg-[#F7F8F7] pb-[var(--root-nav-clearance)] text-text-primary">
      <div className="flex min-h-screen w-full flex-col lg:flex-row">
        <aside className="w-full border-b border-border-grey bg-pure-white px-4 py-4 shadow-sm lg:sticky lg:top-0 lg:h-screen lg:w-[280px] lg:border-b-0 lg:border-r lg:px-5 lg:py-6">
          <Link href="/admin" className="block rounded-[8px] bg-[#111A14] px-4 py-4 text-pure-white shadow-[0_12px_30px_rgba(17,26,20,0.18)]">
            <p className="text-[12px] font-medium uppercase tracking-[0.08em] text-pure-white/60">Ladyluck</p>
            <h1 className="mt-1 text-[22px] font-semibold leading-tight">{ADMIN_TEXT.TITLE}</h1>
          </Link>
          <nav className="mt-4 grid grid-cols-2 gap-2 lg:grid-cols-1" aria-label={ADMIN_TEXT.TITLE}>
            {ADMIN_NAV_ITEMS.map((item) => {
              const Icon = item.icon;
              const active = pathname === item.href || pathname.startsWith(`${item.href}/`);
              return (
                <Link
                  key={item.href}
                  href={item.href}
                  className={`flex h-12 items-center gap-3 rounded-[8px] px-3 text-[13px] font-medium transition-colors ${
                    active
                      ? "bg-[#E8F5E9] text-primary-green ring-1 ring-primary-green/20"
                      : "text-text-secondary hover:bg-soft-grey hover:text-text-primary"
                  }`}
                >
                  <Icon size={18} strokeWidth={1.9} />
                  <span className="truncate">{item.label}</span>
                </Link>
              );
            })}
          </nav>
        </aside>
        <section className="min-w-0 flex-1 px-4 py-5 sm:px-6 lg:px-8 lg:py-7">
          <div className="mx-auto flex w-full max-w-[1480px] flex-col gap-5">{children}</div>
        </section>
      </div>
    </main>
  );
};
