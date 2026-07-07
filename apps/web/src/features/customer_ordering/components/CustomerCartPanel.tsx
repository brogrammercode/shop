import { X } from 'lucide-react';
import { CUSTOMER_ORDERING_TEXT } from '../constants/customer_ordering.constants';
import { CustomerCartItem } from '../types/customer_ordering.types';
import { calculateSubtotal, calculateTax, formatAmount } from '../utils/customer_ordering.utils';

interface CustomerCartPanelProps {
  isOpen: boolean;
  items: CustomerCartItem[];
  isSubmitting: boolean;
  actionLabel: string;
  error: string;
  onClose: () => void;
  onSubmit: () => void;
  onIncrement: (itemId: string) => void;
  onDecrement: (itemId: string) => void;
}

export const CustomerCartPanel = ({
  isOpen,
  items,
  isSubmitting,
  actionLabel,
  error,
  onClose,
  onSubmit,
  onIncrement,
  onDecrement,
}: CustomerCartPanelProps) => {
  if (!isOpen) {
    return null;
  }

  const subtotal = calculateSubtotal(items);
  const tax = calculateTax(subtotal);
  const payable = subtotal + tax;

  return (
    <div className="fixed inset-0 z-[60] bg-black/30 flex items-end">
      <div className="w-full max-h-[82vh] overflow-y-auto bg-pure-white rounded-t-[24px] px-4 pt-4 pb-7 shadow-deep">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-[18px] font-black text-text-primary">
            {CUSTOMER_ORDERING_TEXT.BILLING}
          </h2>
          <button
            type="button"
            onClick={onClose}
            className="w-9 h-9 rounded-full bg-deep-onyx flex items-center justify-center"
          >
            <X size={18} className="text-pure-white" />
          </button>
        </div>

        <div className="flex flex-col gap-3">
          {items.map((cartItem) => (
            <div key={cartItem.item.id} className="border-b border-border-grey pb-3">
              <div className="flex items-start justify-between gap-3">
                <div className="min-w-0">
                  <p className="text-[14px] font-black text-text-primary leading-tight">
                    {cartItem.item.display_name}
                  </p>
                  <p className="text-[12px] font-bold text-text-secondary mt-1">
                    {formatAmount(cartItem.item.selling_price)}
                  </p>
                </div>
                <p className="text-[13px] font-black text-text-primary">
                  {formatAmount(cartItem.item.selling_price * cartItem.quantity)}
                </p>
              </div>
              <div className="mt-3 inline-flex items-center gap-3 px-2 py-1 border border-primary-green rounded-lg bg-[#E8F5E9]">
                <button type="button" onClick={() => onDecrement(cartItem.item.id)} className="text-primary-green font-black px-2">
                  -
                </button>
                <span className="text-[13px] font-black text-primary-green min-w-4 text-center">
                  {cartItem.quantity}
                </span>
                <button type="button" onClick={() => onIncrement(cartItem.item.id)} className="text-primary-green font-black px-2">
                  +
                </button>
              </div>
            </div>
          ))}
        </div>

        <div className="mt-5 rounded-xl border border-border-grey p-4 flex flex-col gap-2">
          <BillRow label={CUSTOMER_ORDERING_TEXT.SUBTOTAL} value={formatAmount(subtotal)} />
          <BillRow label={CUSTOMER_ORDERING_TEXT.TAX} value={formatAmount(tax)} />
          <div className="h-px bg-border-grey my-1" />
          <BillRow label={CUSTOMER_ORDERING_TEXT.PAYABLE} value={formatAmount(payable)} strong />
        </div>

        {error ? (
          <p className="text-[12px] font-bold text-[#EF4F5F] mt-3">
            {error}
          </p>
        ) : null}

        <button
          type="button"
          onClick={onSubmit}
          disabled={isSubmitting || items.length === 0}
          className="mt-4 w-full h-12 rounded-[10px] bg-primary-green text-pure-white text-[15px] font-black disabled:opacity-60 flex items-center justify-center"
        >
          {isSubmitting ? <span className="w-5 h-5 rounded-full border-2 border-pure-white border-t-transparent animate-spin" /> : actionLabel}
        </button>
      </div>
    </div>
  );
};

const BillRow = ({ label, value, strong = false }: { label: string; value: string; strong?: boolean }) => {
  return (
    <div className="flex items-center justify-between">
      <span className={`text-[13px] ${strong ? 'font-black text-text-primary' : 'font-bold text-text-secondary'}`}>
        {label}
      </span>
      <span className={`text-[13px] ${strong ? 'font-black text-text-primary' : 'font-bold text-text-primary'}`}>
        {value}
      </span>
    </div>
  );
};
