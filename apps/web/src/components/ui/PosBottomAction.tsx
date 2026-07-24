import React from "react";
import { _MENU_CONSTANTS } from "../../constants/menu.constant";
import { formatInr } from "@/core/format";

interface PosBottomActionProps {
  totalItems: number;
  totalPrice: number;
  onPlaceOrder: () => void;
  isOrdering: boolean;
}

export const PosBottomAction = ({ totalItems, totalPrice, onPlaceOrder, isOrdering }: PosBottomActionProps) => {
  return (
    <div className="pointer-events-none fixed bottom-[var(--root-nav-clearance)] left-0 right-0 z-40 px-6">
      <div className="mx-auto max-w-md pointer-events-auto shadow-deep rounded-full bg-pure-white p-2">
        <div className="flex items-center justify-between w-full">
          <button 
            onClick={totalItems > 0 ? onPlaceOrder : undefined}
            disabled={isOrdering}
            className={`flex-1 flex items-center justify-center gap-2 px-4 py-3 rounded-full transition-transform 
              ${totalItems > 0 ? 'bg-primary-green text-pure-white active:scale-95 shadow-md' : 'bg-[#E8F5E9] text-primary-green'}
              ${isOrdering ? 'opacity-70' : ''}
            `}
          >
            {isOrdering ? (
              <div className="w-5 h-5 border-2 border-pure-white border-t-transparent rounded-full animate-spin" />
            ) : totalItems > 0 ? (
              <>
                <span className="text-[14px] font-medium">
                  {_MENU_CONSTANTS._L_A_B_E_L_S.PLACE_ORDER} ({formatInr(totalPrice)})
                </span>
              </>
            ) : (
              <>
                <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                </svg>
                <span className="text-[14px] font-medium">Billing</span>
              </>
            )}
          </button>

          <button className="flex-1 flex items-center justify-center gap-2 px-4 py-3 transition-transform active:scale-95">
            <svg className="w-5 h-5 text-text-secondary" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M4 6h16M4 10h16M4 14h16M4 18h16" />
            </svg>
            <span className="text-text-secondary text-[14px] font-medium">Orders</span>
          </button>

          <button className="flex-1 flex items-center justify-center gap-2 px-4 py-3 transition-transform active:scale-95">
            <svg className="w-5 h-5 text-text-secondary" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M5 12h.01M12 12h.01M19 12h.01M6 12a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0z" />
            </svg>
            <span className="text-text-secondary text-[14px] font-medium">More</span>
          </button>

        </div>
      </div>
    </div>
  );
};
