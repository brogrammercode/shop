import { CalendarDays, CookingPot, LockKeyhole, Utensils } from "lucide-react";
import {
  MESS_TIFFIN_MENU,
  MESS_TIFFIN_TEXT,
} from "@/features/mess_tiffin/constants/mess_tiffin.constants";

export default function MessTiffinPage() {
  const mealRows = MESS_TIFFIN_MENU[0].meals.map((_, index) => index);

  return (
    <main className="min-h-screen overflow-x-hidden bg-[#fbfbfb] px-5 pb-28 pt-8 text-[#111111]">
      <section className="mx-auto w-full max-w-[1180px]">
        <header className="flex flex-col gap-6 rounded-[22px] bg-white px-6 py-6 shadow-[0_14px_34px_rgba(0,0,0,0.06)] ring-1 ring-black/[0.04] md:flex-row md:items-center md:justify-between md:px-8">
          <div className="flex min-w-0 items-start gap-4">
            <div className="flex h-12 w-12 shrink-0 items-center justify-center rounded-full bg-[#ff7448] text-white shadow-[0_10px_22px_rgba(255,116,72,0.28)]">
              <CookingPot size={23} strokeWidth={2} />
            </div>
            <div className="min-w-0">
              <div className="inline-flex items-center gap-1.5 rounded-full bg-[#fff0ea] px-3 py-1 text-[11px] font-medium text-[#d9532f]">
                <LockKeyhole size={13} strokeWidth={2} />
                {MESS_TIFFIN_TEXT.STATUS_LABEL}
              </div>
              <h1 className="mt-3 text-[31px] font-semibold leading-tight tracking-normal text-black md:text-[38px]">
                {MESS_TIFFIN_TEXT.PAGE_TITLE}
              </h1>
              <p className="mt-2 max-w-[560px] text-[14px] font-normal leading-6 text-[#666666]">
                {MESS_TIFFIN_TEXT.PAGE_SUBTITLE}
              </p>
            </div>
          </div>

          <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
            <MetricCard
              icon={Utensils}
              label={MESS_TIFFIN_TEXT.MEAL_COUNT_LABEL}
              value={MESS_TIFFIN_TEXT.MEAL_COUNT_VALUE}
            />
            <MetricCard
              icon={CalendarDays}
              label={MESS_TIFFIN_TEXT.WEEK_LABEL}
              value={MESS_TIFFIN_TEXT.WEEK_VALUE}
            />
            <button
              type="button"
              disabled
              className="inline-flex h-11 cursor-not-allowed items-center justify-center rounded-full bg-black/80 px-5 text-[13px] font-medium text-white shadow-[0_14px_26px_rgba(0,0,0,0.14)]"
            >
              {MESS_TIFFIN_TEXT.COMING_SOON_ACTION}
            </button>
          </div>
        </header>

        <section className="mt-7">
          <div className="mb-4 flex flex-col gap-1 sm:flex-row sm:items-end sm:justify-between">
            <div>
              <h2 className="text-[22px] font-semibold tracking-normal text-black">
                {MESS_TIFFIN_TEXT.WEEKLY_MENU}
              </h2>
              <p className="mt-1 text-[13px] font-normal text-[#777777]">
                {MESS_TIFFIN_TEXT.MENU_NOTE}
              </p>
            </div>
          </div>

          <div className="overflow-x-auto rounded-[18px] bg-white shadow-[0_14px_34px_rgba(0,0,0,0.06)] ring-1 ring-black/[0.05]">
            <div className="min-w-[980px]">
              <div className="grid grid-cols-7 border-b border-[#e6e6e6] bg-[#fcfcfc]">
                {MESS_TIFFIN_MENU.map((menu) => (
                  <div
                    key={menu.day}
                    className="border-r border-[#e6e6e6] px-4 py-3 text-center text-[13px] font-medium text-black last:border-r-0"
                  >
                    {menu.day}
                  </div>
                ))}
              </div>

              {mealRows.map((row) => (
                <div
                  key={row}
                  className="grid grid-cols-7 border-b border-[#e6e6e6] last:border-b-0"
                >
                  {MESS_TIFFIN_MENU.map((menu) => (
                    <div
                      key={`${menu.day}-${row}`}
                      className="flex min-h-[90px] items-center justify-center border-r border-[#e6e6e6] px-4 py-5 text-center text-[14px] font-normal leading-[1.25] text-black last:border-r-0"
                    >
                      {menu.meals[row]}
                    </div>
                  ))}
                </div>
              ))}
            </div>
          </div>
        </section>
      </section>
    </main>
  );
}

const MetricCard = ({
  icon: Icon,
  label,
  value,
}: {
  icon: typeof Utensils;
  label: string;
  value: string;
}) => (
  <div className="flex h-11 min-w-[128px] items-center gap-3 rounded-full bg-[#f6f6f6] px-4 ring-1 ring-black/[0.04]">
    <Icon className="text-[#ff7448]" size={17} strokeWidth={2} />
    <div>
      <p className="text-[9px] font-normal leading-none text-[#8c8c8c]">
        {label}
      </p>
      <p className="mt-1 text-[12px] font-medium leading-none text-black">
        {value}
      </p>
    </div>
  </div>
);
