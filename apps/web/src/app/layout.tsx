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
    <html lang="en">
      <body className={`${outfit.variable} font-sans antialiased`}>
        {children}
        <RootNavigation />
      </body>
    </html>
  );
}
