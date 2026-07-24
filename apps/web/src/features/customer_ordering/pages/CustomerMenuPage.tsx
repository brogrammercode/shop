"use client";

import { useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import { useUserStore, type AddressModel } from "@/core/store/user.store";
import {
  Bell,
  Minus,
  Plus,
  Search,
  ShoppingBag,
  SlidersHorizontal,
  Truck,
  Utensils,
} from "lucide-react";
import {
  CUSTOMER_ORDERING_DEFAULTS,
  CUSTOMER_ORDERING_STORAGE_KEYS,
  CUSTOMER_ORDERING_TEXT,
} from "../constants/customer_ordering.constants";
import { CustomerOrderingApi } from "../services/customer_ordering.api";
import {
  CustomerCartItem,
  CustomerCartLine,
  CustomerMenuCategory,
  CustomerMenuItem,
  CustomerMenuItemSaleMode,
  CustomerOrderingContext,
} from "../types/customer_ordering.types";
import {
  activeSaleModes,
  buildCartItems,
  calculateSubtotal,
  cartKeyFor,
  defaultSaleMode,
  flattenItems,
  formatAmount,
  formatQuantity,
  imageForCategory,
  imageForItem,
  readOrderingContext,
} from "../utils/customer_ordering.utils";

type DisplayCategory = {
  id: string;
  label: string;
  imageUrl: string;
};

type DisplayProduct = {
  id: string;
  title: string;
  subtitle: string;
  price: number;
  imageUrl: string;
  imageFit?: "cover" | "contain";
  imageClassName?: string;
  item?: CustomerMenuItem;
  saleMode?: CustomerMenuItemSaleMode;
  quantityLabel?: string;
};

const getOrderingContext = (): CustomerOrderingContext | null =>
  typeof window === "undefined" ? null : readOrderingContext();

const cartStorageKeyFor = (context: CustomerOrderingContext | null): string =>
  [
    CUSTOMER_ORDERING_STORAGE_KEYS.CART,
    context?.branchId,
    context?.orderType,
    context?.tableId,
    context?.tableSideId,
  ]
    .filter(Boolean)
    .join(":");

const addressLabelFor = (address?: AddressModel): string =>
  [
    address?.address_line_1,
    address?.address_line_2,
    address?.city,
    address?.state,
    address?.postal_code,
  ]
    .filter(Boolean)
    .join(CUSTOMER_ORDERING_TEXT.ADDRESS_SEPARATOR);

export const CustomerMenuPage = () => {
  const router = useRouter();
  const primaryAddress = useUserStore((state) => state.addresses[0]);
  const [orderingContext] = useState<CustomerOrderingContext | null>(
    getOrderingContext,
  );
  const [categories, setCategories] = useState<CustomerMenuCategory[]>([]);
  const [activeCategoryId, setActiveCategoryId] = useState<string>(
    CUSTOMER_ORDERING_DEFAULTS.ACTIVE_CATEGORY_ID,
  );
  const [cart, setCart] = useState<Record<string, CustomerCartLine>>(() => {
    if (typeof window === "undefined") {
      return {};
    }

    const storedCart = sessionStorage.getItem(
      cartStorageKeyFor(getOrderingContext()),
    );
    return storedCart ? normalizeStoredCart(JSON.parse(storedCart)) : {};
  });
  const [saleModeItem, setSaleModeItem] = useState<CustomerMenuItem | null>(
    null,
  );
  const [isLoading, setIsLoading] = useState(Boolean(orderingContext?.branchId));
  const [isMounted, setIsMounted] = useState(false);

  useEffect(() => {
    const timer = window.setTimeout(() => setIsMounted(true), 0);
    return () => window.clearTimeout(timer);
  }, []);

  useEffect(() => {
    if (!orderingContext?.branchId) {
      return;
    }

    const loadData = async () => {
      setIsLoading(true);
      try {
        const menuData = await CustomerOrderingApi.getMenu(
          orderingContext.branchId,
        );
        setCategories(menuData);
      } catch {
        setCategories([]);
      } finally {
        setIsLoading(false);
      }
    };

    loadData();
  }, [orderingContext]);

  useEffect(() => {
    sessionStorage.setItem(
      cartStorageKeyFor(orderingContext),
      JSON.stringify(cart),
    );
  }, [cart, orderingContext]);

  const allItems = useMemo(
    () =>
      flattenItems(
        categories,
        CUSTOMER_ORDERING_DEFAULTS.ACTIVE_CATEGORY_ID,
      ),
    [categories],
  );
  const cartItems = useMemo(() => buildCartItems(allItems, cart), [allItems, cart]);
  const cartItemsByMenuItem = useMemo(
    () =>
      cartItems.reduce<Record<string, CustomerCartItem[]>>((next, cartItem) => {
        next[cartItem.item.id] = [...(next[cartItem.item.id] || []), cartItem];
        return next;
      }, {}),
    [cartItems],
  );
  const subtotal = useMemo(() => calculateSubtotal(cartItems), [cartItems]);
  const totalItems = cartItems.reduce((total, item) => total + item.quantity, 0);
  const orderContextLabel = useMemo(() => {
    const addressLabel = addressLabelFor(primaryAddress);

    if (addressLabel) {
      return addressLabel;
    }

    if (orderingContext?.tableId) {
      return `${CUSTOMER_ORDERING_TEXT.TABLE_FALLBACK} ${orderingContext.tableId}`;
    }

    return CUSTOMER_ORDERING_TEXT.SELECT_ADDRESS;
  }, [orderingContext, primaryAddress]);

  const updateCart = (
    item: CustomerMenuItem,
    saleMode = defaultSaleMode(item),
    delta: number,
  ) => {
    setCart((current) => {
      const cartKey = cartKeyFor(item, saleMode);
      const currentLine = current[cartKey];
      const currentQuantity = currentLine?.quantity || 0;
      const nextQuantity = Math.max(0, currentQuantity + saleMode.step_qty * delta);
      const next = { ...current };

      if (nextQuantity === 0) {
        delete next[cartKey];
      } else {
        next[cartKey] = {
          menu_item_id: item.id,
          sale_mode_id: saleMode.id,
          quantity: saleMode.allow_decimal
            ? Number(nextQuantity.toFixed(3))
            : Math.round(nextQuantity),
        };
      }

      return next;
    });
  };

  const handleAdd = (item: CustomerMenuItem) => {
    const modes = activeSaleModes(item);
    if (modes.length <= 1) {
      updateCart(item, modes[0], 1);
      return;
    }

    setSaleModeItem(item);
  };

  const categoryTabs = useMemo<DisplayCategory[]>(() => {
    const liveCategories = categories.map((category) => ({
      id: category.id,
      label: category.name,
      imageUrl: imageForCategory(category),
    }));

    return [
      {
        id: CUSTOMER_ORDERING_DEFAULTS.ACTIVE_CATEGORY_ID,
        label: CUSTOMER_ORDERING_TEXT.ALL_CATEGORY_LABEL,
        imageUrl:
          liveCategories.find((category) => category.imageUrl)?.imageUrl || "",
      },
      ...liveCategories,
    ];
  }, [categories]);

  const visibleItems = useMemo(() => {
    if (!categories.length) {
      return [];
    }

    if (activeCategoryId === CUSTOMER_ORDERING_DEFAULTS.ACTIVE_CATEGORY_ID) {
      return allItems;
    }

    return categories.find((category) => category.id === activeCategoryId)?.items || [];
  }, [activeCategoryId, allItems, categories]);

  const productTiles = useMemo<DisplayProduct[]>(() => {
    if (!visibleItems.length) {
      return [];
    }

    return visibleItems.map((item) => {
      const lines = cartItemsByMenuItem[item.id] || [];
      const fallbackSaleMode = defaultSaleMode(item);
      const cartItem =
        lines.find((line) => line.saleMode.id === fallbackSaleMode.id) ||
        lines[0] ||
        null;
      const saleMode = cartItem?.saleMode || defaultSaleMode(item);
      const quantityLabel =
        lines.length === 0
          ? ""
          : lines.length === 1
            ? formatQuantity(lines[0].quantity)
            : formatQuantity(
                lines.reduce((total, line) => total + line.quantity, 0),
              );

      return {
        id: item.id,
        title: item.display_name,
        subtitle: saleMode.label,
        price: saleMode.price_per_unit,
        imageUrl: imageForItem(item),
        imageFit: imageForItem(item) ? "cover" : "contain",
        item,
        saleMode,
        quantityLabel,
      };
    });
  }, [visibleItems, cartItemsByMenuItem]);

  if (!isMounted || isLoading) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-[#e5e5e5]">
        <div className="h-7 w-7 animate-spin rounded-full border-2 border-black/70 border-t-transparent" />
      </div>
    );
  }

  return (
    <main className="min-h-screen overflow-x-hidden bg-[#fbfbfb] text-[#111111]">
      <section className="relative mx-auto min-h-screen w-full max-w-[358px] overflow-hidden bg-[#fbfbfb]">
        <div className="relative z-10 flex min-h-screen flex-col overflow-y-auto px-[12px] pb-[112px] pt-[28px] [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
          <header className="flex items-center justify-between">
            <div className="flex min-w-0 items-center gap-2">
              <button
                type="button"
                aria-label="Delivery"
                className="flex h-[36px] w-[36px] items-center justify-center rounded-full bg-white shadow-[0_10px_22px_rgba(0,0,0,0.04)] ring-1 ring-black/[0.03]"
              >
                <Truck size={18} strokeWidth={1.9} />
              </button>
              <div className="min-w-0">
                <p className="text-[8px] font-normal text-[#9b9b9b]">
                  {CUSTOMER_ORDERING_TEXT.DELIVERY_TO}
                </p>
                <p
                  className="mt-0.5 max-w-[150px] truncate text-[10px] font-medium text-black"
                  title={orderContextLabel}
                >
                  {orderContextLabel}
                </p>
              </div>
            </div>

            <div className="flex items-center gap-2">
              <button
                type="button"
                aria-label="Notifications"
                className="flex h-[37px] w-[37px] items-center justify-center rounded-full bg-white shadow-[0_10px_22px_rgba(0,0,0,0.04)] ring-1 ring-black/[0.03]"
              >
                <Bell size={18} strokeWidth={1.9} />
              </button>
              <button
                type="button"
                aria-label="Bag"
                onClick={() => router.push("/cart")}
                className="relative flex h-[37px] w-[37px] items-center justify-center rounded-full bg-white shadow-[0_10px_22px_rgba(0,0,0,0.04)] ring-1 ring-black/[0.03]"
              >
                <ShoppingBag size={17} strokeWidth={1.9} />
                {totalItems > 0 ? (
                  <span className="absolute -right-0.5 top-0 flex h-[13px] min-w-[13px] items-center justify-center rounded-full bg-[#ff7448] px-0.5 text-[7px] font-semibold leading-none text-white">
                    {totalItems}
                  </span>
                ) : null}
              </button>
            </div>
          </header>

          <h1 className="mt-[23px] text-[28px] font-semibold leading-[1.05] tracking-normal">
            {CUSTOMER_ORDERING_TEXT.MENU_TITLE_PRIMARY}{" "}
            <span className="font-normal text-[#777777]">
              {CUSTOMER_ORDERING_TEXT.MENU_TITLE_SECONDARY}
            </span>
          </h1>

          <div className="mt-[24px] flex items-center gap-3">
            <label className="flex h-[40px] flex-1 items-center gap-2 rounded-full bg-white px-4 shadow-[0_14px_32px_rgba(0,0,0,0.04)]">
              <Search size={17} className="shrink-0 text-[#8b8b8b]" strokeWidth={1.9} />
              <input
                type="search"
                aria-label="Search"
                placeholder={CUSTOMER_ORDERING_TEXT.MENU_SEARCH_PLACEHOLDER}
                className="min-w-0 flex-1 bg-transparent text-[9px] font-normal text-[#686868] outline-none placeholder:text-[#9b9b9b]"
              />
            </label>
            <button
              type="button"
              aria-label="Filters"
              className="flex h-[40px] w-[40px] shrink-0 items-center justify-center rounded-full bg-black text-white shadow-[0_14px_25px_rgba(0,0,0,0.22)]"
            >
              <SlidersHorizontal size={19} strokeWidth={2} />
            </button>
          </div>

          <section className="relative mt-[24px] h-[150px]">
            <div className="pointer-events-none absolute -left-[46px] top-[11px] h-[172px] w-[438px] rounded-t-[70%] bg-[#f0f0f0]" />
            <div className="relative z-10 flex items-start gap-[13px] overflow-x-auto pb-2 [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
              {categoryTabs.map((category) => (
                <CategoryButton
                  key={category.id}
                  category={category}
                  isActive={category.id === activeCategoryId}
                  onSelect={() => setActiveCategoryId(category.id)}
                />
              ))}
            </div>
          </section>

          <section className="relative mt-[3px] grid grid-cols-2 gap-x-[8px] gap-y-[27px]">
            {productTiles.length > 0 ? (
              productTiles.map((product, index) => (
                <FoodTile
                  key={`${product.id}-${index}`}
                  product={product}
                  onAdd={() => {
                    if (product.item) {
                      handleAdd(product.item);
                    }
                  }}
                  onIncrement={() => {
                    if (product.item && product.saleMode) {
                      updateCart(product.item, product.saleMode, 1);
                    }
                  }}
                  onDecrement={() => {
                    if (product.item && product.saleMode) {
                      updateCart(product.item, product.saleMode, -1);
                    }
                  }}
                />
              ))
            ) : (
              <div className="col-span-2 rounded-[14px] bg-white px-5 py-10 text-center shadow-[0_15px_32px_rgba(0,0,0,0.06)]">
                <div className="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-[#f4f4f2] text-[#8c8c8c]">
                  <Utensils size={21} strokeWidth={1.8} />
                </div>
                <p className="mt-4 text-[14px] font-medium text-black">
                  {CUSTOMER_ORDERING_TEXT.EMPTY_CATEGORY_TITLE}
                </p>
                <p className="mt-1 text-[11px] font-normal leading-5 text-[#8c8c8c]">
                  {CUSTOMER_ORDERING_TEXT.EMPTY_CATEGORY_BODY}
                </p>
              </div>
            )}
          </section>
        </div>

      </section>

      {saleModeItem ? (
        <div className="fixed inset-0 z-[60] flex items-end bg-black/40 px-4">
          <div className="mx-auto w-full max-w-[358px] rounded-t-[24px] bg-white px-5 pb-6 pt-4">
            <div className="mx-auto mb-5 h-1 w-10 rounded-full bg-[#d8d8d8]" />
            <h2 className="text-[18px] font-medium text-black">
              {CUSTOMER_ORDERING_TEXT.SELECT_SALE_MODE}
            </h2>
            <p className="mb-4 mt-1 text-[13px] font-normal text-[#777777]">
              {saleModeItem.display_name}
            </p>
            <div className="flex flex-col gap-3">
              {activeSaleModes(saleModeItem).map((mode) => (
                <button
                  key={mode.id}
                  type="button"
                  onClick={() => {
                    updateCart(saleModeItem, mode, 1);
                    setSaleModeItem(null);
                  }}
                  className="flex w-full items-center justify-between rounded-[14px] border border-[#ededed] bg-[#fafafa] px-4 py-3 text-left"
                >
                  <span>
                    <span className="block text-[14px] font-medium text-black">
                      {mode.label}
                    </span>
                    <span className="mt-1 block text-[12px] font-normal text-[#777777]">
                      {formatAmount(mode.price_per_unit)}
                      {CUSTOMER_ORDERING_TEXT.SALE_MODE_SEPARATOR}
                      {mode.uom_code || CUSTOMER_ORDERING_TEXT.DEFAULT_SALE_MODE}
                    </span>
                  </span>
                  <span className="text-[13px] font-medium text-[#ff7448]">
                    {CUSTOMER_ORDERING_TEXT.ADD_ACTION}
                  </span>
                </button>
              ))}
            </div>
            <button
              type="button"
              onClick={() => setSaleModeItem(null)}
              className="mt-4 h-11 w-full rounded-[14px] border border-[#ededed] text-[14px] font-normal text-[#777777]"
            >
              {CUSTOMER_ORDERING_TEXT.CONTINUE}
            </button>
          </div>
        </div>
      ) : null}

      <span className="sr-only">Subtotal {formatAmount(subtotal)}</span>
    </main>
  );
};

const CategoryButton = ({
  category,
  isActive,
  onSelect,
}: {
  category: DisplayCategory;
  isActive: boolean;
  onSelect: () => void;
}) => {
  return (
    <button
      type="button"
      onClick={onSelect}
      className={`flex w-[58px] shrink-0 flex-col items-center gap-2 ${
        isActive ? "pt-0" : "pt-[9px]"
      }`}
    >
      <span
        className={`flex items-center justify-center rounded-full bg-white shadow-[0_12px_24px_rgba(0,0,0,0.07)] ${
          isActive ? "h-[58px] w-[58px]" : "h-[47px] w-[47px]"
        }`}
      >
        {category.imageUrl ? (
          <span className="flex h-[35px] w-[35px] items-center justify-center overflow-hidden rounded-full bg-[#fafafa]">
            <img
              src={category.imageUrl}
              alt={category.label}
              className="h-full w-full object-cover"
            />
          </span>
        ) : (
          <Utensils size={19} />
        )}
      </span>
      <span
        className={`text-[10px] ${
          isActive ? "font-medium text-black" : "font-normal text-[#777777]"
        }`}
      >
        {category.label}
      </span>
      {isActive ? (
        <span className="h-[4px] w-[28px] rounded-full bg-black" />
      ) : null}
    </button>
  );
};

const FoodTile = ({
  product,
  onAdd,
  onIncrement,
  onDecrement,
}: {
  product: DisplayProduct;
  onAdd: () => void;
  onIncrement: () => void;
  onDecrement: () => void;
}) => {
  const hasQuantity = Boolean(product.quantityLabel);
  const action = hasQuantity ? "remove" : "add";

  return (
    <article className="relative h-[190px] rounded-[10px] bg-white px-3 pb-3 pt-[96px] shadow-[0_15px_32px_rgba(0,0,0,0.07)]">
      <div className="absolute -top-[17px] left-1/2 flex h-[104px] w-[122px] -translate-x-1/2 items-center justify-center">
        <div className="absolute bottom-[4px] h-[58px] w-[104px] rounded-[999px] bg-[#f7f7f5]" />
        <div className="absolute bottom-[10px] h-[15px] w-[84px] rounded-full bg-black/[0.055] blur-[8px]" />
        {product.imageUrl ? (
          <img
            src={product.imageUrl}
            alt={product.title}
            className={`relative z-10 h-[102px] w-[122px] drop-shadow-[0_14px_16px_rgba(0,0,0,0.14)] ${
              product.imageFit === "cover" ? "object-cover rounded-[8px]" : "object-contain"
            } ${product.imageClassName || ""}`}
          />
        ) : (
          <Utensils size={30} className="relative z-10 text-[#a0a0a0]" />
        )}
      </div>

      <div className="flex h-full flex-col items-center text-center">
        <h2 className="max-w-full text-[13px] font-medium leading-[1.05] text-black">
          {product.title}
        </h2>
        <p className="mt-[2px] max-w-full text-[10px] font-normal leading-tight text-[#8c8c8c]">
          {product.subtitle}
        </p>
        <div className="mt-auto flex w-full items-center justify-between">
          <div className="flex items-baseline gap-1">
            <span className="text-[22px] font-semibold tracking-normal text-black">
              {formatAmount(product.price)}
            </span>
          </div>
          {hasQuantity ? (
            <div className="flex items-center gap-1">
              <button
                type="button"
                aria-label={`Decrease ${product.title}`}
                onClick={onDecrement}
                className="flex h-[26px] w-[26px] items-center justify-center rounded-full bg-black text-white"
              >
                <Minus size={13} strokeWidth={2.6} />
              </button>
              <span className="min-w-[18px] text-[11px] font-medium">
                {product.quantityLabel}
              </span>
              <button
                type="button"
                aria-label={`Increase ${product.title}`}
                onClick={onIncrement}
                className="flex h-[26px] w-[26px] items-center justify-center rounded-full bg-[#f8f8f8] text-black"
              >
                <Plus size={13} strokeWidth={2.6} />
              </button>
            </div>
          ) : (
            <button
              type="button"
              aria-label={`${action === "add" ? "Add" : "Remove"} ${product.title}`}
              onClick={onAdd}
              className={`flex h-[27px] w-[27px] items-center justify-center rounded-full shadow-[0_5px_12px_rgba(0,0,0,0.08)] ${
                action === "remove"
                  ? "bg-black text-white"
                  : "bg-[#f8f8f8] text-black"
              }`}
            >
              {action === "remove" ? (
                <Minus size={13} strokeWidth={2.6} />
              ) : (
                <Plus size={13} strokeWidth={2.6} />
              )}
            </button>
          )}
        </div>
      </div>
    </article>
  );
};

const normalizeStoredCart = (
  value: unknown,
): Record<string, CustomerCartLine> => {
  if (!value || typeof value !== "object") {
    return {};
  }

  return Object.entries(value as Record<string, unknown>).reduce<
    Record<string, CustomerCartLine>
  >((next, [key, entry]) => {
    if (typeof entry === "number") {
      return next;
    }

    if (entry && typeof entry === "object") {
      const line = entry as CustomerCartLine;
      if (line.menu_item_id && line.sale_mode_id) {
        next[key] = line;
      }
    }

    return next;
  }, {});
};
