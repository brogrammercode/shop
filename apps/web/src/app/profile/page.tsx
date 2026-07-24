"use client";

import React, { Suspense, useEffect, useState } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { ChevronLeft, Plus, Edit2, Trash2, MapPin } from 'lucide-react';
import { useUserStore } from '@/core/store/user.store';
import { AuthRepo } from '@/features/auth/repo/auth.repo';

export default function ProfilePage() {
  return (
    <Suspense fallback={<ProfileLoader />}>
      <ProfileContent />
    </Suspense>
  );
}

function ProfileContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const { user, token, hasHydrated, requiresPhone, setAuth, addresses, setAddresses } = useUserStore();
  const requestedTab = searchParams.get('tab');
  const shouldOpenAddressForm = searchParams.get('addAddress') === '1';
  const requestedNextPath = searchParams.get('next') || '';
  const nextPath = requestedNextPath.startsWith('/') ? requestedNextPath : '';
  const phoneRequiresCompletion =
    requiresPhone ||
    Boolean(user && (
      !user.phone ||
      user.phone.startsWith('no-phone-') ||
      user.phone.startsWith('merged_')
    ));
  
  const [activeTab, setActiveTab] = useState<'PERSONAL' | 'ADDRESSES' | 'BANK'>(
    requestedTab === 'addresses' ? 'ADDRESSES' : 'PERSONAL',
  );
  const [isSaving, setIsSaving] = useState(false);
  const [isAddingAddress, setIsAddingAddress] = useState(false);
  const [isLoadingProfile, setIsLoadingProfile] = useState(false);
  const [showAddressForm, setShowAddressForm] = useState(shouldOpenAddressForm);
  const [isLocating, setIsLocating] = useState(false);
  const [addressError, setAddressError] = useState('');
  const [addressSuccess, setAddressSuccess] = useState('');

  const [draftName, setDraftName] = useState<string | null>(null);
  const [draftEmail, setDraftEmail] = useState<string | null>(null);
  
  const [addrArea, setAddrArea] = useState('');
  const [addrLocality, setAddrLocality] = useState('');
  const [addrCity, setAddrCity] = useState('');
  const [addrState, setAddrState] = useState('');
  const [addrPincode, setAddrPincode] = useState('');

  useEffect(() => {
    if (!hasHydrated) {
      return;
    }
    if (!token) {
      router.replace(`/login?next=${encodeURIComponent('/profile' + window.location.search)}`);
      return;
    }
    if (phoneRequiresCompletion) {
      router.replace(`/complete-phone?next=${encodeURIComponent('/profile' + window.location.search)}`);
      return;
    }

    let active = true;
    const loadProfile = async () => {
      setIsLoadingProfile(true);
      try {
        await AuthRepo.loadCurrentUser();
      } catch {
        return;
      } finally {
        if (active) {
          setIsLoadingProfile(false);
        }
      }
    };

    loadProfile();
    return () => {
      active = false;
    };
  }, [hasHydrated, phoneRequiresCompletion, router, token]);

  if (!hasHydrated || isLoadingProfile) {
    return <ProfileLoader />;
  }

  if (!token || phoneRequiresCompletion) {
    return null;
  }

  const handleSavePersonal = () => {
    setIsSaving(true);
    setTimeout(() => {
      if (user) {
        setAuth(token, { ...user, name: nameValue, email: emailValue });
      }
      setIsSaving(false);
      alert('Profile updated successfully');
    }, 600);
  };

  const handleUseCurrentLocation = () => {
    if (!navigator.geolocation) {
      setAddressError("Geolocation is not supported by your browser");
      return;
    }
    
    setAddressError('');
    setIsLocating(true);
    navigator.geolocation.getCurrentPosition(async (position) => {
      const { latitude, longitude } = position.coords;
      try {
        const res = await fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${latitude}&lon=${longitude}`);
        const data = await res.json();
        if (data && data.address) {
          setAddrArea(data.address.road || data.address.suburb || data.display_name || '');
          setAddrLocality(data.address.neighbourhood || data.address.residential || '');
          setAddrCity(data.address.city || data.address.town || data.address.county || '');
          setAddrState(data.address.state || '');
          setAddrPincode(data.address.postcode || '');
        } else {
          setAddrArea(`${latitude}, ${longitude}`);
        }
      } catch (err) {
        console.error(err);
        setAddrArea(`Lat: ${latitude}, Lon: ${longitude}`);
      } finally {
        setIsLocating(false);
      }
    }, (error) => {
      setAddressError(`Error getting location: ${error.message}`);
      setIsLocating(false);
    });
  };

  const submitAddress = async () => {
    if (!addrArea.trim()) {
      setAddressError("Please enter your area, street, or flat number.");
      return;
    }
    if (!addrCity.trim() || !addrState.trim() || !addrPincode.trim()) {
      setAddressError("Please complete city, state, and pincode.");
      return;
    }
    setIsAddingAddress(true);
    setAddressError('');
    setAddressSuccess('');
    try {
      const payload = {
        area: addrArea.trim(),
        locality: addrLocality.trim() || undefined,
        city: addrCity.trim(),
        state: addrState.trim(),
        pin_code: addrPincode.trim(),
      };
      
      const newAddress = await AuthRepo.createAddress(payload);
      
      setAddresses([...addresses, newAddress]);
      setShowAddressForm(false);
      setAddrArea('');
      setAddrLocality('');
      setAddrCity('');
      setAddrState('');
      setAddrPincode('');
      setAddressSuccess("Address saved successfully.");
      AuthRepo.loadCurrentUser().catch(() => undefined);
      if (nextPath) {
        router.replace(nextPath);
      }
    } catch (error: unknown) {
      const message = error && typeof error === "object" && "response" in error
        ? (error as { response?: { data?: { message?: string } } }).response?.data?.message
        : undefined;
      setAddressError(message || "Failed to add address. Please try again.");
    } finally {
      setIsAddingAddress(false);
    }
  };

  const handleDeleteAddress = (id: string) => {
    setAddresses(addresses.filter(a => a.id !== id));
  };

  const nameValue = draftName ?? user?.name ?? '';
  const emailValue = draftEmail ?? user?.email ?? '';

  return (
    <div className="min-h-screen w-full overflow-x-hidden bg-[#FAFAFA] pb-32">
      <div className="sticky top-0 z-50 flex w-full items-center bg-pure-white px-4 py-3 shadow-sm">
        <button type="button" onClick={() => router.back()} className="p-2 -ml-2 rounded-full active:scale-95 transition-transform">
          <ChevronLeft size={24} className="text-text-primary" />
        </button>
        <h1 className="text-[18px] font-semibold text-text-primary ml-2">Edit Profile</h1>
      </div>

      <div className="no-scrollbar flex w-full overflow-x-auto border-b border-border-grey bg-pure-white px-4 pt-2 shadow-sm">
        <TabButton active={activeTab === 'PERSONAL'} onClick={() => setActiveTab('PERSONAL')}>Personal Details</TabButton>
        <TabButton active={activeTab === 'ADDRESSES'} onClick={() => setActiveTab('ADDRESSES')}>Addresses</TabButton>
        <TabButton active={activeTab === 'BANK'} onClick={() => setActiveTab('BANK')}>Bank Details</TabButton>
      </div>

      <div className="w-full">
        {activeTab === 'PERSONAL' && (
          <div className="flex w-full flex-col gap-4 border-y border-border-grey bg-pure-white px-4 py-5 shadow-sm">
            <div>
              <label className="text-[12px] font-semibold text-text-secondary mb-1.5 block">Phone Number</label>
              <div className="w-full h-12 bg-soft-grey rounded-xl px-4 flex items-center text-[14px] font-medium text-text-tertiary">
                +91 {user?.phone || 'Unknown'} (Cannot be changed)
              </div>
            </div>
            <div>
              <label className="text-[12px] font-semibold text-text-secondary mb-1.5 block">Full Name</label>
              <input 
                type="text"
                value={nameValue}
                onChange={(e) => setDraftName(e.target.value)}
                placeholder="Enter your full name"
                className="w-full h-12 border border-border-grey rounded-xl px-4 text-[14px] font-medium focus:border-primary-green focus:outline-none transition-colors"
              />
            </div>
            <div>
              <label className="text-[12px] font-semibold text-text-secondary mb-1.5 block">Email Address</label>
              <input 
                type="email"
                value={emailValue}
                onChange={(e) => setDraftEmail(e.target.value)}
                placeholder="Enter your email"
                className="w-full h-12 border border-border-grey rounded-xl px-4 text-[14px] font-medium focus:border-primary-green focus:outline-none transition-colors"
              />
            </div>

            <button 
              onClick={handleSavePersonal}
              disabled={isSaving}
              className="mt-4 w-full h-12 bg-primary-green text-pure-white font-semibold rounded-[14px] shadow-standard flex items-center justify-center active:scale-95 transition-transform disabled:opacity-60"
            >
              {isSaving ? <span className="w-5 h-5 rounded-full border-2 border-pure-white border-t-transparent animate-spin" /> : 'Save Changes'}
            </button>
          </div>
        )}

        {activeTab === 'ADDRESSES' && (
          <div className="flex w-full flex-col gap-3">
            {!showAddressForm ? (
              <button 
                onClick={() => {
                  setAddressError('');
                  setAddressSuccess('');
                  setShowAddressForm(true);
                }}
                className="flex h-14 w-full items-center justify-center gap-2 border-y-2 border-dashed border-primary-green/50 bg-[#E8F5E9]/50 text-[14px] font-semibold text-primary-green transition-transform active:scale-95"
              >
                <Plus size={18} /> Add New Address
              </button>
            ) : (
              <div className="flex w-full flex-col gap-4 border-y border-border-grey bg-pure-white px-4 py-5 shadow-sm">
                <div className="flex items-center justify-between mb-2">
                  <h3 className="text-[15px] font-bold text-text-primary">Add New Address</h3>
                  <button
                    onClick={handleUseCurrentLocation}
                    disabled={isLocating}
                    className="flex items-center gap-1.5 text-[12px] font-semibold text-primary-green bg-[#E8F5E9] px-3 py-1.5 rounded-lg active:scale-95 transition-transform disabled:opacity-60"
                  >
                    {isLocating ? (
                      <span className="w-3.5 h-3.5 rounded-full border-2 border-primary-green border-t-transparent animate-spin" />
                    ) : (
                      <MapPin size={14} />
                    )}
                    Use Current Location
                  </button>
                </div>
                
                <div className="grid grid-cols-1 gap-3">
                  <input type="text" value={addrArea} onChange={e => setAddrArea(e.target.value)} placeholder="Area / Street / Flat no." className="w-full h-11 border border-border-grey rounded-xl px-4 text-[13px] font-medium focus:border-primary-green focus:outline-none" />
                  <input type="text" value={addrLocality} onChange={e => setAddrLocality(e.target.value)} placeholder="Locality / Landmark (Optional)" className="w-full h-11 border border-border-grey rounded-xl px-4 text-[13px] font-medium focus:border-primary-green focus:outline-none" />
                  <div className="grid grid-cols-2 gap-3">
                    <input type="text" value={addrCity} onChange={e => setAddrCity(e.target.value)} placeholder="City" className="w-full h-11 border border-border-grey rounded-xl px-4 text-[13px] font-medium focus:border-primary-green focus:outline-none" />
                    <input type="text" value={addrState} onChange={e => setAddrState(e.target.value)} placeholder="State" className="w-full h-11 border border-border-grey rounded-xl px-4 text-[13px] font-medium focus:border-primary-green focus:outline-none" />
                  </div>
                  <input type="text" value={addrPincode} onChange={e => setAddrPincode(e.target.value)} placeholder="Pincode" className="w-full h-11 border border-border-grey rounded-xl px-4 text-[13px] font-medium focus:border-primary-green focus:outline-none" />
                </div>

                {addressError && (
                  <p className="text-[12px] font-semibold text-[#EF4F5F]">
                    {addressError}
                  </p>
                )}

                <div className="flex gap-3 mt-2">
                  <button
                    onClick={() => {
                      setAddressError('');
                      setShowAddressForm(false);
                    }}
                    className="flex-1 h-11 border border-border-grey text-text-secondary font-semibold rounded-xl active:scale-95 transition-transform"
                  >
                    Cancel
                  </button>
                  <button onClick={submitAddress} disabled={isAddingAddress} className="flex-1 h-11 bg-primary-green text-pure-white font-semibold rounded-xl active:scale-95 transition-transform disabled:opacity-60 flex items-center justify-center">
                    {isAddingAddress ? <span className="w-4 h-4 rounded-full border-2 border-pure-white border-t-transparent animate-spin" /> : 'Save Address'}
                  </button>
                </div>
              </div>
            )}

            {addressSuccess && (
              <p className="w-full bg-[#E8F5E9] px-4 py-3 text-[13px] font-semibold text-primary-green">
                {addressSuccess}
              </p>
            )}

            {addresses.map((address) => (
              <div key={address.id} className="flex w-full flex-col gap-2 border-y border-border-grey bg-pure-white px-4 py-4 shadow-sm">
                <div className="flex items-start justify-between">
                  <div className="flex items-center gap-2">
                    <span className="px-2 py-1 bg-soft-grey text-[11px] font-semibold text-text-secondary rounded-md">HOME</span>
                    <span className="text-[14px] font-semibold text-text-primary">{user?.name || 'User'}</span>
                  </div>
                  <div className="flex gap-2">
                    <button className="p-1.5 text-text-secondary hover:text-primary-green transition-colors"><Edit2 size={14} /></button>
                    <button onClick={() => handleDeleteAddress(address.id)} className="p-1.5 text-text-secondary hover:text-[#EF4F5F] transition-colors"><Trash2 size={14} /></button>
                  </div>
                </div>
                <p className="text-[13px] font-medium text-text-secondary leading-relaxed mt-1">
                  {address.address_line_1}, {address.city}, {address.state} - {address.postal_code}
                </p>
                <p className="text-[12px] font-semibold text-text-tertiary mt-1">Phone: +91 {user?.phone}</p>
              </div>
            ))}
            
            {addresses.length === 0 && !showAddressForm && (
              <p className="text-center text-[13px] font-medium text-text-secondary py-6">No addresses added yet.</p>
            )}
          </div>
        )}

        {activeTab === 'BANK' && (
          <div className="flex w-full flex-col gap-4 border-y border-border-grey bg-pure-white px-4 py-5 shadow-sm">
            <p className="text-[13px] font-medium text-text-secondary bg-soft-grey p-3 rounded-lg mb-2">
              Add your bank details to receive refunds and withdrawals directly to your account.
            </p>
            <div>
              <label className="text-[12px] font-semibold text-text-secondary mb-1.5 block">Account Holder Name</label>
              <input type="text" placeholder="Name as per bank" className="w-full h-12 border border-border-grey rounded-xl px-4 text-[14px] font-medium focus:border-primary-green focus:outline-none transition-colors" />
            </div>
            <div>
              <label className="text-[12px] font-semibold text-text-secondary mb-1.5 block">Account Number</label>
              <input type="text" placeholder="Account Number" className="w-full h-12 border border-border-grey rounded-xl px-4 text-[14px] font-medium focus:border-primary-green focus:outline-none transition-colors" />
            </div>
            <div>
              <label className="text-[12px] font-semibold text-text-secondary mb-1.5 block">IFSC Code</label>
              <input type="text" placeholder="e.g. SBIN0001234" className="w-full h-12 border border-border-grey rounded-xl px-4 text-[14px] font-medium uppercase focus:border-primary-green focus:outline-none transition-colors" />
            </div>

            <button onClick={() => alert('Bank Details saved')} className="mt-4 w-full h-12 bg-primary-green text-pure-white font-semibold rounded-[14px] shadow-standard flex items-center justify-center active:scale-95 transition-transform">
              Save Bank Details
            </button>
          </div>
        )}
      </div>
    </div>
  );
}

const TabButton = ({ active, onClick, children }: { active: boolean, onClick: () => void, children: React.ReactNode }) => (
  <button
    onClick={onClick}
    className={`pb-3 px-4 whitespace-nowrap text-[14px] font-semibold transition-colors border-b-2 ${
      active ? 'border-primary-green text-primary-green' : 'border-transparent text-text-secondary hover:text-text-primary'
    }`}
  >
    {children}
  </button>
);

const ProfileLoader = () => (
  <div className="min-h-screen flex items-center justify-center bg-[#FAFAFA]">
    <div className="w-8 h-8 border-2 border-primary-green border-t-transparent rounded-full animate-spin" />
  </div>
);
