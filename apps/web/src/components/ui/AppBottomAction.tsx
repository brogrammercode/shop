export const AppBottomAction = ({ children }: { children: React.ReactNode }) => {
  return (
    <div className="fixed bottom-0 left-0 right-0 z-50 pointer-events-none pb-6 px-6">
      <div className="mx-auto max-w-lg pointer-events-auto shadow-deep rounded-2xl overflow-hidden">
        {children}
      </div>
    </div>
  );
};
