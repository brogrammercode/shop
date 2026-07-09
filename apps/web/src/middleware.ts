import { NextRequest, NextResponse } from "next/server";
import {
  CUSTOMER_ORDERING_CARD_QR,
  CUSTOMER_ORDERING_QUERY_KEYS,
  CUSTOMER_ORDERING_ROUTES,
} from "@/features/customer_ordering/constants/customer_ordering.constants";

export function middleware(request: NextRequest) {
  const { nextUrl } = request;

  if (
    nextUrl.pathname === "/" &&
    nextUrl.searchParams.get(CUSTOMER_ORDERING_CARD_QR.QUERY_KEY) ===
      CUSTOMER_ORDERING_CARD_QR.QUERY_VALUE
  ) {
    const redirectUrl = nextUrl.clone();
    redirectUrl.pathname = CUSTOMER_ORDERING_ROUTES.MENU;
    redirectUrl.search = "";
    redirectUrl.searchParams.set(
      CUSTOMER_ORDERING_QUERY_KEYS.BRANCH_ID,
      CUSTOMER_ORDERING_CARD_QR.BRANCH_ID,
    );
    redirectUrl.searchParams.set(
      CUSTOMER_ORDERING_QUERY_KEYS.ORDER_TYPE,
      CUSTOMER_ORDERING_CARD_QR.ORDER_TYPE,
    );
    return NextResponse.redirect(redirectUrl);
  }

  return NextResponse.next();
}

export const config = {
  matcher: "/",
};
