# Plateforme Astreinte Médecine du Travail (100% gratuite + HTTPS)
Stack: Supabase (DB/Auth) + Vercel (HTTPS).

## Supabase
1) SQL Editor : exécuter
- `supabase/migrations/001_init.sql`
- `supabase/migrations/002_ref_facilities_departments.sql`

2) Authentication → Users : créer les comptes (résidents / profs)
3) Table `profiles` : mettre role = `resident` / `prof` / `admin`

## Variables (Vercel + local)
- NEXT_PUBLIC_SUPABASE_URL
- NEXT_PUBLIC_SUPABASE_ANON_KEY
