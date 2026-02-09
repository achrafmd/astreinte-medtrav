import Link from "next/link";
export default function Home() {
  return (
    <main className="rounded-2xl bg-white p-6 shadow">
      <h1 className="text-2xl font-semibold">Bienvenue</h1>
      <p className="mt-2 text-gray-700">
        Plateforme interne d’astreinte : création de dossiers, suivi, et validation par les professeurs.
      </p>
      <div className="mt-4 flex flex-wrap gap-3">
        <Link className="rounded-xl bg-black px-4 py-2 text-white" href="/login">Se connecter</Link>
        <Link className="rounded-xl border px-4 py-2" href="/dashboard">Aller au dashboard</Link>
      </div>
    </main>
  );
}
