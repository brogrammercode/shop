interface SamosaIconProps {
  size?: number;
  className?: string;
}

export const SamosaIcon = ({ size = 20, className = "" }: SamosaIconProps) => (
  <svg
    width={size}
    height={size}
    viewBox="0 0 64 64"
    fill="none"
    xmlns="http://www.w3.org/2000/svg"
    className={className}
  >
    <path
      d="M31.2 8.4C33 6.1 36.6 7 37.1 9.9L46.9 53.3C47.5 56 45 58.3 42.4 57.4L8.8 45.7C6.1 44.7 5.5 41.1 7.8 39.4L31.2 8.4Z"
      fill="#F59E0B"
    />
    <path
      d="M34.1 12.4L43.1 52.1L12.4 41.4L34.1 12.4Z"
      fill="#FDBA2D"
    />
    <path
      d="M17.2 38.8C23.7 39.7 31 42.1 38.8 47.2"
      stroke="#9A3412"
      strokeWidth="3.2"
      strokeLinecap="round"
    />
    <path
      d="M25.2 28.2C29.4 29.5 34.1 32 39.1 36.1"
      stroke="#9A3412"
      strokeWidth="3.2"
      strokeLinecap="round"
    />
    <path
      d="M33.5 17.9C36 19.3 38.2 21.4 40.2 24.1"
      stroke="#9A3412"
      strokeWidth="3.2"
      strokeLinecap="round"
    />
    <circle cx="30" cy="36" r="2.2" fill="#166534" />
    <circle cx="36.8" cy="43.5" r="2.2" fill="#166534" />
    <circle cx="25" cy="43" r="2" fill="#166534" />
    <path
      d="M31.2 8.4C33 6.1 36.6 7 37.1 9.9L46.9 53.3C47.5 56 45 58.3 42.4 57.4L8.8 45.7C6.1 44.7 5.5 41.1 7.8 39.4L31.2 8.4Z"
      stroke="#7C2D12"
      strokeWidth="3"
      strokeLinejoin="round"
    />
  </svg>
);
