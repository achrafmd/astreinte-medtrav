import "./globals.css";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Astreinte Médecine du Travail",
  description: "Plateforme d’astreinte (résidents/profs) – HTTPS"
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="fr">
      <body className="min-h-screen bg-gray-50 text-gray-900">
        <div className="mx-auto max-w-5xl px-4 py-6">
          <header className="mb-6 flex items-center justify-between gap-3">
            <div>
              <div className="text-xl font-semibold">Astreinte Médecine du Travail</div>
              <div className="text-sm text-gray-600">Saisie + validation (profs) — accès externe sécurisé</div>
            </div>
            <nav className="flex gap-3 text-sm">
              <a className="underline" href="/dashboard">Dashboard</a>
              <a className="underline" href="/login">Connexion</a>
            </nav>
          </header>
          {children}
        </div>
      </body>
    </html>
  );
}
