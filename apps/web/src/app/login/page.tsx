"use client";

import React, { Suspense, useState } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { Check, ChevronDown } from 'lucide-react';
import { AuthRepo } from '@/features/auth/repo/auth.repo';

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
  const [otp, setOtp] = useState('');
  const [step, setStep] = useState<'PHONE' | 'OTP'>('PHONE');
  const [rememberLogin, setRememberLogin] = useState(true);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');

  const handleSendOtp = async () => {
    if (phoneNumber.length < 10) {
      setError('Please enter a valid phone number');
      return;
    }
    try {
      setIsLoading(true);
      setError('');
      await AuthRepo.sendOtp(phoneNumber);
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
      await AuthRepo.verifyOtp(phoneNumber, otp);
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
    <div className="flex flex-col h-screen w-full relative bg-gradient-to-b from-[#18A95A] to-[#0B6433]">
      <div className="flex-1 flex flex-col justify-center px-6">
        <div className="w-20 h-20 bg-[#4CAF50] rounded-xl flex items-center justify-center mb-5">
          <span className="text-white font-black text-2xl leading-tight font-serif">L</span>
        </div>
        <h1 className="text-white text-[32px] font-extrabold mb-2 tracking-wide">Ladyluck</h1>
        <p className="text-[#E8F5E9] text-[15px] font-medium m-0">Login to continue</p>
      </div>

      <div className="bg-white rounded-t-[24px] p-8 pb-8 shadow-[0_-4px_16px_rgba(0,0,0,0.1)] flex flex-col gap-5">
        {step === 'PHONE' ? (
          <>
            <div className="text-center text-sm font-bold text-[#999999] mb-2">Log in or sign up</div>
            
            <div className="flex gap-3">
              <div className="flex items-center justify-center gap-1.5 h-[52px] px-4 border border-[#E8E8E8] rounded-xl bg-white text-base font-semibold text-[#1C1C1C]">
                <span className="text-lg">🇮🇳</span>
                <ChevronDown size={16} color="#666666" />
              </div>
              <div className="flex-1 flex items-center h-[52px] border border-[#E8E8E8] rounded-xl px-4 bg-white focus-within:border-[#0F8244] focus-within:border-[1.5px]">
                <span className="text-base font-bold text-[#1C1C1C] mr-2">+91</span>
                <input 
                  type="tel" 
                  className="border-none outline-none text-base font-semibold text-[#1C1C1C] w-full bg-transparent placeholder:text-[#999999] placeholder:font-medium" 
                  placeholder="Enter phone number" 
                  value={phoneNumber}
                  onChange={(e) => setPhoneNumber(e.target.value.replace(/\D/g, ''))}
                  maxLength={10}
                />
              </div>
            </div>

            {error && <div className="text-[#EF4F5F] text-[13px] font-semibold">{error}</div>}

            <div className="flex items-center gap-3 cursor-pointer" onClick={() => setRememberLogin(!rememberLogin)}>
              <div className={`w-5 h-5 rounded-md border-none flex items-center justify-center text-white ${rememberLogin ? 'bg-[#EF4F5F]' : 'bg-[#E8E8E8]'}`}>
                {rememberLogin && <Check size={14} strokeWidth={3} />}
              </div>
              <span className="text-sm font-semibold text-[#666666]">Remember Login</span>
            </div>

            <button 
              className="h-14 rounded-[14px] bg-[#0F8244] text-white text-base font-extrabold border-none cursor-pointer flex items-center justify-center transition-opacity duration-200 w-full disabled:opacity-60 disabled:cursor-not-allowed" 
              onClick={handleSendOtp}
              disabled={isLoading || phoneNumber.length < 10}
            >
              {isLoading ? 'Sending...' : 'Continue'}
            </button>
          </>
        ) : (
          <div className="flex flex-col gap-4">
            <div className="text-center text-sm font-bold text-[#999999] mb-2">Enter the OTP sent to +91 {phoneNumber}</div>
            <input 
              type="text" 
              className="h-[52px] border border-[#E8E8E8] rounded-xl px-4 text-lg font-bold text-[#1C1C1C] text-center tracking-[4px] focus:border-[#0F8244] focus:outline-none" 
              placeholder="000000"
              value={otp}
              onChange={(e) => setOtp(e.target.value.replace(/\D/g, ''))}
              maxLength={6}
            />
            
            {error && <div className="text-[#EF4F5F] text-[13px] font-semibold">{error}</div>}

            <button 
              className="h-14 rounded-[14px] bg-[#0F8244] text-white text-base font-extrabold border-none cursor-pointer flex items-center justify-center transition-opacity duration-200 w-full disabled:opacity-60 disabled:cursor-not-allowed" 
              onClick={handleVerifyOtp}
              disabled={isLoading || otp.length < 6}
            >
              {isLoading ? 'Verifying...' : 'Verify & Login'}
            </button>
            <div className="text-center text-[13px] text-[#0F8244] font-semibold cursor-pointer mt-2" onClick={() => setStep('PHONE')}>
              Change Phone Number
            </div>
          </div>
        )}

        <div className="mt-8 text-center text-[11px] text-[#999999] font-medium leading-relaxed">
          By continuing you agree to our
          <div className="flex justify-center gap-3 mt-1">
            <span className="text-[#666666] underline font-bold cursor-pointer">Terms of Service</span>
            <span className="text-[#666666] underline font-bold cursor-pointer">Privacy Policy</span>
            <span className="text-[#666666] underline font-bold cursor-pointer">Content Policies</span>
          </div>
        </div>
      </div>
    </div>
  );
}
