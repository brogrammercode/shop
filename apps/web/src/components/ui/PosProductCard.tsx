import React from "react";
import { GreenStepper } from "./GreenStepper";

interface PosProductCardProps {
  title: string;
  price: number;
  imageUrl?: string;
  quantity?: number;
  onAdd?: () => void;
  onIncrement?: () => void;
  onDecrement?: () => void;
}

export const PosProductCard = ({ 
  title, 
  price, 
  imageUrl, 
  quantity = 0,
  onAdd,
  onIncrement,
  onDecrement
}: PosProductCardProps) => {
  return (
    <div className="flex flex-col gap-2 w-full text-left relative">
      <button 
        onClick={quantity === 0 ? onAdd : undefined} 
        className={`w-full aspect-square bg-soft-grey rounded-[14px] overflow-hidden relative transition-transform ${quantity === 0 ? 'active:scale-[0.98]' : ''}`}
      >
        {imageUrl ? (
          <img src={imageUrl} alt={title} className="w-full h-full object-cover" />
        ) : (
          <div className="absolute inset-0 flex items-center justify-center text-text-tertiary">
            <svg className="w-10 h-10" fill="currentColor" viewBox="0 0 24 24"><path d="M21 19V5c0-1.1-.9-2-2-2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2zM8.5 13.5l2.5 3.01L14.5 12l4.5 6H5l3.5-4.5z"/></svg>
          </div>
        )}
        
        {quantity > 0 && (
          <div className="absolute inset-0 bg-black/30 flex items-center justify-center rounded-[14px]">
            <div className="bg-pure-white rounded-lg shadow-standard p-1 scale-90 origin-center" onClick={(e) => e.stopPropagation()}>
              <GreenStepper 
                count={quantity}
                onIncrement={onIncrement}
                onDecrement={onDecrement}
              />
            </div>
          </div>
        )}
      </button>

      <div className="flex flex-col px-0.5 mt-[2px]">
        <h3 className="text-[12px] font-bold text-[#1C1C1C] leading-[1.2] line-clamp-2">
          {title}
        </h3>
        <span className="text-[12px] font-bold text-[#0F8244] mt-[4px]">
          ₹ {price}
        </span>
      </div>
    </div>
  );
};
