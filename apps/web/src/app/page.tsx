import Link from "next/link";
import { redirect } from "next/navigation";
import {
  CUSTOMER_ORDERING_CARD_QR,
  CUSTOMER_ORDERING_QUERY_KEYS,
  CUSTOMER_ORDERING_ROUTES,
} from "@/features/customer_ordering/constants/customer_ordering.constants";

type HomeProps = {
  searchParams?: Promise<Record<string, string | string[] | undefined>>;
};

export default async function Home({ searchParams }: HomeProps) {
  const params = await searchParams;
  const qr = params?.[CUSTOMER_ORDERING_CARD_QR.QUERY_KEY];
  const qrValue = Array.isArray(qr) ? qr[0] : qr;

  if (qrValue === CUSTOMER_ORDERING_CARD_QR.QUERY_VALUE) {
    const menuParams = new URLSearchParams({
      [CUSTOMER_ORDERING_QUERY_KEYS.BRANCH_ID]: CUSTOMER_ORDERING_CARD_QR.BRANCH_ID,
      [CUSTOMER_ORDERING_QUERY_KEYS.ORDER_TYPE]: CUSTOMER_ORDERING_CARD_QR.ORDER_TYPE,
    });
    redirect(`${CUSTOMER_ORDERING_ROUTES.MENU}?${menuParams.toString()}`);
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-pure-white">
      <Link 
        href={CUSTOMER_ORDERING_ROUTES.MENU} 
        className="px-6 py-3 bg-primary-green text-pure-white font-medium rounded-lg shadow-standard"
      >
        Open POS Menu
      </Link>
    </div>
  );
}
