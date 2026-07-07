import { ChevronLeft } from 'lucide-react';
import { CUSTOMER_ORDERING_TEXT } from '../constants/customer_ordering.constants';
import { CustomerOrderingContext } from '../types/customer_ordering.types';

interface CustomerOrderHeaderProps {
  context: CustomerOrderingContext | null;
}

export const CustomerOrderHeader = ({ context }: CustomerOrderHeaderProps) => {
  const label = context?.tableId
    ? `${CUSTOMER_ORDERING_TEXT.TABLE_FALLBACK} ${context.tableId}`
    : CUSTOMER_ORDERING_TEXT.DELIVERY_FALLBACK;

  return (
    <div className="pt-10 px-4 pb-4 bg-pure-white flex flex-col gap-3">
      <div className="flex items-center gap-4">
        <button
          type="button"
          onClick={() => window.history.back()}
          className="w-10 h-10 rounded-full bg-pure-white shadow-[0_2px_10px_rgba(0,0,0,0.05)] border border-border-grey flex items-center justify-center active:scale-95 transition-transform"
        >
          <ChevronLeft size={22} strokeWidth={2.5} className="text-text-primary" />
        </button>
        <div className="min-w-0">
          <h1 className="text-[20px] font-black text-text-primary tracking-normal">
            {CUSTOMER_ORDERING_TEXT.APP_TITLE}
          </h1>
          <p className="text-[12px] font-bold text-text-secondary truncate">
            {label}
          </p>
        </div>
      </div>
    </div>
  );
};
