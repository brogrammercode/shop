"use client";

import React, { Suspense, useEffect, useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { ChevronDown } from "lucide-react";
import { AuthRepo } from "@/features/auth/repo/auth.repo";
import { useUserStore } from "@/core/store/user.store";

export default function CompletePhonePage() {
  return (
    <Suspense fallback={<div className="min-h-screen flex items-center justify-center bg-pure-white"><div className="w-8 h-8 border-2 border-primary-green border-t-transparent rounded-full animate-spin" /></div>}>
      <CompletePhoneContent />
    </Suspense>
  );
}

function CompletePhoneContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const { token, user, requiresPhone, hasHydrated } = useUserStore();
  const [countryCode, setCountryCode] = useState("+91");
  const [phoneNumber, setPhoneNumber] = useState("");
  const [isSaving, setIsSaving] = useState(false);
  const [error, setError] = useState("");
  const nextPath = searchParams.get("next") || "/";
  const phoneRequiresCompletion =
    requiresPhone ||
    Boolean(user && (
      !user.phone ||
      user.phone.startsWith("no-phone-") ||
      user.phone.startsWith("merged_")
    ));

  useEffect(() => {
    if (!hasHydrated) return;
    if (!token) {
      router.replace(`/login?next=${encodeURIComponent(nextPath)}`);
      return;
    }
    if (!user) {
      AuthRepo.loadCurrentUser().catch(() => undefined);
      return;
    }
    if (user && !phoneRequiresCompletion) {
      router.replace(nextPath);
    }
  }, [hasHydrated, nextPath, phoneRequiresCompletion, router, token, user]);

  const submitPhone = async () => {
    if (phoneNumber.length < 10) {
      setError("Please enter a valid phone number");
      return;
    }

    try {
      setIsSaving(true);
      setError("");
      const result = await AuthRepo.completePhone(`${countryCode}${phoneNumber}`);
      if (result.requires_phone) {
        setError("Please enter a valid phone number");
        return;
      }
      router.replace(nextPath);
    } catch (err: unknown) {
      const message = err && typeof err === "object" && "response" in err
        ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
        : undefined;
      setError(message || "Unable to save phone number");
    } finally {
      setIsSaving(false);
    }
  };

  if (!hasHydrated || !token) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-pure-white">
        <div className="w-8 h-8 border-2 border-primary-green border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  return (
    <div className="flex flex-col h-screen w-full relative bg-primary-green">
      <div className="flex-1 flex flex-col justify-center px-6">
        <div className="w-20 h-20 bg-pure-white/20 backdrop-blur-sm rounded-2xl flex items-center justify-center mb-5 border border-pure-white/30">
          <span className="text-pure-white font-semibold text-2xl leading-tight">L</span>
        </div>
        <h1 className="text-pure-white text-[32px] font-semibold mb-2 tracking-wide">Complete profile</h1>
        <p className="text-pure-white/80 text-[15px] font-normal m-0">Add your phone number to continue</p>
      </div>

      <div className="bg-pure-white rounded-t-[24px] p-8 pb-8 shadow-deep flex flex-col gap-5">
        <div className="flex gap-3">
          <div className="relative">
            <select
              value={countryCode}
              onChange={(event) => setCountryCode(event.target.value)}
              className="appearance-none h-[52px] pl-3 pr-8 border border-border-grey rounded-xl bg-pure-white text-sm font-semibold text-text-primary focus:outline-none focus:border-primary-green cursor-pointer"
            >
              <option value="+91">IN +91</option>
              <option value="+1">US +1</option>
              <option value="+44">UK +44</option>
              <option value="+61">AU +61</option>
              <option value="+971">AE +971</option>
            </select>
            <ChevronDown size={14} className="absolute right-2 top-1/2 -translate-y-1/2 text-text-secondary pointer-events-none" />
          </div>
          <div className="flex-1 flex items-center h-[52px] border border-border-grey rounded-xl px-4 bg-pure-white focus-within:border-primary-green focus-within:border-[1.5px] transition-colors">
            <input
              type="tel"
              className="border-none outline-none text-base font-medium text-text-primary w-full bg-transparent placeholder:text-text-tertiary placeholder:font-normal"
              placeholder="Phone number"
              value={phoneNumber}
              onChange={(event) => setPhoneNumber(event.target.value.replace(/\D/g, ""))}
              maxLength={15}
            />
          </div>
        </div>

        {error && <div className="text-red-500 text-[13px] font-medium">{error}</div>}

        <button
          className="h-14 rounded-[14px] bg-primary-green text-pure-white text-base font-semibold border-none cursor-pointer flex items-center justify-center transition-opacity duration-200 w-full disabled:opacity-60 disabled:cursor-not-allowed shadow-standard"
          onClick={submitPhone}
          disabled={isSaving || phoneNumber.length < 10}
        >
          {isSaving ? "Saving..." : "Continue"}
        </button>
      </div>
    </div>
  );
}
