export default function DashboardPage() {
  return (
    <main style={{ padding: 24, maxWidth: 900, margin: "0 auto" }}>
      <h1 style={{ fontSize: 28, fontWeight: 700, marginBottom: 12 }}>
        Dashboard
      </h1>
      <p style={{ color: "#555", marginBottom: 16 }}>
        Ici on affichera la liste des dossiers + filtres + validation.
      </p>

      <div
        style={{
          padding: 16,
          border: "1px solid #eee",
          borderRadius: 12,
          background: "#fafafa",
        }}
      >
        <strong>Statut :</strong> page en cours de construction ✅
      </div>
    </main>
  );
}
