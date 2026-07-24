import type { Metadata } from "next";
import { Outfit } from "next/font/google";
import { RootNavigation } from "@/components/platform/RootNavigation";
import "./globals.css";

const outfit = Outfit({
  variable: "--font-outfit",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "Ladyluck",
  description: "Order food online — fast, fresh, and delivered to you.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="m-0 min-h-full w-full overflow-x-hidden p-0">
      <body
        className={`${outfit.variable} m-0 min-h-screen w-full overflow-x-hidden p-0 font-sans antialiased`}
      >
        {children}
        <RootNavigation />
      </body>
    </html>
  );
}
