import React from "react";
import { Shapes } from "lucide-react";

interface PosCategory {
  id: string;
  label: string;
  imageUrl?: string;
  isAllItems?: boolean;
}

interface PosCategoryScrollProps {
  categories: PosCategory[];
  activeId: string;
  onSelect: (id: string) => void;
  activeLabel: string;
  inactiveLabel: string;
}

export const PosCategoryScroll = ({ categories, activeId, onSelect, activeLabel, inactiveLabel }: PosCategoryScrollProps) => {
  return (
    <div className="sticky top-[64px] z-40 w-full overflow-x-auto no-scrollbar bg-[#F8F2E6]/88 px-4 py-4 backdrop-blur-2xl">
      <div className="flex w-max min-w-full flex-nowrap items-center gap-3">
      {categories.map((cat) => {
        const isActive = activeId === cat.id;

        return (
          <button
            key={cat.id}
            onClick={() => onSelect(cat.id)}
            className={`flex h-[70px] w-[132px] shrink-0 items-center gap-3 rounded-[24px] pl-2 pr-3 text-left active:scale-95 transition-all ${isActive ? "bg-[#111A14] shadow-[0_16px_40px_rgba(17,26,20,0.18)]" : "bg-pure-white/86 shadow-sm ring-1 ring-black/5"}`}
          >
            <div className={`relative flex h-12 w-12 shrink-0 items-center justify-center overflow-hidden rounded-[18px] ${isActive ? "bg-[#D8FF1F]" : "bg-[#F3E8D0]"}`}>
              {cat.isAllItems ? (
                <Shapes size={22} className={isActive ? "text-[#111A14]" : "text-text-secondary"} />
              ) : (
                cat.imageUrl ? (
                  <img src={cat.imageUrl} alt={cat.label} className="h-full w-full object-cover" />
                ) : (
                  <Shapes size={20} className={isActive ? "text-pure-white" : "text-text-secondary"} />
                )
              )}
              {isActive && !cat.isAllItems ? <div className="absolute inset-0 bg-[#D8FF1F]/10" /> : null}
            </div>

            <div className="flex min-w-0 flex-1 flex-col items-start justify-center">
              <span
                className={`w-full truncate text-[12px] ${
                  isActive ? "font-semibold text-pure-white" : "font-medium text-text-primary"
                }`}
              >
                {cat.label}
              </span>
              <span className={`mt-1 text-[10px] font-medium ${isActive ? "text-[#D8FF1F]" : "text-text-tertiary"}`}>
                {isActive ? activeLabel : inactiveLabel}
              </span>
            </div>
          </button>
        );
      })}
      </div>
    </div>
  );
};
