import { useState, useRef, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { LogOut, Settings, UserCircle2, ShoppingBag } from 'lucide-react';
import { SamosaIcon } from '@/components/ui/SamosaIcon';
import { useUserStore } from '@/core/store/user.store';
import { CUSTOMER_ORDERING_DEFAULTS, CUSTOMER_ORDERING_ROUTES } from '../constants/customer_ordering.constants';
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
    <div className="sticky top-0 z-50 flex h-16 items-center justify-between border-b border-pure-white/10 bg-[#111A14]/82 px-4 shadow-[0_10px_30px_rgba(0,0,0,0.12)] backdrop-blur-2xl md:px-10">
      <div className="h-12 w-44 overflow-visible flex items-center">
        <img 
          src="/logo_transparent.png" 
          alt="Logo" 
          className="h-[78px] object-contain scale-125 origin-left" 
        />
      </div>

      <div className="relative" ref={dropdownRef}>
        {!token ? (
          <button
            onClick={() => router.push(`${CUSTOMER_ORDERING_ROUTES.LOGIN}?next=${encodeURIComponent(window.location.pathname + window.location.search)}`)}
            className="px-5 py-2 bg-[#D8FF1F] text-[#111A14] text-[14px] font-semibold rounded-full shadow-sm active:scale-95 transition-transform"
          >
            Login
          </button>
        ) : (
          <div className="flex items-center gap-2">
            <div className="h-10 px-2.5 rounded-full bg-pure-white/10 border border-pure-white/15 flex items-center gap-2 backdrop-blur-xl">
              <LadyluckMascot />
              <span className="flex min-w-[64px] flex-col gap-0.5">
                <span className="text-[11px] font-semibold leading-none text-pure-white whitespace-nowrap">
                  {points}/{CUSTOMER_ORDERING_DEFAULTS.LADYLUCK_POINTS_PER_CARD}
                </span>
                <span className="h-1 overflow-hidden rounded-full bg-pure-white/18">
                  <span className="block h-full rounded-full bg-[#D8FF1F]" style={{ width: `${progress}%` }} />
                </span>
              </span>
            </div>
            <button
              onClick={() => setIsDropdownOpen(!isDropdownOpen)}
              className="w-10 h-10 rounded-full bg-pure-white/10 border border-pure-white/15 flex items-center justify-center hover:bg-pure-white/18 transition-colors shadow-sm backdrop-blur-xl"
            >
              <UserCircle2 size={22} className="text-pure-white" />
            </button>

            {isDropdownOpen && (
              <div className="fixed right-4 top-[72px] z-[120] w-56 max-w-[calc(100vw-2rem)] overflow-hidden rounded-2xl border border-border-grey bg-pure-white shadow-[0_24px_70px_rgba(0,0,0,0.24)] md:right-10">
                <div className="px-4 py-3 border-b border-border-grey bg-[#F8F2E6]">
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
  <span className="flex h-7 w-7 shrink-0 items-center justify-center rounded-full bg-[#D8FF1F] shadow-sm">
    <SamosaIcon size={20} />
  </span>
);
