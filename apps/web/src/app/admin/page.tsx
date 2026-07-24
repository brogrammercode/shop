import Link from "next/link";
import { ArrowRight } from "lucide-react";
import { AdminPageHeader } from "@/features/admin/components/AdminPrimitives";
import { ADMIN_NAV_ITEMS, ADMIN_TEXT } from "@/features/admin/constants/admin.constants";

export default function AdminHomePage() {
  return (
    <>
      <AdminPageHeader title={ADMIN_TEXT.TITLE} body={ADMIN_TEXT.SUBTITLE} />
      <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
        {ADMIN_NAV_ITEMS.map((item) => {
          const Icon = item.icon;
          return (
            <Link
              key={item.href}
              href={item.href}
              className="group rounded-[8px] border border-border-grey bg-pure-white p-5 shadow-sm transition-colors hover:border-primary-green/45"
            >
              <div className="flex h-11 w-11 items-center justify-center rounded-[8px] bg-[#E8F5E9] text-primary-green">
                <Icon size={21} strokeWidth={1.9} />
              </div>
              <div className="mt-5 flex items-center justify-between gap-3">
                <h2 className="text-[17px] font-semibold text-text-primary">{item.label}</h2>
                <ArrowRight size={17} className="text-text-tertiary transition-colors group-hover:text-primary-green" />
              </div>
            </Link>
          );
        })}
      </div>
    </>
  );
}
