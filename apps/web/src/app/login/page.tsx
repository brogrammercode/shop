"use client";

import React, { Suspense, useState } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { Check, ChevronDown, MoreVertical, User } from 'lucide-react';
import { AuthRepo } from '@/features/auth/repo/auth.repo';
import { useUserStore } from '@/core/store/user.store';

export default function LoginPage() {
  return (
    <Suspense fallback={<div className="min-h-screen flex items-center justify-center bg-pure-white"><div className="w-8 h-8 border-2 border-primary-green border-t-transparent rounded-full animate-spin" /></div>}>
      <LoginContent />
    </Suspense>
  );
}

function LoginContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [phoneNumber, setPhoneNumber] = useState('');
  const [countryCode, setCountryCode] = useState('+91');
  const [otp, setOtp] = useState('');
  const [step, setStep] = useState<'PHONE' | 'OTP'>('PHONE');
  const [rememberLogin, setRememberLogin] = useState(true);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  
  const fullPhone = `${countryCode}${phoneNumber}`;
  
  const { user } = useUserStore();

  const handleProfileSelect = () => {
    router.push(searchParams.get('next') || '/');
  };

  const handleSendOtp = async () => {
    if (phoneNumber.length < 10) {
      setError('Please enter a valid phone number');
      return;
    }
    try {
      setIsLoading(true);
      setError('');
      await AuthRepo.sendOtp(fullPhone);
      setStep('OTP');
    } catch (err: unknown) {
      const message = err && typeof err === 'object' && 'response' in err
        ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
        : undefined;
      setError(message || 'Failed to send OTP');
    } finally {
      setIsLoading(false);
    }
  };

  const handleVerifyOtp = async () => {
    if (otp.length < 6) {
      setError('Please enter the 6-digit OTP');
      return;
    }
    try {
      setIsLoading(true);
      setError('');
      await AuthRepo.verifyOtp(fullPhone, otp);
      router.push(searchParams.get('next') || '/');
    } catch (err: unknown) {
      const message = err && typeof err === 'object' && 'response' in err
        ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
        : undefined;
      setError(message || 'Invalid OTP');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="flex flex-col h-screen w-full relative bg-primary-green">
      <div className="flex-1 flex flex-col justify-center px-6">
        <div className="w-20 h-20 bg-pure-white/20 backdrop-blur-sm rounded-2xl flex items-center justify-center mb-5 border border-pure-white/30">
          <span className="text-pure-white font-semibold text-2xl leading-tight">L</span>
        </div>
        <h1 className="text-pure-white text-[32px] font-semibold mb-2 tracking-wide">Ladyluck</h1>
        <p className="text-pure-white/80 text-[15px] font-normal m-0">Login to continue</p>
      </div>

      <div className="bg-pure-white rounded-t-[24px] p-8 pb-8 shadow-deep flex flex-col gap-5">
        {step === 'PHONE' ? (
          <>
            {user && (
              <>
                <div className="text-center text-sm font-semibold text-text-secondary mb-2">Choose your account</div>
                <div 
                  onClick={handleProfileSelect}
                  className="flex items-center gap-3 p-3 bg-pure-white border border-[#E8E8E8] rounded-xl cursor-pointer hover:bg-soft-grey transition-colors shadow-sm mb-4"
                >
                  <div className="w-10 h-10 rounded-full bg-soft-grey flex items-center justify-center overflow-hidden shrink-0">
                    <User size={20} className="text-text-secondary" />
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="text-[14px] font-semibold text-text-primary truncate">
                      {user.name || 'User'}
                    </p>
                    <p className="text-[12px] font-medium text-text-secondary truncate mt-0.5">
                      +91 {user.phone || ''}
                    </p>
                  </div>
                  <MoreVertical size={20} className="text-text-secondary shrink-0" />
                </div>
              </>
            )}

            <div className="text-center text-xs font-semibold text-text-tertiary mb-2">Log in or sign up</div>
            
            <div className="flex gap-3">
              <div className="relative">
                <select
                  value={countryCode}
                  onChange={(e) => setCountryCode(e.target.value)}
                  className="appearance-none h-[52px] pl-3 pr-8 border border-border-grey rounded-xl bg-pure-white text-sm font-semibold text-text-primary focus:outline-none focus:border-primary-green cursor-pointer"
                >
                  <option value="+91">🇮🇳 +91</option>
                  <option value="+1">🇺🇸 +1</option>
                  <option value="+44">🇬🇧 +44</option>
                  <option value="+61">🇦🇺 +61</option>
                  <option value="+971">🇦🇪 +971</option>
                  <option value="+65">🇸🇬 +65</option>
                  <option value="+60">🇲🇾 +60</option>
                </select>
                <ChevronDown size={14} className="absolute right-2 top-1/2 -translate-y-1/2 text-text-secondary pointer-events-none" />
              </div>
              <div className="flex-1 flex items-center h-[52px] border border-border-grey rounded-xl px-4 bg-pure-white focus-within:border-primary-green focus-within:border-[1.5px] transition-colors">
                <input 
                  type="tel" 
                  className="border-none outline-none text-base font-medium text-text-primary w-full bg-transparent placeholder:text-text-tertiary placeholder:font-normal" 
                  placeholder="Enter phone number" 
                  value={phoneNumber}
                  onChange={(e) => setPhoneNumber(e.target.value.replace(/\D/g, ''))}
                  maxLength={15}
                />
              </div>
            </div>

            {error && <div className="text-red-500 text-[13px] font-medium">{error}</div>}

            <div className="flex items-center gap-3 cursor-pointer" onClick={() => setRememberLogin(!rememberLogin)}>
              <div className={`w-5 h-5 rounded-md border flex items-center justify-center text-pure-white transition-colors ${rememberLogin ? 'bg-primary-green border-primary-green' : 'bg-transparent border-border-grey'}`}>
                {rememberLogin && <Check size={14} strokeWidth={2.5} />}
              </div>
              <span className="text-sm font-medium text-text-secondary">Remember Login</span>
            </div>

            <button 
              className="h-14 rounded-[14px] bg-primary-green text-pure-white text-base font-semibold border-none cursor-pointer flex items-center justify-center transition-opacity duration-200 w-full disabled:opacity-60 disabled:cursor-not-allowed shadow-standard" 
              onClick={handleSendOtp}
              disabled={isLoading || phoneNumber.length < 10}
            >
              {isLoading ? 'Sending...' : 'Continue'}
            </button>
          </>
        ) : (
          <div className="flex flex-col gap-4">
            <div className="text-center text-sm font-medium text-text-secondary mb-2">Enter the OTP sent to <span className="font-semibold text-text-primary">{fullPhone}</span></div>
            <input 
              type="text" 
              className="h-[52px] border border-border-grey rounded-xl px-4 text-lg font-medium text-text-primary text-center tracking-[4px] focus:border-primary-green focus:outline-none transition-colors bg-pure-white" 
              placeholder="000000"
              value={otp}
              onChange={(e) => setOtp(e.target.value.replace(/\D/g, ''))}
              maxLength={6}
            />
            
            {error && <div className="text-red-500 text-[13px] font-medium">{error}</div>}

            <button 
              className="h-14 rounded-[14px] bg-primary-green text-pure-white text-base font-semibold border-none cursor-pointer flex items-center justify-center transition-opacity duration-200 w-full disabled:opacity-60 disabled:cursor-not-allowed shadow-standard" 
              onClick={handleVerifyOtp}
              disabled={isLoading || otp.length < 6}
            >
              {isLoading ? 'Verifying...' : 'Verify & Login'}
            </button>
            <div className="text-center text-[13px] text-primary-green font-medium cursor-pointer mt-2" onClick={() => setStep('PHONE')}>
              Change Phone Number
            </div>
          </div>
        )}

        <div className="mt-8 text-center text-[11px] text-text-tertiary font-normal leading-relaxed">
          By continuing you agree to our
          <div className="flex justify-center gap-3 mt-1">
            <span className="text-text-secondary underline font-medium cursor-pointer">Terms of Service</span>
            <span className="text-text-secondary underline font-medium cursor-pointer">Privacy Policy</span>
            <span className="text-text-secondary underline font-medium cursor-pointer">Content Policies</span>
          </div>
        </div>
      </div>
    </div>
  );
}
