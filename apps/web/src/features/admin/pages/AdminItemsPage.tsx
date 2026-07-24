"use client";

import { FormEvent, useEffect, useMemo, useState } from "react";
import { Boxes, Pencil, Plus, Trash2 } from "lucide-react";
import {
  AdminButton,
  AdminField,
  AdminImageStrip,
  AdminImageThumb,
  AdminPageHeader,
  AdminPanel,
  AdminRefreshButton,
  AdminSelect,
  AdminStateMessage,
  AdminTextarea,
} from "../components/AdminPrimitives";
import { ADMIN_ITEM_TYPE_OPTIONS, ADMIN_STATUS_OPTIONS, ADMIN_TEXT } from "../constants/admin.constants";
import { AdminApi } from "../services/admin.api";
import { AdminItem, AdminItemCategory, AdminItemVariant, AdminUom } from "../types/admin.types";
import { arrayToCsv, csvToArray, formatDate, numericOrUndefined, numericOrZero, optional } from "../utils/admin.utils";

interface ItemFormState {
  category_id: string;
  name: string;
  description: string;
  images: string;
  item_type: string;
  shelf_life_days: string;
  status: string;
}

interface VariantFormState {
  uom_id: string;
  name: string;
  sku: string;
  barcode: string;
  images: string;
  base_cost: string;
  min_stock_lvl: string;
  status: string;
}

const emptyItemForm: ItemFormState = {
  category_id: "",
  name: "",
  description: "",
  images: "",
  item_type: ADMIN_TEXT.FINISHED_GOOD,
  shelf_life_days: "",
  status: ADMIN_TEXT.ACTIVE,
};

const emptyVariantForm: VariantFormState = {
  uom_id: "",
  name: "",
  sku: "",
  barcode: "",
  images: "",
  base_cost: "0",
  min_stock_lvl: "0",
  status: ADMIN_TEXT.ACTIVE,
};

export const AdminItemsPage = () => {
  const [items, setItems] = useState<AdminItem[]>([]);
  const [categories, setCategories] = useState<AdminItemCategory[]>([]);
  const [uoms, setUoms] = useState<AdminUom[]>([]);
  const [variants, setVariants] = useState<AdminItemVariant[]>([]);
  const [itemForm, setItemForm] = useState<ItemFormState>(emptyItemForm);
  const [variantForm, setVariantForm] = useState<VariantFormState>(emptyVariantForm);
  const [categoryName, setCategoryName] = useState("");
  const [uomCode, setUomCode] = useState("");
  const [uomDescription, setUomDescription] = useState("");
  const [selectedItemId, setSelectedItemId] = useState("");
  const [editingItem, setEditingItem] = useState<AdminItem | null>(null);
  const [editingVariant, setEditingVariant] = useState<AdminItemVariant | null>(null);
  const [loading, setLoading] = useState(true);
  const [variantLoading, setVariantLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");

  const selectedItem = useMemo(() => items.find((item) => item.id === selectedItemId), [items, selectedItemId]);
  const categoryOptions = useMemo(() => [{ value: "", label: "Select category" }, ...categories.map((category) => ({ value: category.id, label: category.name }))], [categories]);
  const uomOptions = useMemo(() => [{ value: "", label: "Select UOM" }, ...uoms.map((uom) => ({ value: uom.id, label: `${uom.code}${uom.description ? ` - ${uom.description}` : ""}` }))], [uoms]);

  const load = async () => {
    setLoading(true);
    setError("");
    try {
      const [nextItems, nextCategories, nextUoms] = await Promise.all([
        AdminApi.listItems(),
        AdminApi.listItemCategories(),
        AdminApi.listUom(),
      ]);
      setItems(nextItems);
      setCategories(nextCategories);
      setUoms(nextUoms);
      setSelectedItemId((current) => current && nextItems.some((item) => item.id === current) ? current : nextItems[0]?.id || "");
      setItemForm((current) => ({ ...current, category_id: current.category_id || nextCategories[0]?.id || "" }));
      setVariantForm((current) => ({ ...current, uom_id: current.uom_id || nextUoms[0]?.id || "" }));
    } catch (err) {
      setError(err instanceof Error ? err.message : ADMIN_TEXT.EMPTY);
    } finally {
      setLoading(false);
    }
  };

  const loadVariants = async (itemId: string) => {
    if (!itemId) {
      setVariants([]);
      return;
    }
    setVariantLoading(true);
    setError("");
    try {
      setVariants(await AdminApi.listVariants(itemId));
    } catch (err) {
      setError(err instanceof Error ? err.message : ADMIN_TEXT.EMPTY);
    } finally {
      setVariantLoading(false);
    }
  };

  useEffect(() => {
    const timer = window.setTimeout(() => {
      void load();
    }, 0);
    return () => window.clearTimeout(timer);
  }, []);

  useEffect(() => {
    const timer = window.setTimeout(() => {
      void loadVariants(selectedItemId);
    }, 0);
    return () => window.clearTimeout(timer);
  }, [selectedItemId]);

  const updateItemField = (key: keyof ItemFormState, value: string) => {
    setItemForm((current) => ({ ...current, [key]: value }));
  };

  const updateVariantField = (key: keyof VariantFormState, value: string) => {
    setVariantForm((current) => ({ ...current, [key]: value }));
  };

  const resetItem = () => {
    setEditingItem(null);
    setItemForm({ ...emptyItemForm, category_id: categories[0]?.id || "" });
  };

  const resetVariant = () => {
    setEditingVariant(null);
    setVariantForm({ ...emptyVariantForm, uom_id: uoms[0]?.id || "" });
  };

  const editItem = (item: AdminItem) => {
    setEditingItem(item);
    setItemForm({
      category_id: item.category_id,
      name: item.name || "",
      description: item.description || "",
      images: arrayToCsv(item.images),
      item_type: item.item_type || ADMIN_TEXT.FINISHED_GOOD,
      shelf_life_days: item.shelf_life_days?.toString() || "",
      status: item.status || ADMIN_TEXT.ACTIVE,
    });
  };

  const editVariant = (variant: AdminItemVariant) => {
    setEditingVariant(variant);
    setVariantForm({
      uom_id: variant.uom_id,
      name: variant.name || "",
      sku: variant.sku || "",
      barcode: variant.barcode || "",
      images: arrayToCsv(variant.images),
      base_cost: String(variant.base_cost ?? 0),
      min_stock_lvl: String(variant.min_stock_lvl ?? 0),
      status: variant.status || ADMIN_TEXT.ACTIVE,
    });
  };

  const submitItem = async (event: FormEvent) => {
    event.preventDefault();
    if (!itemForm.name.trim() || !itemForm.category_id) {
      setError(ADMIN_TEXT.REQUIRED);
      return;
    }
    setSaving(true);
    setError("");
    try {
      const payload = {
        category_id: itemForm.category_id,
        name: itemForm.name.trim(),
        description: optional(itemForm.description),
        images: csvToArray(itemForm.images),
        item_type: itemForm.item_type,
        shelf_life_days: numericOrUndefined(itemForm.shelf_life_days),
        status: itemForm.status,
      };
      if (editingItem) {
        await AdminApi.updateItem(editingItem.id, payload);
      } else {
        await AdminApi.createItem(payload);
      }
      resetItem();
      await load();
    } catch (err) {
      setError(err instanceof Error ? err.message : ADMIN_TEXT.EMPTY);
    } finally {
      setSaving(false);
    }
  };

  const submitVariant = async (event: FormEvent) => {
    event.preventDefault();
    if (!selectedItemId || !variantForm.uom_id) {
      setError(ADMIN_TEXT.REQUIRED);
      return;
    }
    setSaving(true);
    setError("");
    try {
      const payload = {
        uom_id: variantForm.uom_id,
        name: optional(variantForm.name),
        sku: optional(variantForm.sku),
        barcode: optional(variantForm.barcode),
        images: csvToArray(variantForm.images),
        base_cost: numericOrZero(variantForm.base_cost),
        min_stock_lvl: numericOrZero(variantForm.min_stock_lvl),
        status: variantForm.status,
      };
      if (editingVariant) {
        await AdminApi.updateVariant(editingVariant.id, payload);
      } else {
        await AdminApi.createVariant(selectedItemId, payload);
      }
      resetVariant();
      await loadVariants(selectedItemId);
    } catch (err) {
      setError(err instanceof Error ? err.message : ADMIN_TEXT.EMPTY);
    } finally {
      setSaving(false);
    }
  };

  const createCategory = async () => {
    if (!categoryName.trim()) {
      setError(ADMIN_TEXT.REQUIRED);
      return;
    }
    setSaving(true);
    setError("");
    try {
      await AdminApi.createItemCategory({ name: categoryName.trim() });
      setCategoryName("");
      await load();
    } catch (err) {
      setError(err instanceof Error ? err.message : ADMIN_TEXT.EMPTY);
    } finally {
      setSaving(false);
    }
  };

  const createUom = async () => {
    if (!uomCode.trim()) {
      setError(ADMIN_TEXT.REQUIRED);
      return;
    }
    setSaving(true);
    setError("");
    try {
      await AdminApi.createUom({ code: uomCode.trim().toUpperCase(), description: optional(uomDescription) });
      setUomCode("");
      setUomDescription("");
      await load();
    } catch (err) {
      setError(err instanceof Error ? err.message : ADMIN_TEXT.EMPTY);
    } finally {
      setSaving(false);
    }
  };

  const deleteItem = async (item: AdminItem) => {
    if (!window.confirm(`${ADMIN_TEXT.DELETE} ${item.name}?`)) {
      return;
    }
    setSaving(true);
    setError("");
    try {
      await AdminApi.deleteItem(item.id);
      await load();
    } catch (err) {
      setError(err instanceof Error ? err.message : ADMIN_TEXT.EMPTY);
    } finally {
      setSaving(false);
    }
  };

  const deleteVariant = async (variant: AdminItemVariant) => {
    if (!window.confirm(`${ADMIN_TEXT.DELETE} ${variant.name || variant.sku}?`)) {
      return;
    }
    setSaving(true);
    setError("");
    try {
      await AdminApi.deleteVariant(variant.id);
      await loadVariants(selectedItemId);
    } catch (err) {
      setError(err instanceof Error ? err.message : ADMIN_TEXT.EMPTY);
    } finally {
      setSaving(false);
    }
  };

  return (
    <>
      <AdminPageHeader
        title={ADMIN_TEXT.ITEMS_TITLE}
        body={ADMIN_TEXT.ITEMS_BODY}
        action={<AdminRefreshButton onClick={load} disabled={loading || saving} />}
      />
      {error ? <AdminStateMessage message={error} tone="error" /> : null}
      <div className="grid gap-5 xl:grid-cols-[420px_minmax(0,1fr)]">
        <div className="grid gap-5">
          <AdminPanel title={editingItem ? ADMIN_TEXT.UPDATE : ADMIN_TEXT.CREATE}>
            <form className="grid gap-3" onSubmit={submitItem}>
              <AdminSelect label="Category" value={itemForm.category_id} onChange={(value) => updateItemField("category_id", value)} options={categoryOptions} required />
              <AdminField label="Name" value={itemForm.name} onChange={(value) => updateItemField("name", value)} required />
              <AdminTextarea label="Description" value={itemForm.description} onChange={(value) => updateItemField("description", value)} />
              <AdminField label="Images" value={itemForm.images} onChange={(value) => updateItemField("images", value)} placeholder="Comma separated URLs" />
              <div className="grid gap-3 sm:grid-cols-2">
                <AdminSelect label="Item type" value={itemForm.item_type} onChange={(value) => updateItemField("item_type", value)} options={ADMIN_ITEM_TYPE_OPTIONS} />
                <AdminField label="Shelf life days" value={itemForm.shelf_life_days} onChange={(value) => updateItemField("shelf_life_days", value)} type="number" />
              </div>
              <AdminSelect label="Status" value={itemForm.status} onChange={(value) => updateItemField("status", value)} options={ADMIN_STATUS_OPTIONS} />
              <div className="flex flex-wrap gap-2 pt-2">
                <AdminButton type="submit" disabled={saving}>
                  <Boxes size={15} />
                  {editingItem ? ADMIN_TEXT.UPDATE : ADMIN_TEXT.CREATE}
                </AdminButton>
                <AdminButton onClick={resetItem} variant="secondary" disabled={saving}>{ADMIN_TEXT.RESET}</AdminButton>
              </div>
            </form>
          </AdminPanel>
          <AdminPanel title="Setup">
            <div className="grid gap-3">
              <AdminField label="New item category" value={categoryName} onChange={setCategoryName} />
              <AdminButton onClick={() => void createCategory()} disabled={saving}>
                <Plus size={15} />
                {ADMIN_TEXT.CREATE}
              </AdminButton>
              <div className="h-px bg-border-grey" />
              <div className="grid gap-3 sm:grid-cols-2">
                <AdminField label="UOM code" value={uomCode} onChange={setUomCode} />
                <AdminField label="UOM description" value={uomDescription} onChange={setUomDescription} />
              </div>
              <AdminButton onClick={() => void createUom()} disabled={saving}>
                <Plus size={15} />
                {ADMIN_TEXT.CREATE}
              </AdminButton>
            </div>
          </AdminPanel>
        </div>
        <div className="grid gap-5">
          <AdminPanel title={`${items.length} ${ADMIN_TEXT.ITEMS_TITLE}`}>
            {loading ? <AdminStateMessage message={ADMIN_TEXT.LOADING} /> : null}
            {!loading && items.length === 0 ? <AdminStateMessage message={ADMIN_TEXT.EMPTY} /> : null}
            <div className="grid gap-3 md:grid-cols-2">
              {items.map((item) => {
                const category = categories.find((entry) => entry.id === item.category_id);
                return (
                  <article
                    key={item.id}
                    onClick={() => setSelectedItemId(item.id)}
                    className={`cursor-pointer rounded-[8px] border p-4 transition-colors ${
                      selectedItemId === item.id ? "border-primary-green bg-[#F0FDF4]" : "border-border-grey bg-[#FAFAFA] hover:border-primary-green/40"
                    }`}
                  >
                    <AdminImageStrip images={item.images.length ? item.images : category?.images} label={item.name} />
                    <div className="flex items-start justify-between gap-3">
                      <div className="min-w-0">
                        <h3 className="mt-3 truncate text-[15px] font-semibold text-text-primary">{item.name}</h3>
                        <p className="mt-1 text-[12px] font-medium text-text-secondary">{item.item_type}</p>
                        <p className="mt-2 text-[12px] font-normal text-text-tertiary">{formatDate(item.created_at)}</p>
                      </div>
                      <span className="rounded-full bg-pure-white px-2 py-1 text-[11px] font-semibold text-primary-green">{item.status}</span>
                    </div>
                    <div className="mt-4 flex flex-wrap gap-2">
                      <AdminButton onClick={() => editItem(item)} variant="secondary" disabled={saving}>
                        <Pencil size={14} />
                        {ADMIN_TEXT.EDIT}
                      </AdminButton>
                      <AdminButton onClick={() => void deleteItem(item)} variant="danger" disabled={saving}>
                        <Trash2 size={14} />
                        {ADMIN_TEXT.DELETE}
                      </AdminButton>
                    </div>
                  </article>
                );
              })}
            </div>
          </AdminPanel>
          <AdminPanel title={selectedItem ? `${selectedItem.name} variants` : "Variants"}>
            <form className="mb-4 grid gap-3 rounded-[8px] border border-border-grey bg-[#FAFAFA] p-3" onSubmit={submitVariant}>
              <AdminSelect label="UOM" value={variantForm.uom_id} onChange={(value) => updateVariantField("uom_id", value)} options={uomOptions} required />
              <div className="grid gap-3 sm:grid-cols-2">
                <AdminField label="Variant name" value={variantForm.name} onChange={(value) => updateVariantField("name", value)} />
                <AdminField label="SKU" value={variantForm.sku} onChange={(value) => updateVariantField("sku", value)} placeholder={ADMIN_TEXT.AUTO_GENERATED} />
                <AdminField label="Barcode" value={variantForm.barcode} onChange={(value) => updateVariantField("barcode", value)} placeholder={ADMIN_TEXT.AUTO_GENERATED} />
                <AdminField label="Images" value={variantForm.images} onChange={(value) => updateVariantField("images", value)} placeholder="Comma separated URLs" />
                <AdminField label="Base cost" value={variantForm.base_cost} onChange={(value) => updateVariantField("base_cost", value)} type="number" />
                <AdminField label="Min stock" value={variantForm.min_stock_lvl} onChange={(value) => updateVariantField("min_stock_lvl", value)} type="number" />
              </div>
              <AdminSelect label="Status" value={variantForm.status} onChange={(value) => updateVariantField("status", value)} options={ADMIN_STATUS_OPTIONS} />
              <div className="flex flex-wrap gap-2">
                <AdminButton type="submit" disabled={saving || !selectedItemId}>
                  <Plus size={15} />
                  {editingVariant ? ADMIN_TEXT.UPDATE : ADMIN_TEXT.CREATE}
                </AdminButton>
                <AdminButton onClick={resetVariant} variant="secondary" disabled={saving}>{ADMIN_TEXT.RESET}</AdminButton>
              </div>
            </form>
            {variantLoading ? <AdminStateMessage message={ADMIN_TEXT.LOADING} /> : null}
            {!variantLoading && selectedItemId && variants.length === 0 ? <AdminStateMessage message={ADMIN_TEXT.EMPTY} /> : null}
            <div className="grid gap-3">
              {variants.map((variant) => (
                <article key={variant.id} className="rounded-[8px] border border-border-grey bg-pure-white p-3">
                  <div className="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
                    <div className="flex min-w-0 items-center gap-3">
                      <AdminImageThumb src={variant.images?.[0]} label={variant.name || variant.sku} />
                      <div className="min-w-0">
                        <h3 className="truncate text-[14px] font-semibold text-text-primary">{variant.name || variant.sku}</h3>
                        <p className="mt-1 text-[12px] font-medium text-text-secondary">{variant.uom?.code || variant.uom_id} · ₹{variant.base_cost}</p>
                        <p className="mt-1 truncate text-[11px] font-normal text-text-tertiary">{variant.sku}</p>
                      </div>
                    </div>
                    <div className="flex flex-wrap gap-2">
                      <AdminButton onClick={() => editVariant(variant)} variant="secondary" disabled={saving}>
                        <Pencil size={14} />
                        {ADMIN_TEXT.EDIT}
                      </AdminButton>
                      <AdminButton onClick={() => void deleteVariant(variant)} variant="danger" disabled={saving}>
                        <Trash2 size={14} />
                        {ADMIN_TEXT.DELETE}
                      </AdminButton>
                    </div>
                  </div>
                </article>
              ))}
            </div>
          </AdminPanel>
        </div>
      </div>
    </>
  );
};
