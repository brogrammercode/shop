import { MapPin, Truck } from 'lucide-react';
import {
  CUSTOMER_ORDER_TYPES,
  CUSTOMER_ORDERING_TEXT,
} from '../constants/customer_ordering.constants';
import { CustomerAddress, CustomerOrderingContext, CustomerTable } from '../types/customer_ordering.types';
import { seatOptionsForContext } from '../utils/customer_ordering.utils';

interface CustomerContextPanelProps {
  context: CustomerOrderingContext;
  selectedSeatIds: string[];
  selectedAddressId: string;
  addresses: CustomerAddress[];
  tables: CustomerTable[];
  onToggleSeat: (seatId: string) => void;
  onSelectAddress: (addressId: string) => void;
}

export const CustomerContextPanel = ({
  context,
  selectedSeatIds,
  selectedAddressId,
  addresses,
  tables,
  onToggleSeat,
  onSelectAddress,
}: CustomerContextPanelProps) => {
  const isDelivery = context.orderType === CUSTOMER_ORDER_TYPES.DELIVERY;
  const seats = seatOptionsForContext(context, tables);

  return (
    <section className="px-4 py-4 bg-pure-white">
      <div className="flex items-center gap-2 mb-3">
        {isDelivery ? (
          <Truck size={18} className="text-primary-green" />
        ) : (
          <MapPin size={18} className="text-primary-green" />
        )}
        <h2 className="text-[14px] font-black text-text-primary">
          {isDelivery ? CUSTOMER_ORDERING_TEXT.DELIVERY_CONTEXT : CUSTOMER_ORDERING_TEXT.TABLE_CONTEXT}
        </h2>
      </div>

      {isDelivery ? (
        <div className="flex flex-col gap-2">
          <p className="text-[12px] font-extrabold text-text-tertiary uppercase tracking-[0.8px]">
            {CUSTOMER_ORDERING_TEXT.SELECT_ADDRESS}
          </p>
          <div className="flex gap-2 overflow-x-auto pb-1">
            {addresses.map((address) => {
              const active = selectedAddressId === address.id;
              return (
                <button
                  key={address.id}
                  type="button"
                  onClick={() => onSelectAddress(address.id)}
                  className={`min-w-[220px] text-left rounded-xl border px-3 py-3 ${
                    active ? 'border-primary-green bg-[#E8F5E9]' : 'border-border-grey bg-pure-white'
                  }`}
                >
                  <p className="text-[13px] font-black text-text-primary truncate">
                    {address.address_line_1}
                  </p>
                  <p className="text-[11px] font-semibold text-text-secondary truncate">
                    {[address.city, address.state, address.postal_code].filter(Boolean).join(', ')}
                  </p>
                </button>
              );
            })}
          </div>
        </div>
      ) : (
        <div className="flex flex-col gap-2">
          <p className="text-[12px] font-extrabold text-text-tertiary uppercase tracking-[0.8px]">
            {CUSTOMER_ORDERING_TEXT.SELECT_SEATS}
          </p>
          <div className="flex gap-2 overflow-x-auto pb-1">
            {seats.map((seat) => {
              const active = selectedSeatIds.includes(seat.id);
              return (
                <button
                  key={seat.id}
                  type="button"
                  onClick={() => onToggleSeat(seat.id)}
                  className={`shrink-0 rounded-full border px-4 py-2 text-[12px] font-black ${
                    active ? 'border-primary-green bg-[#E8F5E9] text-primary-green' : 'border-border-grey bg-pure-white text-text-secondary'
                  }`}
                >
                  {seat.label}
                </button>
              );
            })}
          </div>
        </div>
      )}
    </section>
  );
};
