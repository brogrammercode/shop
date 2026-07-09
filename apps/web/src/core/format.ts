export const formatInr = (amount: number, fractionDigits = 0): string => {
  const value = Number.isFinite(amount) ? amount : 0;
  return new Intl.NumberFormat("en-IN", {
    style: "currency",
    currency: "INR",
    minimumFractionDigits: fractionDigits,
    maximumFractionDigits: fractionDigits,
  }).format(value);
};

export const formatQuantity = (quantity: number): string => {
  return Number.isInteger(quantity)
    ? quantity.toString()
    : quantity.toFixed(3).replace(/0+$/, "").replace(/\.$/, "");
};

export const formatQuantityWithUnit = (
  quantity: number,
  unit?: string | null,
): string => {
  const safeUnit = unit?.trim();
  return safeUnit
    ? `${formatQuantity(quantity)} ${safeUnit}`
    : formatQuantity(quantity);
};
