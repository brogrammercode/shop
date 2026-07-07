import { MoreHorizontal, ReceiptText, Rows3 } from 'lucide-react';
import { CUSTOMER_ORDERING_TEXT } from '../constants/customer_ordering.constants';
import { formatAmount } from '../utils/customer_ordering.utils';

interface CustomerBottomBarProps {
  totalItems: number;
  payable: number;
  onOpenCart: () => void;
}

export const CustomerBottomBar = ({ totalItems, payable, onOpenCart }: CustomerBottomBarProps) => {
  return (
    <div className="fixed bottom-0 left-0 right-0 z-50 pointer-events-none pb-8 px-4">
      <div className="mx-auto max-w-md pointer-events-auto shadow-deep rounded-full bg-pure-white p-2">
        <div className="flex items-center justify-between w-full">
          <button
            type="button"
            onClick={onOpenCart}
            className={`flex-1 flex items-center justify-center gap-2 px-4 py-3 rounded-full transition-transform active:scale-95 ${
              totalItems > 0 ? 'bg-primary-green text-pure-white shadow-standard' : 'bg-[#E8F5E9] text-primary-green'
            }`}
          >
            <ReceiptText size={18} />
            <span className="text-[12px] font-black">
              {totalItems > 0 ? `${CUSTOMER_ORDERING_TEXT.VIEW_CART} ${formatAmount(payable)}` : CUSTOMER_ORDERING_TEXT.BILLING}
            </span>
          </button>
          <button type="button" className="flex-1 flex items-center justify-center gap-2 px-4 py-3 transition-transform active:scale-95">
            <Rows3 size={18} className="text-text-secondary" />
            <span className="text-text-secondary text-[12px] font-bold">
              {CUSTOMER_ORDERING_TEXT.ORDERS}
            </span>
          </button>
          <button type="button" className="flex-1 flex items-center justify-center gap-2 px-4 py-3 transition-transform active:scale-95">
            <MoreHorizontal size={18} className="text-text-secondary" />
            <span className="text-text-secondary text-[12px] font-bold">
              {CUSTOMER_ORDERING_TEXT.MORE}
            </span>
          </button>
        </div>
      </div>
    </div>
  );
};
