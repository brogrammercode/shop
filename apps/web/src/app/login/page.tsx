"use client";

import React, { Suspense, useEffect, useRef, useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import Script from "next/script";
import { MoreVertical, User } from "lucide-react";
import { AuthRepo } from "@/features/auth/repo/auth.repo";
import { useUserStore } from "@/core/store/user.store";

declare global {
  interface Window {
    google?: {
      accounts: {
        id: {
          initialize: (options: {
            client_id: string;
            callback: (response: { credential?: string }) => void;
          }) => void;
          renderButton: (
            element: HTMLElement,
            options: {
              theme: "outline" | "filled_blue" | "filled_black";
              size: "large" | "medium" | "small";
              type: "standard" | "icon";
              text: "continue_with" | "signin_with" | "signup_with";
              shape: "rectangular" | "pill" | "circle" | "square";
              width?: number;
            },
          ) => void;
        };
      };
    };
  }
}

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
  const buttonRef = useRef<HTMLDivElement>(null);
  const hasRenderedButton = useRef(false);
  const [scriptLoaded, setScriptLoaded] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState("");

  const { user, requiresPhone } = useUserStore();
  const nextPath = searchParams.get("next") || "/";
  const googleClientId = process.env.NEXT_PUBLIC_GOOGLE_CLIENT_ID || "";

  useEffect(() => {
    if (!scriptLoaded || !googleClientId || !buttonRef.current || hasRenderedButton.current) {
      return;
    }

    window.google?.accounts.id.initialize({
      client_id: googleClientId,
      callback: async (response) => {
        if (!response.credential) {
          setError("Google sign in failed");
          return;
        }

        try {
          setIsLoading(true);
          setError("");
          const result = await AuthRepo.loginWithGoogle(response.credential);
          if (result.requires_phone) {
            router.replace(`/complete-phone?next=${encodeURIComponent(nextPath)}`);
            return;
          }
          router.replace(nextPath);
        } catch (err: unknown) {
          const message = err && typeof err === "object" && "response" in err
            ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
            : undefined;
          setError(message || "Unable to continue with Google");
        } finally {
          setIsLoading(false);
        }
      },
    });

    window.google?.accounts.id.renderButton(buttonRef.current, {
      theme: "outline",
      size: "large",
      type: "standard",
      text: "continue_with",
      shape: "rectangular",
      width: Math.min(buttonRef.current.clientWidth || 320, 420),
    });
    hasRenderedButton.current = true;
  }, [googleClientId, nextPath, router, scriptLoaded]);

  const handleProfileSelect = () => {
    if (requiresPhone) {
      router.push(`/complete-phone?next=${encodeURIComponent(nextPath)}`);
      return;
    }
    router.push(nextPath);
  };

  return (
    <div className="flex flex-col h-screen w-full relative bg-primary-green">
      <Script
        src="https://accounts.google.com/gsi/client"
        strategy="afterInteractive"
        onLoad={() => setScriptLoaded(true)}
      />

      <div className="flex-1 flex flex-col justify-center px-6">
        <div className="w-20 h-20 bg-pure-white/20 backdrop-blur-sm rounded-2xl flex items-center justify-center mb-5 border border-pure-white/30">
          <span className="text-pure-white font-semibold text-2xl leading-tight">L</span>
        </div>
        <h1 className="text-pure-white text-[32px] font-semibold mb-2 tracking-wide">Ladyluck</h1>
        <p className="text-pure-white/80 text-[15px] font-normal m-0">Login to continue</p>
      </div>

      <div className="bg-pure-white rounded-t-[24px] p-8 pb-8 shadow-deep flex flex-col gap-5">
        {user && (
          <>
            <div className="text-center text-sm font-semibold text-text-secondary mb-2">Choose your account</div>
            <div
              onClick={handleProfileSelect}
              className="flex items-center gap-3 p-3 bg-pure-white border border-[#E8E8E8] rounded-xl cursor-pointer hover:bg-soft-grey transition-colors shadow-sm"
            >
              <div className="w-10 h-10 rounded-full bg-soft-grey flex items-center justify-center overflow-hidden shrink-0">
                <User size={20} className="text-text-secondary" />
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-[14px] font-semibold text-text-primary truncate">
                  {user.name || "User"}
                </p>
                <p className="text-[12px] font-medium text-text-secondary truncate mt-0.5">
                  {user.phone || user.email || "Phone pending"}
                </p>
              </div>
              <MoreVertical size={20} className="text-text-secondary shrink-0" />
            </div>
          </>
        )}

        <div className="text-center text-xs font-semibold text-text-tertiary">Log in or sign up</div>

        <div className="min-h-12 flex items-center justify-center">
          {googleClientId ? (
            <div ref={buttonRef} className="w-full flex justify-center" />
          ) : (
            <div className="w-full rounded-xl border border-[#FFD1D1] bg-[#FFF5F5] px-4 py-3 text-[13px] font-medium text-[#B91C1C]">
              Google login is not configured.
            </div>
          )}
        </div>

        {isLoading && (
          <div className="flex justify-center">
            <span className="w-5 h-5 rounded-full border-2 border-primary-green border-t-transparent animate-spin" />
          </div>
        )}

        {error && <div className="text-red-500 text-[13px] font-medium">{error}</div>}

        <div className="mt-6 text-center text-[11px] text-text-tertiary font-normal leading-relaxed">
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
