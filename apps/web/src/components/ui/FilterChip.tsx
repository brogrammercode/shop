interface FilterChipProps {
  label: string;
  icon?: React.ReactNode;
  hasDropdown?: boolean;
  selected?: boolean;
  onClick?: () => void;
}

export const FilterChip = ({ label, icon, hasDropdown = false, selected = false, onClick }: FilterChipProps) => {
  return (
    <button
      onClick={onClick}
      className={`
        flex items-center gap-1.5 px-3 py-2 rounded-[10px] border shrink-0 transition-colors
        ${selected ? 'border-primary-green bg-green-50' : 'border-border-grey bg-pure-white'}
      `}
    >
      {icon && <span className="text-text-secondary">{icon}</span>}
      <span className="text-xs font-semibold text-text-primary">{label}</span>
      {hasDropdown && (
        <svg className="w-3.5 h-3.5 text-text-secondary" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
        </svg>
      )}
    </button>
  );
};
