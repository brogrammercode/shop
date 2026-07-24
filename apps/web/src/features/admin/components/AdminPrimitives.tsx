import { AlertCircle, RefreshCw } from "lucide-react";
import { ADMIN_TEXT } from "../constants/admin.constants";

interface AdminPageHeaderProps {
  title: string;
  body: string;
  action?: React.ReactNode;
}

interface AdminPanelProps {
  title: string;
  children: React.ReactNode;
  action?: React.ReactNode;
}

interface AdminFieldProps {
  label: string;
  value: string;
  onChange: (value: string) => void;
  type?: string;
  required?: boolean;
  placeholder?: string;
}

interface AdminSelectProps {
  label: string;
  value: string;
  onChange: (value: string) => void;
  options: readonly string[] | { value: string; label: string }[];
  required?: boolean;
}

interface AdminToggleProps {
  label: string;
  checked: boolean;
  onChange: (value: boolean) => void;
}

interface AdminTextareaProps {
  label: string;
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
}

export const AdminPageHeader = ({ title, body, action }: AdminPageHeaderProps) => (
  <header className="flex flex-col gap-4 rounded-[8px] border border-border-grey bg-pure-white px-5 py-5 shadow-sm md:flex-row md:items-center md:justify-between">
    <div>
      <h1 className="text-[24px] font-semibold leading-tight text-text-primary">{title}</h1>
      <p className="mt-1 max-w-[760px] text-[14px] font-normal leading-relaxed text-text-secondary">{body}</p>
    </div>
    {action}
  </header>
);

export const AdminPanel = ({ title, children, action }: AdminPanelProps) => (
  <section className="rounded-[8px] border border-border-grey bg-pure-white shadow-sm">
    <div className="flex min-h-14 items-center justify-between gap-3 border-b border-border-grey px-4 py-3">
      <h2 className="text-[15px] font-semibold text-text-primary">{title}</h2>
      {action}
    </div>
    <div className="p-4">{children}</div>
  </section>
);

export const AdminField = ({ label, value, onChange, type = "text", required, placeholder }: AdminFieldProps) => (
  <label className="flex flex-col gap-1.5">
    <span className="text-[12px] font-medium text-text-secondary">
      {label}
      {required ? <span className="text-primary-green"> *</span> : null}
    </span>
    <input
      type={type}
      value={value}
      onChange={(event) => onChange(event.target.value)}
      placeholder={placeholder}
      className="h-11 rounded-[8px] border border-border-grey bg-pure-white px-3 text-[14px] font-normal text-text-primary outline-none transition-colors placeholder:text-text-tertiary focus:border-primary-green"
    />
  </label>
);

export const AdminTextarea = ({ label, value, onChange, placeholder }: AdminTextareaProps) => (
  <label className="flex flex-col gap-1.5">
    <span className="text-[12px] font-medium text-text-secondary">{label}</span>
    <textarea
      value={value}
      onChange={(event) => onChange(event.target.value)}
      placeholder={placeholder}
      rows={3}
      className="resize-none rounded-[8px] border border-border-grey bg-pure-white px-3 py-2 text-[14px] font-normal text-text-primary outline-none transition-colors placeholder:text-text-tertiary focus:border-primary-green"
    />
  </label>
);

export const AdminSelect = ({ label, value, onChange, options, required }: AdminSelectProps) => (
  <label className="flex flex-col gap-1.5">
    <span className="text-[12px] font-medium text-text-secondary">
      {label}
      {required ? <span className="text-primary-green"> *</span> : null}
    </span>
    <select
      value={value}
      onChange={(event) => onChange(event.target.value)}
      className="h-11 rounded-[8px] border border-border-grey bg-pure-white px-3 text-[14px] font-normal text-text-primary outline-none transition-colors focus:border-primary-green"
    >
      {options.map((option) => {
        const item = typeof option === "string" ? { value: option, label: option } : option;
        return (
          <option key={item.value} value={item.value}>
            {item.label}
          </option>
        );
      })}
    </select>
  </label>
);

export const AdminToggle = ({ label, checked, onChange }: AdminToggleProps) => (
  <label className="flex h-11 items-center justify-between rounded-[8px] border border-border-grey bg-pure-white px-3">
    <span className="text-[13px] font-medium text-text-secondary">{label}</span>
    <input
      type="checkbox"
      checked={checked}
      onChange={(event) => onChange(event.target.checked)}
      className="h-4 w-4 accent-primary-green"
    />
  </label>
);

export const AdminButton = ({
  children,
  onClick,
  type = "button",
  variant = "primary",
  disabled,
}: {
  children: React.ReactNode;
  onClick?: () => void;
  type?: "button" | "submit";
  variant?: "primary" | "secondary" | "danger";
  disabled?: boolean;
}) => {
  const classes = {
    primary: "bg-primary-green text-pure-white shadow-sm hover:bg-[#0B6F39]",
    secondary: "border border-border-grey bg-pure-white text-text-primary hover:bg-soft-grey",
    danger: "bg-[#EF4444] text-pure-white hover:bg-[#DC2626]",
  }[variant];

  return (
    <button
      type={type}
      onClick={onClick}
      disabled={disabled}
      className={`inline-flex h-10 items-center justify-center gap-2 rounded-[8px] px-4 text-[13px] font-semibold transition-colors disabled:cursor-not-allowed disabled:opacity-60 ${classes}`}
    >
      {children}
    </button>
  );
};

export const AdminStateMessage = ({ message, tone = "neutral" }: { message: string; tone?: "neutral" | "error" }) => (
  <div className={`flex items-center gap-2 rounded-[8px] border px-3 py-3 text-[13px] font-medium ${
    tone === "error"
      ? "border-[#FECACA] bg-[#FEF2F2] text-[#B91C1C]"
      : "border-border-grey bg-[#FAFAFA] text-text-secondary"
  }`}>
    <AlertCircle size={16} />
    <span>{message}</span>
  </div>
);

export const AdminRefreshButton = ({ onClick, disabled }: { onClick: () => void; disabled?: boolean }) => (
  <AdminButton onClick={onClick} variant="secondary" disabled={disabled}>
    <RefreshCw size={15} />
    {ADMIN_TEXT.REFRESH}
  </AdminButton>
);

export const AdminImageThumb = ({
  src,
  label,
  className = "h-16 w-16",
}: {
  src?: string;
  label: string;
  className?: string;
}) => {
  const initials = label
    .split(" ")
    .map((part) => part[0])
    .join("")
    .slice(0, 2)
    .toUpperCase();

  return (
    <div
      className={`${className} shrink-0 overflow-hidden rounded-[8px] border border-border-grey bg-[#E8F5E9] bg-cover bg-center shadow-sm`}
      style={src ? { backgroundImage: `url("${src}")` } : undefined}
      aria-label={label}
    >
      {!src ? (
        <div className="flex h-full w-full items-center justify-center text-[13px] font-semibold text-primary-green">
          {initials || "L"}
        </div>
      ) : null}
    </div>
  );
};

export const AdminImageStrip = ({ images, label }: { images?: string[]; label: string }) => {
  const visibleImages = (images || []).filter(Boolean).slice(0, 4);

  if (visibleImages.length === 0) {
    return <AdminImageThumb label={label} className="h-20 w-full" />;
  }

  return (
    <div className="flex gap-2 overflow-hidden">
      {visibleImages.map((image, index) => (
        <AdminImageThumb
          key={`${image}-${index}`}
          src={image}
          label={label}
          className="h-20 min-w-[78px] flex-1"
        />
      ))}
    </div>
  );
};
