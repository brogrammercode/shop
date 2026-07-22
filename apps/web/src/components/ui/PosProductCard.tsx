import React from "react";
import { GreenStepper } from "./GreenStepper";
import { Heart, Plus } from "lucide-react";

interface PosProductCardProps {
  title: string;
  description: string;
  priceLabel: string;
  imageUrl?: string;
  quantityLabel?: string;
  onAdd?: () => void;
  onIncrement?: () => void;
  onDecrement?: () => void;
  actionLabel: string;
  favoriteLabel: string;
}

export const PosProductCard = ({ 
  title, 
  description,
  priceLabel,
  imageUrl, 
  quantityLabel,
  onAdd,
  onIncrement,
  onDecrement,
  actionLabel,
  favoriteLabel,
}: PosProductCardProps) => {
  const hasQuantity = Boolean(quantityLabel);

  return (
    <div
      onClick={!hasQuantity ? onAdd : undefined}
      role="button"
      tabIndex={0}
      onKeyDown={(event) => {
        if ((event.key === "Enter" || event.key === " ") && !hasQuantity && onAdd) {
          event.preventDefault();
          onAdd();
        }
      }}
      className={`group relative min-h-[328px] overflow-hidden rounded-[34px] bg-[#111A14] text-left shadow-[0_24px_70px_rgba(17,26,20,0.18)] ring-1 ring-black/5 ${!hasQuantity ? "cursor-pointer active:scale-[0.99]" : ""} transition-transform`}
    >
      {imageUrl ? (
        <img src={imageUrl} alt={title} className="absolute inset-0 h-full w-full object-cover object-center transition-transform duration-700 group-hover:scale-[1.04]" />
      ) : (
        <div className="absolute inset-0 h-full w-full bg-[#D9F3EA]" />
      )}
      <div className="absolute inset-0 bg-gradient-to-t from-[#07120B]/92 via-[#07120B]/24 to-black/18" />
      <div className="absolute inset-x-0 bottom-0 h-36 bg-gradient-to-t from-[#07120B] to-transparent" />
      <button
        type="button"
        aria-label={favoriteLabel}
        className="absolute right-4 top-4 z-10 flex h-11 w-11 items-center justify-center rounded-full bg-pure-white/92 text-[#111A14] shadow-[0_10px_30px_rgba(0,0,0,0.18)] backdrop-blur-xl"
        onClick={(event) => event.stopPropagation()}
      >
        <Heart size={20} strokeWidth={2.2} />
      </button>
      <div className="absolute left-4 top-4 rounded-full bg-[#D8FF1F] px-3.5 py-2 text-[15px] font-semibold text-[#102015] shadow-[0_10px_26px_rgba(0,0,0,0.12)]">
        {priceLabel}
      </div>
      <div className="relative z-10 flex min-h-[328px] flex-col justify-end p-4">
        <div>
          <h3 className="text-[23px] font-semibold leading-[1.08] text-pure-white line-clamp-3">
            {title}
          </h3>
          <p className="mt-2 max-w-[86%] text-[12px] font-medium leading-[1.35] text-pure-white/72 line-clamp-2">
            {description}
          </p>
        </div>
        <div className="mt-4 flex items-center justify-between gap-3">
          {hasQuantity ? (
            <div className="rounded-[14px] bg-pure-white shadow-[0_12px_34px_rgba(0,0,0,0.18)]" onClick={(event) => event.stopPropagation()}>
              <GreenStepper
                count={quantityLabel || ""}
                onIncrement={onIncrement}
                onDecrement={onDecrement}
              />
            </div>
          ) : (
            <button
              type="button"
              onClick={(event) => {
                event.stopPropagation();
                onAdd?.();
              }}
              className="inline-flex h-12 items-center gap-2 rounded-full bg-pure-white px-4 text-[13px] font-semibold text-[#102015] shadow-[0_12px_34px_rgba(0,0,0,0.18)] active:scale-95 transition-transform"
            >
              <Plus size={16} strokeWidth={2.5} />
              {actionLabel}
            </button>
          )}
        </div>
      </div>
    </div>
  );
};
