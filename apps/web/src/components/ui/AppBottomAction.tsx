export const AppBottomAction = ({ children }: { children: React.ReactNode }) => {
  return (
    <div className="pointer-events-none fixed bottom-[var(--root-nav-clearance)] left-0 right-0 z-40 px-6">
      <div className="mx-auto max-w-lg pointer-events-auto shadow-deep rounded-2xl overflow-hidden">
        {children}
      </div>
    </div>
  );
};
