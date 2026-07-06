interface AppButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  text: string;
  icon?: React.ReactNode;
  fullWidth?: boolean;
}

export const AppButton = ({ text, icon, fullWidth = true, className = '', ...props }: AppButtonProps) => {
  return (
    <button
      className={`
        bg-primary-green text-pure-white flex items-center justify-center gap-2 h-14 rounded-2xl
        font-semibold text-base shadow-sm transition-transform active:scale-[0.98]
        ${fullWidth ? 'w-full' : 'px-8'}
        ${className}
      `}
      {...props}
    >
      {icon}
      <span>{text}</span>
    </button>
  );
};
