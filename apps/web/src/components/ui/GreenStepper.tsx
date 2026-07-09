interface GreenStepperProps {
  count: number | string;
  onIncrement?: () => void;
  onDecrement?: () => void;
}

export const GreenStepper = ({ count, onIncrement, onDecrement }: GreenStepperProps) => {
  return (
    <div className="flex items-center gap-3 px-2 py-1 border border-primary-green rounded-lg bg-green-50">
      <button onClick={onDecrement} className="text-primary-green active:opacity-70 p-1">
        <svg className="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M20 12H4" />
        </svg>
      </button>
      <span className="text-[13px] font-bold text-primary-green min-w-[12px] text-center">
        {count}
      </span>
      <button onClick={onIncrement} className="text-primary-green active:opacity-70 p-1">
        <svg className="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M12 4v16m8-8H4" />
        </svg>
      </button>
    </div>
  );
};
