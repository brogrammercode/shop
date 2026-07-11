export const formatInr = (amount: number, fractionDigits = 0): string => {
  const value = Number.isFinite(amount) ? amount : 0;
  const formattedAmount = new Intl.NumberFormat("en-IN", {
    minimumFractionDigits: fractionDigits,
    maximumFractionDigits: fractionDigits,
  }).format(value);
  return `\u20B9${formattedAmount}`;
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
