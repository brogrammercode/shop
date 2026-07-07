import { BadgePercent, Clock } from 'lucide-react';
import { CUSTOMER_ORDERING_TEXT } from '../constants/customer_ordering.constants';

interface CustomerOffersPanelProps {
  isLoggedIn: boolean;
}

export const CustomerOffersPanel = ({ isLoggedIn }: CustomerOffersPanelProps) => {
  return (
    <section className="px-4 py-4 bg-pure-white">
      <h2 className="text-[12px] font-extrabold text-text-tertiary uppercase tracking-[0.8px] mb-3">
        {CUSTOMER_ORDERING_TEXT.OFFERS_TITLE}
      </h2>
      <div className="grid grid-cols-1 gap-3">
        <div className="rounded-xl border border-border-grey bg-pure-white px-4 py-3 flex gap-3">
          <div className="w-9 h-9 rounded-full bg-[#E8F5E9] flex items-center justify-center shrink-0">
            <BadgePercent size={18} className="text-primary-green" />
          </div>
          <div className="min-w-0">
            <p className="text-[13px] font-black text-text-primary">
              {CUSTOMER_ORDERING_TEXT.OFFER_ONE_TITLE}
            </p>
            <p className="text-[11px] font-semibold text-text-secondary leading-relaxed">
              {isLoggedIn ? CUSTOMER_ORDERING_TEXT.OFFER_TWO_BODY : CUSTOMER_ORDERING_TEXT.OFFER_ONE_BODY}
            </p>
          </div>
        </div>
        <div className="rounded-xl border border-border-grey bg-pure-white px-4 py-3 flex gap-3">
          <div className="w-9 h-9 rounded-full bg-soft-grey flex items-center justify-center shrink-0">
            <Clock size={18} className="text-text-secondary" />
          </div>
          <div className="min-w-0">
            <p className="text-[13px] font-black text-text-primary">
              {CUSTOMER_ORDERING_TEXT.PREVIOUS_ORDERS}
            </p>
            <p className="text-[11px] font-semibold text-text-secondary leading-relaxed">
              {CUSTOMER_ORDERING_TEXT.PREVIOUS_ORDERS_BODY}
            </p>
          </div>
        </div>
      </div>
    </section>
  );
};
