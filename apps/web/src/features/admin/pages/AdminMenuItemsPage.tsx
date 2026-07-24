"use client";

import { FormEvent, useEffect, useMemo, useState } from "react";
import { ListChecks, Pencil, Plus, Trash2 } from "lucide-react";
import {
  AdminButton,
  AdminField,
  AdminImageStrip,
  AdminPageHeader,
  AdminPanel,
  AdminRefreshButton,
  AdminSelect,
  AdminStateMessage,
  AdminTextarea,
  AdminToggle,
} from "../components/AdminPrimitives";
import { ADMIN_STATUS_OPTIONS, ADMIN_TEXT } from "../constants/admin.constants";
import { AdminApi } from "../services/admin.api";
import { AdminItem, AdminItemVariant, AdminMenuCategory, AdminMenuItem, AdminMenuItemSaleMode, AdminUom } from "../types/admin.types";
import { arrayToCsv, csvToArray, formatDate, numericOrZero, optional } from "../utils/admin.utils";

interface MenuItemFormState {
  category_id: string;
  variant_id: string;
  display_name: string;
  description: string;
  selling_price: string;
  images: string;
  videos: string;
  status: string;
  sale_uom_id: string;
  sale_label: string;
  sale_price_per_unit: string;
  sale_min_qty: string;
  sale_step_qty: string;
  sale_allow_decimal: boolean;
  sale_is_default: boolean;
}

const emptyForm: MenuItemFormState = {
  category_id: "",
  variant_id: "",
  display_name: "",
  description: "",
  selling_price: "0",
  images: "",
  videos: "",
  status: ADMIN_TEXT.ACTIVE,
  sale_uom_id: "",
  sale_label: "",
  sale_price_per_unit: "",
  sale_min_qty: "1",
  sale_step_qty: "1",
  sale_allow_decimal: false,
  sale_is_default: true,
};

export const AdminMenuItemsPage = () => {
  const [menuItems, setMenuItems] = useState<AdminMenuItem[]>([]);
  const [menuCategories, setMenuCategories] = useState<AdminMenuCategory[]>([]);
  const [inventoryItems, setInventoryItems] = useState<AdminItem[]>([]);
  const [variants, setVariants] = useState<AdminItemVariant[]>([]);
  const [uoms, setUoms] = useState<AdminUom[]>([]);
  const [form, setForm] = useState<MenuItemFormState>(emptyForm);
  const [categoryName, setCategoryName] = useState("");
  const [categoryDescription, setCategoryDescription] = useState("");
  const [editing, setEditing] = useState<AdminMenuItem | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");

  const categoryOptions = useMemo(() => [{ value: "", label: "Select menu category" }, ...menuCategories.map((category) => ({ value: category.id, label: category.name }))], [menuCategories]);
  const variantOptions = useMemo(() => [{ value: "", label: "Select inventory variant" }, ...variants.map((variant) => {
    const item = inventoryItems.find((entry) => entry.id === variant.item_id);
    return {
      value: variant.id,
      label: `${item?.name || variant.item_id}${variant.name ? ` - ${variant.name}` : ""} (${variant.uom?.code || variant.uom_id})`,
    };
  })], [inventoryItems, variants]);
  const uomOptions = useMemo(() => [{ value: "", label: "Use variant UOM" }, ...uoms.map((uom) => ({ value: uom.id, label: `${uom.code}${uom.description ? ` - ${uom.description}` : ""}` }))], [uoms]);

  const load = async () => {
    setLoading(true);
    setError("");
    try {
      const [nextMenuItems, nextMenuCategories, nextItems, nextUoms] = await Promise.all([
        AdminApi.listMenuItems(),
        AdminApi.listMenuCategories(),
        AdminApi.listItems(),
        AdminApi.listUom(),
      ]);
      const nextVariants = (await Promise.all(nextItems.map((item) => AdminApi.listVariants(item.id).catch(() => [])))).flat();
      setMenuItems(nextMenuItems);
      setMenuCategories(nextMenuCategories);
      setInventoryItems(nextItems);
      setVariants(nextVariants);
      setUoms(nextUoms);
      setForm((current) => ({
        ...current,
        category_id: current.category_id || nextMenuCategories[0]?.id || "",
        variant_id: current.variant_id || nextVariants[0]?.id || "",
        sale_uom_id: current.sale_uom_id || "",
      }));
    } catch (err) {
      setError(err instanceof Error ? err.message : ADMIN_TEXT.EMPTY);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    const timer = window.setTimeout(() => {
      void load();
    }, 0);
    return () => window.clearTimeout(timer);
  }, []);

  const updateField = <K extends keyof MenuItemFormState>(key: K, value: MenuItemFormState[K]) => {
    setForm((current) => ({ ...current, [key]: value }));
  };

  const reset = () => {
    setEditing(null);
    setForm({
      ...emptyForm,
      category_id: menuCategories[0]?.id || "",
      variant_id: variants[0]?.id || "",
    });
  };

  const edit = (item: AdminMenuItem) => {
    const saleMode = item.sale_modes?.[0];
    setEditing(item);
    setForm({
      category_id: item.category_id,
      variant_id: item.variant_id,
      display_name: item.display_name || "",
      description: item.description || "",
      selling_price: String(item.selling_price ?? 0),
      images: arrayToCsv(item.images),
      videos: arrayToCsv(item.videos),
      status: item.status || ADMIN_TEXT.ACTIVE,
      sale_uom_id: saleMode?.uom_id || "",
      sale_label: saleMode?.label || "",
      sale_price_per_unit: saleMode?.price_per_unit?.toString() || "",
      sale_min_qty: saleMode?.min_qty?.toString() || "1",
      sale_step_qty: saleMode?.step_qty?.toString() || "1",
      sale_allow_decimal: Boolean(saleMode?.allow_decimal),
      sale_is_default: saleMode?.is_default ?? true,
    });
  };

  const createCategory = async () => {
    if (!categoryName.trim()) {
      setError(ADMIN_TEXT.REQUIRED);
      return;
    }
    setSaving(true);
    setError("");
    try {
      await AdminApi.createMenuCategory({
        name: categoryName.trim(),
        description: optional(categoryDescription),
        display_order: menuCategories.length,
        status: ADMIN_TEXT.ACTIVE,
      });
      setCategoryName("");
      setCategoryDescription("");
      await load();
    } catch (err) {
      setError(err instanceof Error ? err.message : ADMIN_TEXT.EMPTY);
    } finally {
      setSaving(false);
    }
  };

  const submit = async (event: FormEvent) => {
    event.preventDefault();
    if (!form.category_id || !form.variant_id || !form.display_name.trim()) {
      setError(ADMIN_TEXT.REQUIRED);
      return;
    }
    setSaving(true);
    setError("");
    try {
      const selectedVariant = variants.find((variant) => variant.id === form.variant_id);
      const saleMode = buildSaleMode(form, selectedVariant);
      const payload: Partial<AdminMenuItem> = {
        category_id: form.category_id,
        variant_id: form.variant_id,
        display_name: form.display_name.trim(),
        description: optional(form.description),
        selling_price: numericOrZero(form.selling_price),
        images: csvToArray(form.images),
        videos: csvToArray(form.videos),
        status: form.status,
        sale_modes: saleMode ? [saleMode] : undefined,
      };
      if (editing) {
        await AdminApi.updateMenuItem(editing.id, payload);
      } else {
        await AdminApi.createMenuItem(payload);
      }
      reset();
      await load();
    } catch (err) {
      setError(err instanceof Error ? err.message : ADMIN_TEXT.EMPTY);
    } finally {
      setSaving(false);
    }
  };

  const remove = async (item: AdminMenuItem) => {
    if (!window.confirm(`${ADMIN_TEXT.DELETE} ${item.display_name}?`)) {
      return;
    }
    setSaving(true);
    setError("");
    try {
      await AdminApi.deleteMenuItem(item.id);
      await load();
    } catch (err) {
      setError(err instanceof Error ? err.message : ADMIN_TEXT.EMPTY);
    } finally {
      setSaving(false);
    }
  };

  return (
    <>
      <AdminPageHeader
        title={ADMIN_TEXT.MENU_ITEMS_TITLE}
        body={ADMIN_TEXT.MENU_ITEMS_BODY}
        action={<AdminRefreshButton onClick={load} disabled={loading || saving} />}
      />
      {error ? <AdminStateMessage message={error} tone="error" /> : null}
      <div className="grid gap-5 xl:grid-cols-[460px_minmax(0,1fr)]">
        <div className="grid gap-5">
          <AdminPanel title={editing ? ADMIN_TEXT.UPDATE : ADMIN_TEXT.CREATE}>
            <form className="grid gap-3" onSubmit={submit}>
              <AdminSelect label="Menu category" value={form.category_id} onChange={(value) => updateField("category_id", value)} options={categoryOptions} required />
              <AdminSelect label="Inventory variant" value={form.variant_id} onChange={(value) => updateField("variant_id", value)} options={variantOptions} required />
              <AdminField label="Display name" value={form.display_name} onChange={(value) => updateField("display_name", value)} required />
              <AdminTextarea label="Description" value={form.description} onChange={(value) => updateField("description", value)} />
              <div className="grid gap-3 sm:grid-cols-2">
                <AdminField label="Selling price" value={form.selling_price} onChange={(value) => updateField("selling_price", value)} type="number" required />
                <AdminSelect label="Status" value={form.status} onChange={(value) => updateField("status", value)} options={ADMIN_STATUS_OPTIONS} />
              </div>
              <AdminField label="Images" value={form.images} onChange={(value) => updateField("images", value)} placeholder="Comma separated URLs" />
              <AdminField label="Videos" value={form.videos} onChange={(value) => updateField("videos", value)} placeholder="Comma separated URLs" />
              <div className="rounded-[8px] border border-border-grey bg-[#FAFAFA] p-3">
                <p className="mb-3 text-[13px] font-semibold text-text-primary">{ADMIN_TEXT.SALE_MODE}</p>
                <div className="grid gap-3 sm:grid-cols-2">
                  <AdminSelect label="UOM" value={form.sale_uom_id} onChange={(value) => updateField("sale_uom_id", value)} options={uomOptions} />
                  <AdminField label="Label" value={form.sale_label} onChange={(value) => updateField("sale_label", value)} placeholder="Regular" />
                  <AdminField label="Price per unit" value={form.sale_price_per_unit} onChange={(value) => updateField("sale_price_per_unit", value)} type="number" />
                  <AdminField label="Min qty" value={form.sale_min_qty} onChange={(value) => updateField("sale_min_qty", value)} type="number" />
                  <AdminField label="Step qty" value={form.sale_step_qty} onChange={(value) => updateField("sale_step_qty", value)} type="number" />
                  <AdminToggle label="Allow decimal" checked={form.sale_allow_decimal} onChange={(value) => updateField("sale_allow_decimal", value)} />
                  <AdminToggle label={ADMIN_TEXT.DEFAULT} checked={form.sale_is_default} onChange={(value) => updateField("sale_is_default", value)} />
                </div>
              </div>
              <div className="flex flex-wrap gap-2 pt-2">
                <AdminButton type="submit" disabled={saving}>
                  <ListChecks size={15} />
                  {editing ? ADMIN_TEXT.UPDATE : ADMIN_TEXT.CREATE}
                </AdminButton>
                <AdminButton onClick={reset} variant="secondary" disabled={saving}>{ADMIN_TEXT.RESET}</AdminButton>
              </div>
            </form>
          </AdminPanel>
          <AdminPanel title="Menu category setup">
            <div className="grid gap-3">
              <AdminField label="Category name" value={categoryName} onChange={setCategoryName} />
              <AdminTextarea label="Category description" value={categoryDescription} onChange={setCategoryDescription} />
              <AdminButton onClick={() => void createCategory()} disabled={saving}>
                <Plus size={15} />
                {ADMIN_TEXT.CREATE}
              </AdminButton>
            </div>
          </AdminPanel>
        </div>
        <AdminPanel title={`${menuItems.length} ${ADMIN_TEXT.MENU_ITEMS_TITLE}`}>
          {loading ? <AdminStateMessage message={ADMIN_TEXT.LOADING} /> : null}
          {!loading && menuItems.length === 0 ? <AdminStateMessage message={ADMIN_TEXT.EMPTY} /> : null}
          <div className="grid gap-3 md:grid-cols-2">
            {menuItems.map((item) => {
              const category = menuCategories.find((entry) => entry.id === item.category_id);
              const variant = variants.find((entry) => entry.id === item.variant_id);
              const inventoryItem = inventoryItems.find((entry) => entry.id === variant?.item_id || entry.id === item.item_id);
              const images = item.images.length ? item.images : variant?.images?.length ? variant.images : category?.images;
              return (
                <article key={item.id} className="rounded-[8px] border border-border-grey bg-[#FAFAFA] p-4">
                  <div className="flex min-h-full flex-col">
                    <AdminImageStrip images={images} label={item.display_name} />
                    <div className="flex items-start justify-between gap-3">
                      <div className="min-w-0">
                        <h3 className="mt-3 truncate text-[16px] font-semibold text-text-primary">{item.display_name}</h3>
                        <p className="mt-1 text-[12px] font-medium text-text-secondary">{category?.name || item.category_id}</p>
                        <p className="mt-1 text-[12px] font-normal text-text-tertiary">{inventoryItem?.name || variant?.sku || item.variant_id}</p>
                      </div>
                      <span className="rounded-full bg-[#E8F5E9] px-2 py-1 text-[11px] font-semibold text-primary-green">{item.status}</span>
                    </div>
                    <p className="mt-4 text-[20px] font-semibold text-text-primary">₹{item.selling_price}</p>
                    <p className="mt-1 text-[12px] font-normal text-text-tertiary">{formatDate(item.created_at)}</p>
                    <div className="mt-4 flex flex-wrap gap-2">
                      <AdminButton onClick={() => edit(item)} variant="secondary" disabled={saving}>
                        <Pencil size={14} />
                        {ADMIN_TEXT.EDIT}
                      </AdminButton>
                      <AdminButton onClick={() => void remove(item)} variant="danger" disabled={saving}>
                        <Trash2 size={14} />
                        {ADMIN_TEXT.DELETE}
                      </AdminButton>
                    </div>
                  </div>
                </article>
              );
            })}
          </div>
        </AdminPanel>
      </div>
    </>
  );
};

const buildSaleMode = (form: MenuItemFormState, selectedVariant?: AdminItemVariant): AdminMenuItemSaleMode | undefined => {
  const uomId = form.sale_uom_id || selectedVariant?.uom_id;
  if (!uomId) {
    return undefined;
  }
  const price = form.sale_price_per_unit.trim() ? numericOrZero(form.sale_price_per_unit) : numericOrZero(form.selling_price);
  return {
    uom_id: uomId,
    label: optional(form.sale_label) || ADMIN_TEXT.DEFAULT,
    price_per_unit: price,
    min_qty: numericOrZero(form.sale_min_qty) || 1,
    step_qty: numericOrZero(form.sale_step_qty) || 1,
    allow_decimal: form.sale_allow_decimal,
    is_default: form.sale_is_default,
    sort_order: 0,
    status: form.status,
  };
};
