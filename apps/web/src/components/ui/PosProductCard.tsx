import React from "react";
import { GreenStepper } from "./GreenStepper";
import { Heart } from "lucide-react";

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
      className={`relative min-h-[178px] overflow-hidden rounded-[24px] bg-[#E6FCF4] shadow-sm border border-[#D7F3EA] text-left ${!hasQuantity ? "cursor-pointer active:scale-[0.99]" : ""} transition-transform`}
    >
      {imageUrl ? (
        <img src={imageUrl} alt={title} className="absolute inset-0 h-full w-full object-cover object-center" />
      ) : (
        <div className="absolute inset-0 h-full w-full bg-[#D9F3EA]" />
      )}
      <div className="absolute inset-y-0 left-0 w-[52%] bg-[#E6FCF4]/86 backdrop-blur-[10px]" />
      <div className="absolute inset-y-0 left-[40%] w-20 bg-gradient-to-r from-[#E6FCF4]/86 to-transparent backdrop-blur-[2px]" />
      <div className="absolute inset-0 bg-gradient-to-t from-black/8 via-transparent to-pure-white/5" />
      <button
        type="button"
        aria-label={favoriteLabel}
        className="absolute right-3 top-3 z-10 flex h-11 w-11 items-center justify-center rounded-full bg-pure-white/95 text-text-primary shadow-sm"
        onClick={(event) => event.stopPropagation()}
      >
        <Heart size={20} strokeWidth={2.2} />
      </button>
      <div className="relative z-10 flex min-h-[178px] w-[50%] flex-col justify-between px-4 py-4">
        <div>
          <h3 className="text-[20px] font-medium leading-[1.1] text-text-primary line-clamp-3">
            {title}
          </h3>
          <p className="mt-3 text-[11px] font-medium leading-[1.2] text-text-primary/80 line-clamp-2">
            {description}
          </p>
        </div>
        <div>
          <p className="text-[27px] font-semibold leading-none text-text-primary">
            {priceLabel}
          </p>
          {hasQuantity ? (
            <div className="mt-3 inline-flex rounded-[10px] bg-pure-white shadow-sm" onClick={(event) => event.stopPropagation()}>
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
              className="mt-3 h-10 rounded-full bg-[#D8FF1F] px-5 text-[13px] font-semibold text-text-primary shadow-sm active:scale-95 transition-transform"
            >
              {actionLabel}
            </button>
          )}
        </div>
      </div>
    </div>
  );
};
