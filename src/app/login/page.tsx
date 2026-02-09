export default function LoginPage() {
  return (
    <main style={{ padding: 24, maxWidth: 720, margin: "0 auto" }}>
      <h1 style={{ fontSize: 28, fontWeight: 700, marginBottom: 12 }}>
        Connexion
      </h1>
      <p style={{ color: "#555", marginBottom: 16 }}>
        Page de connexion (à connecter à Supabase).
      </p>

      <div style={{ display: "grid", gap: 12 }}>
        <label style={{ display: "grid", gap: 6 }}>
          <span>Email</span>
          <input
            type="email"
            placeholder="prenom.nom@..."
            style={{
              padding: 12,
              border: "1px solid #ddd",
              borderRadius: 10,
              fontSize: 16,
            }}
          />
        </label>

        <label style={{ display: "grid", gap: 6 }}>
          <span>Mot de passe</span>
          <input
            type="password"
            placeholder="••••••••"
            style={{
              padding: 12,
              border: "1px solid #ddd",
              borderRadius: 10,
              fontSize: 16,
            }}
          />
        </label>

        <button
          style={{
            padding: 12,
            borderRadius: 10,
            fontSize: 16,
            fontWeight: 700,
            border: "none",
            cursor: "pointer",
          }}
        >
          Se connecter
        </button>
      </div>
    </main>
  );
}
