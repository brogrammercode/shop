"use client";

import { FormEvent, useEffect, useState } from "react";
import { Building2, Pencil, Trash2 } from "lucide-react";
import {
  AdminButton,
  AdminField,
  AdminPageHeader,
  AdminPanel,
  AdminRefreshButton,
  AdminSelect,
  AdminStateMessage,
  AdminToggle,
} from "../components/AdminPrimitives";
import { ADMIN_BRANCH_STATUS_OPTIONS, ADMIN_TEXT } from "../constants/admin.constants";
import { AdminApi } from "../services/admin.api";
import { AdminBranch } from "../types/admin.types";
import { formatDate, optional } from "../utils/admin.utils";

interface BranchFormState {
  name: string;
  is_hq: boolean;
  status: string;
  area: string;
  locality: string;
  city: string;
  state: string;
  country: string;
  pin_code: string;
}

const emptyForm: BranchFormState = {
  name: "",
  is_hq: false,
  status: ADMIN_TEXT.ACTIVE,
  area: "",
  locality: "",
  city: "",
  state: "",
  country: "India",
  pin_code: "",
};

export const AdminBranchesPage = () => {
  const [branches, setBranches] = useState<AdminBranch[]>([]);
  const [form, setForm] = useState<BranchFormState>(emptyForm);
  const [editing, setEditing] = useState<AdminBranch | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");

  const load = async () => {
    setLoading(true);
    setError("");
    try {
      setBranches(await AdminApi.listBranches());
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

  const updateField = <K extends keyof BranchFormState>(key: K, value: BranchFormState[K]) => {
    setForm((current) => ({ ...current, [key]: value }));
  };

  const reset = () => {
    setForm(emptyForm);
    setEditing(null);
  };

  const edit = (branch: AdminBranch) => {
    const address = branch.addresses?.[0];
    setEditing(branch);
    setForm({
      name: branch.name || "",
      is_hq: branch.is_hq,
      status: branch.status || ADMIN_TEXT.ACTIVE,
      area: address?.area || "",
      locality: address?.locality || "",
      city: address?.city || "",
      state: address?.state || "",
      country: address?.country || "India",
      pin_code: address?.pin_code || "",
    });
  };

  const submit = async (event: FormEvent) => {
    event.preventDefault();
    if (!form.name.trim()) {
      setError(ADMIN_TEXT.REQUIRED);
      return;
    }
    setSaving(true);
    setError("");
    try {
      const addresses = optional(form.area) || optional(form.city)
        ? [{
            area: optional(form.area),
            locality: optional(form.locality),
            city: optional(form.city),
            state: optional(form.state),
            country: optional(form.country),
            pin_code: optional(form.pin_code),
          }]
        : [];
      const payload = {
        name: form.name.trim(),
        is_hq: form.is_hq,
        status: form.status,
        addresses,
      };
      if (editing) {
        await AdminApi.updateBranch(editing.id, payload);
      } else {
        await AdminApi.createBranch(payload);
      }
      reset();
      await load();
    } catch (err) {
      setError(err instanceof Error ? err.message : ADMIN_TEXT.EMPTY);
    } finally {
      setSaving(false);
    }
  };

  const remove = async (branch: AdminBranch) => {
    if (!window.confirm(`${ADMIN_TEXT.DELETE} ${branch.name}?`)) {
      return;
    }
    setSaving(true);
    setError("");
    try {
      await AdminApi.deleteBranch(branch.id);
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
        title={ADMIN_TEXT.BRANCHES_TITLE}
        body={ADMIN_TEXT.BRANCHES_BODY}
        action={<AdminRefreshButton onClick={load} disabled={loading || saving} />}
      />
      {error ? <AdminStateMessage message={error} tone="error" /> : null}
      <div className="grid gap-5 xl:grid-cols-[420px_minmax(0,1fr)]">
        <AdminPanel title={editing ? ADMIN_TEXT.UPDATE : ADMIN_TEXT.CREATE}>
          <form className="grid gap-3" onSubmit={submit}>
            <AdminField label="Branch name" value={form.name} onChange={(value) => updateField("name", value)} required />
            <AdminSelect label="Status" value={form.status} onChange={(value) => updateField("status", value)} options={ADMIN_BRANCH_STATUS_OPTIONS} />
            <AdminToggle label="Headquarters" checked={form.is_hq} onChange={(value) => updateField("is_hq", value)} />
            <div className="grid gap-3 sm:grid-cols-2">
              <AdminField label="Area" value={form.area} onChange={(value) => updateField("area", value)} />
              <AdminField label="Locality" value={form.locality} onChange={(value) => updateField("locality", value)} />
              <AdminField label="City" value={form.city} onChange={(value) => updateField("city", value)} />
              <AdminField label="State" value={form.state} onChange={(value) => updateField("state", value)} />
              <AdminField label="Country" value={form.country} onChange={(value) => updateField("country", value)} />
              <AdminField label="Pin code" value={form.pin_code} onChange={(value) => updateField("pin_code", value)} />
            </div>
            <div className="flex flex-wrap gap-2 pt-2">
              <AdminButton type="submit" disabled={saving}>
                <Building2 size={15} />
                {editing ? ADMIN_TEXT.UPDATE : ADMIN_TEXT.CREATE}
              </AdminButton>
              <AdminButton onClick={reset} variant="secondary" disabled={saving}>{ADMIN_TEXT.RESET}</AdminButton>
            </div>
          </form>
        </AdminPanel>
        <AdminPanel title={`${branches.length} ${ADMIN_TEXT.BRANCHES_TITLE}`}>
          {loading ? <AdminStateMessage message={ADMIN_TEXT.LOADING} /> : null}
          {!loading && branches.length === 0 ? <AdminStateMessage message={ADMIN_TEXT.EMPTY} /> : null}
          <div className="grid gap-3">
            {branches.map((branch) => {
              const address = branch.addresses?.[0];
              const addressLine = [address?.area, address?.locality, address?.city, address?.state, address?.pin_code].filter(Boolean).join(", ");
              return (
                <article key={branch.id} className="rounded-[8px] border border-border-grey bg-[#FAFAFA] p-4">
                  <div className="flex flex-col gap-4 md:flex-row md:items-start md:justify-between">
                    <div className="min-w-0">
                      <div className="flex flex-wrap items-center gap-2">
                        <h3 className="truncate text-[16px] font-semibold text-text-primary">{branch.name}</h3>
                        <span className="rounded-full bg-[#E8F5E9] px-2 py-1 text-[11px] font-semibold text-primary-green">{branch.status}</span>
                        {branch.is_hq ? <span className="rounded-full bg-[#FFF9E6] px-2 py-1 text-[11px] font-semibold text-gold-dark">HQ</span> : null}
                      </div>
                      <p className="mt-1 text-[13px] font-medium text-text-secondary">{branch.code}</p>
                      <p className="mt-2 text-[13px] font-normal text-text-secondary">{addressLine || "-"}</p>
                      <p className="mt-2 text-[12px] font-normal text-text-tertiary">{formatDate(branch.created_at)}</p>
                    </div>
                    <div className="flex shrink-0 gap-2">
                      <AdminButton onClick={() => edit(branch)} variant="secondary" disabled={saving}>
                        <Pencil size={14} />
                        {ADMIN_TEXT.EDIT}
                      </AdminButton>
                      <AdminButton onClick={() => void remove(branch)} variant="danger" disabled={saving}>
                        <Trash2 size={14} />
                        {ADMIN_TEXT.DELETE}
                      </AdminButton>
                    </div>
                  </div>
                  <div className="mt-4 grid gap-2 text-[12px] sm:grid-cols-3">
                    <Info label={ADMIN_TEXT.OWNER} value={branch.owner?.name || branch.owner?.phone || "-"} />
                    <Info label={ADMIN_TEXT.EMPLOYEES} value={String(branch.employee_count || 0)} />
                    <Info label="Updated" value={formatDate(branch.updated_at)} />
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

const Info = ({ label, value }: { label: string; value: string }) => (
  <p className="rounded-[8px] bg-pure-white px-3 py-2 text-[12px]">
    <span className="font-medium text-text-tertiary">{label}: </span>
    <span className="font-medium text-text-primary">{value}</span>
  </p>
);
