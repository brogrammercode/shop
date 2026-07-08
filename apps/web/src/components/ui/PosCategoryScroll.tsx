import React from "react";

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
}

export const PosCategoryScroll = ({ categories, activeId, onSelect }: PosCategoryScrollProps) => {
  return (
    <div className="w-full overflow-x-auto no-scrollbar py-4 px-4 flex items-start gap-5">
      {categories.map((cat) => {
        const isActive = activeId === cat.id;

        return (
          <button
            key={cat.id}
            onClick={() => onSelect(cat.id)}
            className="flex flex-col items-center gap-2 shrink-0 group active:scale-95 transition-transform"
          >
            <div className="w-[56px] h-[56px] rounded-full overflow-hidden flex items-center justify-center bg-soft-grey relative shadow-none">
              {cat.isAllItems ? (
                <div className="flex flex-col items-center justify-center text-text-secondary">
                  <svg className="w-[22px] h-[22px]" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M12 2l-5.5 9h11zM17.5 13c-2.48 0-4.5 2.02-4.5 4.5s2.02 4.5 4.5 4.5 4.5-2.02 4.5-4.5-2.02-4.5-4.5-4.5zm-13 1h8v8h-8z"/>
                  </svg>
                </div>
              ) : (
                cat.imageUrl ? (
                  <img src={cat.imageUrl} alt={cat.label} className="w-full h-full object-cover" />
                ) : (
                  <span className="text-text-secondary text-xs">Image</span>
                )
              )}
            </div>

            <div className="flex flex-col items-center">
              <span
                className={`text-[12px] tracking-tight ${
                  isActive ? "font-medium text-text-primary" : "font-normal text-text-secondary"
                }`}
              >
                {cat.label}
              </span>
              
              <div className={`h-[2.5px] mt-[3px] rounded-full w-full ${isActive ? 'bg-[#0F8244]' : 'bg-transparent'}`} />
            </div>
          </button>
        );
      })}
    </div>
  );
};
