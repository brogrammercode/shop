export const MESS_TIFFIN_TEXT = {
  PAGE_TITLE: "Mess / Tiffin Service",
  PAGE_SUBTITLE: "Weekly home-style meal menu for new members.",
  STATUS_LABEL: "Not enrolled",
  WEEKLY_MENU: "Weekly menu",
  MENU_NOTE: "Review the full week before starting your mess subscription.",
  COMING_SOON_ACTION: "Coming soon",
  MEAL_COUNT_LABEL: "Meals per day",
  MEAL_COUNT_VALUE: "3",
  WEEK_LABEL: "Menu cycle",
  WEEK_VALUE: "7 days",
} as const;

export const MESS_TIFFIN_MENU = [
  {
    day: "MONDAY",
    meals: [
      "Aaloo Paratha + Raita/Dahi + Achar",
      "Roti + Chawal + Dal + Salad + Mix Veg + Bhujiya",
      "Roti + Chawal + Masoor Dal + Salad + Seasonal Sabji",
    ],
  },
  {
    day: "TUESDAY",
    meals: [
      "Kachodi + Chola Sabji",
      "Roti + Jeera Rice + Dal + Salad + Raita",
      "Roti + Chawal + Dal + Salad + Kheer",
    ],
  },
  {
    day: "WEDNESDAY",
    meals: [
      "Paratha + Mix Veg",
      "Roti + Chawal + Dal + Salad + Mix Veg",
      "Roti + Chawal + Dal + Salad + Matar Paneer",
    ],
  },
  {
    day: "THURSDAY",
    meals: [
      "Dal Paratha + Dahi",
      "Roti + Chawal + Curry Pakoda + Salad + Bhujiya",
      "Puri + Kabuli Chana + Salad + Sweets",
    ],
  },
  {
    day: "FRIDAY",
    meals: [
      "Chola Bhatora + Salad",
      "Roti + Chawal + Dal + Salad + Mix Veg",
      "Paneer Veg Biryani + Raita",
    ],
  },
  {
    day: "SATURDAY",
    meals: [
      "Poha + Jalebi",
      "Khichdi + Chokha + Papad/Chips + Dahi + Salad",
      "Roti + Chawal + Dal + Salad + Mix Veg + Sewai",
    ],
  },
  {
    day: "SUNDAY",
    meals: [
      "Idli + Chambhar + Chatni",
      "Puri + Chawal + Sambhar + Papad/Chips + Salad",
      "Roti + Jeera Rice + Dal + Salad + Kadhai Paneer + Sweets",
    ],
  },
] as const;
