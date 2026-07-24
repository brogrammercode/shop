"use client";

import { FormEvent, useEffect, useMemo, useState } from "react";
import { Pencil, Plus, Trash2 } from "lucide-react";
import {
  AdminButton,
  AdminField,
  AdminImageThumb,
  AdminPageHeader,
  AdminPanel,
  AdminRefreshButton,
  AdminSelect,
  AdminStateMessage,
} from "../components/AdminPrimitives";
import { ADMIN_STATUS_OPTIONS, ADMIN_TEXT } from "../constants/admin.constants";
import { AdminApi } from "../services/admin.api";
import { AdminUser } from "../types/admin.types";
import { formatDate, nullable, optional } from "../utils/admin.utils";

interface UserFormState {
  name: string;
  phone: string;
  email: string;
  avatar: string;
  status: string;
}

const emptyForm: UserFormState = {
  name: "",
  phone: "",
  email: "",
  avatar: "",
  status: ADMIN_TEXT.ACTIVE,
};

export const AdminUsersPage = () => {
  const [users, setUsers] = useState<AdminUser[]>([]);
  const [form, setForm] = useState<UserFormState>(emptyForm);
  const [editing, setEditing] = useState<AdminUser | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");

  const employeeUsers = useMemo(() => users.filter((user) => user.employee).length, [users]);

  const load = async () => {
    setLoading(true);
    setError("");
    try {
      setUsers(await AdminApi.listUsers());
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

  const updateField = (key: keyof UserFormState, value: string) => {
    setForm((current) => ({ ...current, [key]: value }));
  };

  const reset = () => {
    setForm(emptyForm);
    setEditing(null);
  };

  const edit = (user: AdminUser) => {
    setEditing(user);
    setForm({
      name: user.name || "",
      phone: user.phone || "",
      email: user.email || "",
      avatar: user.avatar || "",
      status: user.status || ADMIN_TEXT.ACTIVE,
    });
  };

  const submit = async (event: FormEvent) => {
    event.preventDefault();
    if (!form.name.trim() || !form.phone.trim()) {
      setError(ADMIN_TEXT.REQUIRED);
      return;
    }
    setSaving(true);
    setError("");
    try {
      const payload = {
        name: form.name.trim(),
        phone: form.phone.trim(),
        email: nullable(form.email),
        avatar: nullable(form.avatar),
        status: form.status,
      };
      if (editing) {
        await AdminApi.updateUser(editing.id, payload);
      } else {
        await AdminApi.createUser(payload);
      }
      reset();
      await load();
    } catch (err) {
      setError(err instanceof Error ? err.message : ADMIN_TEXT.EMPTY);
    } finally {
      setSaving(false);
    }
  };

  const remove = async (user: AdminUser) => {
    if (!window.confirm(`${ADMIN_TEXT.DELETE} ${user.name || user.phone}?`)) {
      return;
    }
    setSaving(true);
    setError("");
    try {
      await AdminApi.deleteUser(user.id);
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
        title={ADMIN_TEXT.USERS_TITLE}
        body={ADMIN_TEXT.USERS_BODY}
        action={<AdminRefreshButton onClick={load} disabled={loading || saving} />}
      />
      {error ? <AdminStateMessage message={error} tone="error" /> : null}
      <div className="grid gap-5 xl:grid-cols-[420px_minmax(0,1fr)]">
        <AdminPanel title={editing ? ADMIN_TEXT.UPDATE : ADMIN_TEXT.CREATE}>
          <form className="grid gap-3" onSubmit={submit}>
            <AdminField label="Name" value={form.name} onChange={(value) => updateField("name", value)} required />
            <AdminField label="Phone" value={form.phone} onChange={(value) => updateField("phone", value)} required />
            <AdminField label="Email" value={form.email} onChange={(value) => updateField("email", value)} />
            <AdminField label="Avatar URL" value={form.avatar} onChange={(value) => updateField("avatar", value)} />
            <AdminSelect label="Status" value={form.status} onChange={(value) => updateField("status", value)} options={ADMIN_STATUS_OPTIONS} />
            <div className="flex flex-wrap gap-2 pt-2">
              <AdminButton type="submit" disabled={saving}>
                <Plus size={15} />
                {editing ? ADMIN_TEXT.UPDATE : ADMIN_TEXT.CREATE}
              </AdminButton>
              <AdminButton onClick={reset} variant="secondary" disabled={saving}>
                {ADMIN_TEXT.RESET}
              </AdminButton>
            </div>
          </form>
        </AdminPanel>
        <AdminPanel title={`${users.length} ${ADMIN_TEXT.USERS_TITLE}`}>
          <div className="mb-4 grid gap-3 sm:grid-cols-3">
            <Metric label="Total" value={users.length} />
            <Metric label="Employees" value={employeeUsers} />
            <Metric label="Customers" value={users.length - employeeUsers} />
          </div>
          {loading ? <AdminStateMessage message={ADMIN_TEXT.LOADING} /> : null}
          {!loading && users.length === 0 ? <AdminStateMessage message={ADMIN_TEXT.EMPTY} /> : null}
          <div className="grid gap-3">
            {users.map((user) => (
              <article key={user.id} className="rounded-[8px] border border-border-grey bg-[#FAFAFA] p-4">
                <div className="flex flex-col gap-4 md:flex-row md:items-start md:justify-between">
                  <div className="flex min-w-0 gap-3">
                    <AdminImageThumb src={user.avatar} label={user.name || user.phone} className="h-[68px] w-[68px] rounded-full" />
                    <div className="min-w-0">
                      <div className="flex flex-wrap items-center gap-2">
                        <h3 className="truncate text-[16px] font-semibold text-text-primary">{user.name || user.phone}</h3>
                        <span className="rounded-full bg-[#E8F5E9] px-2 py-1 text-[11px] font-semibold text-primary-green">{user.status}</span>
                      </div>
                      <p className="mt-1 text-[13px] font-normal text-text-secondary">{user.phone}</p>
                      {optional(user.email || "") ? <p className="text-[13px] font-normal text-text-secondary">{user.email}</p> : null}
                      <p className="mt-2 text-[12px] font-normal text-text-tertiary">{formatDate(user.created_at)}</p>
                    </div>
                  </div>
                  <div className="flex shrink-0 gap-2">
                    <AdminButton onClick={() => edit(user)} variant="secondary" disabled={saving}>
                      <Pencil size={14} />
                      {ADMIN_TEXT.EDIT}
                    </AdminButton>
                    <AdminButton onClick={() => void remove(user)} variant="danger" disabled={saving}>
                      <Trash2 size={14} />
                      {ADMIN_TEXT.DELETE}
                    </AdminButton>
                  </div>
                </div>
                <div className="mt-4 grid gap-2 text-[12px] text-text-secondary sm:grid-cols-3">
                  <Info label="Branch" value={user.employee_branch_name || "-"} />
                  <Info label="Role" value={user.employee_role_name || "-"} />
                  <Info label={ADMIN_TEXT.COUNTS} value={`${user.order_count || 0} orders, ${user.session_count || 0} sessions`} />
                </div>
              </article>
            ))}
          </div>
        </AdminPanel>
      </div>
    </>
  );
};

const Metric = ({ label, value }: { label: string; value: number }) => (
  <div className="rounded-[8px] border border-border-grey bg-pure-white px-3 py-3">
    <p className="text-[11px] font-medium text-text-tertiary">{label}</p>
    <p className="mt-1 text-[22px] font-semibold text-text-primary">{value}</p>
  </div>
);

const Info = ({ label, value }: { label: string; value: string }) => (
  <p className="rounded-[8px] bg-pure-white px-3 py-2">
    <span className="font-medium text-text-tertiary">{label}: </span>
    <span className="font-medium text-text-primary">{value}</span>
  </p>
);
