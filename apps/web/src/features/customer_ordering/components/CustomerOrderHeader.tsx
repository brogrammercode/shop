import { useState, useRef, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { LogOut, Settings, UserCircle2, ShoppingBag } from 'lucide-react';
import { useUserStore } from '@/core/store/user.store';
import { CUSTOMER_ORDERING_DEFAULTS, CUSTOMER_ORDERING_ROUTES, CUSTOMER_ORDERING_TEXT } from '../constants/customer_ordering.constants';
import { CustomerOrderingApi } from '../services/customer_ordering.api';
import { CustomerOrderingContext } from '../types/customer_ordering.types';

interface CustomerOrderHeaderProps {
  context: CustomerOrderingContext | null;
}

export const CustomerOrderHeader = ({ context }: CustomerOrderHeaderProps) => {
  const router = useRouter();
  const { user, token, clearContext } = useUserStore();
  const [isDropdownOpen, setIsDropdownOpen] = useState(false);
  const [ladyluckPoints, setLadyluckPoints] = useState<number | null>(null);
  const dropdownRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsDropdownOpen(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  useEffect(() => {
    if (!token || !context?.branchId) {
      return;
    }

    const loadLadyluck = async () => {
      try {
        const summary = await CustomerOrderingApi.getLadyluckSummary(context.branchId);
        setLadyluckPoints(summary.account.points_balance || 0);
      } catch {
        setLadyluckPoints(null);
      }
    };

    loadLadyluck();
  }, [context?.branchId, token]);

  const handleLogout = () => {
    clearContext();
    setIsDropdownOpen(false);
  };
  const points = ladyluckPoints ?? 0;
  const progress = Math.min(100, points / CUSTOMER_ORDERING_DEFAULTS.LADYLUCK_POINTS_PER_CARD * 100);

  return (
    <div className="px-4 py-2 bg-pure-white flex items-center justify-between shadow-sm sticky top-0 z-50">
      <div className="h-10 w-40 overflow-visible flex items-center">
        <img 
          src="/logo_transparent.png" 
          alt="Logo" 
          className="h-16 object-contain scale-125 origin-left" 
        />
      </div>

      <div className="relative" ref={dropdownRef}>
        {!token ? (
          <button
            onClick={() => router.push(`${CUSTOMER_ORDERING_ROUTES.LOGIN}?next=${encodeURIComponent(window.location.pathname + window.location.search)}`)}
            className="px-5 py-2 bg-primary-green text-pure-white text-[14px] font-semibold rounded-full shadow-sm active:scale-95 transition-transform"
          >
            Login
          </button>
        ) : (
          <div className="flex items-center gap-2">
            <div className="h-9 px-2.5 rounded-full bg-[#FFFBEB] border border-[#FEF3C7] flex items-center gap-2">
              <LadyluckMascot />
              <span className="flex min-w-[64px] flex-col gap-0.5">
                <span className="text-[11px] font-semibold leading-none text-[#92400E] whitespace-nowrap">
                  {points}/{CUSTOMER_ORDERING_DEFAULTS.LADYLUCK_POINTS_PER_CARD}
                </span>
                <span className="h-1 overflow-hidden rounded-full bg-[#FEF3C7]">
                  <span className="block h-full rounded-full bg-primary-green" style={{ width: `${progress}%` }} />
                </span>
              </span>
            </div>
            <button
              onClick={() => setIsDropdownOpen(!isDropdownOpen)}
              className="w-9 h-9 rounded-full bg-soft-grey border border-border-grey flex items-center justify-center hover:bg-border-grey transition-colors shadow-sm"
            >
              <UserCircle2 size={22} className="text-text-secondary" />
            </button>

            {isDropdownOpen && (
              <div className="absolute right-0 mt-2 w-48 bg-pure-white rounded-xl shadow-elevated border border-border-grey overflow-hidden z-50">
                <div className="px-4 py-3 border-b border-border-grey bg-soft-grey/50">
                  <p className="text-[13px] font-semibold text-text-primary truncate">{user?.name || 'User'}</p>
                  <p className="text-[11px] font-medium text-text-secondary truncate">+91 {user?.phone}</p>
                </div>
                <div className="p-1">
                  <button 
                    onClick={() => {
                      setIsDropdownOpen(false);
                      router.push('/profile');
                    }}
                    className="w-full flex items-center gap-3 px-3 py-2 text-[13px] font-medium text-text-primary hover:bg-soft-grey rounded-lg transition-colors text-left"
                  >
                    <Settings size={16} className="text-text-secondary" />
                    Edit Profile
                  </button>
                  <button 
                    onClick={() => {
                      setIsDropdownOpen(false);
                      router.push('/orders');
                    }}
                    className="w-full flex items-center gap-3 px-3 py-2 text-[13px] font-medium text-text-primary hover:bg-soft-grey rounded-lg transition-colors text-left"
                  >
                    <ShoppingBag size={16} className="text-text-secondary" />
                    Your Orders
                  </button>
                  <button 
                    onClick={handleLogout}
                    className="w-full flex items-center gap-3 px-3 py-2 text-[13px] font-medium text-[#EF4F5F] hover:bg-[#FFF5F5] rounded-lg transition-colors text-left"
                  >
                    <LogOut size={16} className="text-[#EF4F5F]" />
                    Log Out
                  </button>
                </div>
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
};

const LadyluckMascot = () => (
  <span
    role="img"
    aria-label={CUSTOMER_ORDERING_TEXT.LADYLUCK_MASCOT}
    className="block h-6 w-6 shrink-0 rounded-full bg-[#1C1C1C] shadow-sm"
    style={{
      backgroundImage: "url('/logo_transparent.png')",
      backgroundSize: "92px 92px",
      backgroundPosition: "-18px -36px",
      backgroundRepeat: "no-repeat",
    }}
  >
    <span className="sr-only">
      {CUSTOMER_ORDERING_TEXT.LADYLUCK_MASCOT}
    </span>
  </span>
);
