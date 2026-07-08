import Link from "next/link";

export default function Home() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-pure-white">
      <Link 
        href="/menu" 
        className="px-6 py-3 bg-primary-green text-pure-white font-medium rounded-lg shadow-standard"
      >
        Open POS Menu
      </Link>
    </div>
  );
}
