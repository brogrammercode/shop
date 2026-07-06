export const VegIndicator = ({ isVeg }: { isVeg: boolean }) => {
  const colorClass = isVeg ? 'border-green-600' : 'border-red-600';
  const bgClass = isVeg ? 'bg-green-600' : 'bg-red-600';

  return (
    <div className={`w-3.5 h-3.5 flex items-center justify-center border-2 bg-pure-white rounded-sm ${colorClass}`}>
      <div className={`w-1.5 h-1.5 rounded-full ${bgClass}`} />
    </div>
  );
};
