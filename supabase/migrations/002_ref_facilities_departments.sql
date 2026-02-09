create extension if not exists "uuid-ossp";

create table if not exists public.facilities (
  id uuid primary key default uuid_generate_v4(),
  name text not null unique,
  created_at timestamptz not null default now()
);

create table if not exists public.departments (
  id uuid primary key default uuid_generate_v4(),
  facility_id uuid not null references public.facilities(id) on delete cascade,
  name text not null,
  created_at timestamptz not null default now(),
  unique (facility_id, name)
);

alter table public.facilities enable row level security;
alter table public.departments enable row level security;

drop policy if exists "facilities_read_all_auth" on public.facilities;
create policy "facilities_read_all_auth" on public.facilities
for select to authenticated using (true);

drop policy if exists "departments_read_all_auth" on public.departments;
create policy "departments_read_all_auth" on public.departments
for select to authenticated using (true);

drop policy if exists "facilities_write_admin" on public.facilities;
create policy "facilities_write_admin" on public.facilities
for insert to authenticated with check (public.current_role() = 'admin');

drop policy if exists "departments_write_admin" on public.departments;
create policy "departments_write_admin" on public.departments
for insert to authenticated with check (public.current_role() = 'admin');

insert into public.facilities (name) values
('Hôpital Ibn Rochd'),
('Hôpital Mère-Enfant Abderrahim Harouchi'),
('Hôpital 20 Août 1953'),
('Centre de Consultation et de Traitement Dentaire'),
('FMPC'),
('FMDC'),
('Direction Générale')
on conflict (name) do nothing;

create or replace function public.facility_id_by_name(facility_name text)
returns uuid language sql stable as $$
  select id from public.facilities where name = facility_name limit 1
$$;

-- Ibn Rochd
insert into public.departments (facility_id, name)
select public.facility_id_by_name('Hôpital Ibn Rochd'), x
from unnest(array[
  'Addictologie',
  'Cardiologie (P.37)',
  'Centre des Brûlés (P.34)',
  'Centre Mohammed VI d’Oncologie',
  'Chirurgie Cardio-Vasculaire',
  'Chirurgie générale (A.I)',
  'Chirurgie générale (A.III)',
  'Chirurgie thoracique (A. II)',
  'Dermatologie (P.42)',
  'Endocrinologie (P.26)',
  'Gastro-entérologie et Proctologie (P.24)',
  'Maladies Infectieuses (P.23)',
  'Médecine interne (P.38)',
  'Médecine Légale',
  'Médecine nucléaire',
  'Médecine physique',
  'Néphrologie (P.31)',
  'Neurochirurgie (A.VI)',
  'Neurologie (P.30)',
  'Oncologie (P.40)',
  'Pneumologie (P.25)',
  'Psychiatrie (P.36)',
  'Radiologie',
  'Réanimation Chirurgicale (P.17)',
  'Réanimation Chirurgicale des Urgences (P.33)',
  'Réanimation des Brûlés',
  'Réanimation des Urgences Médicales (P.27)',
  'Rhumatologie (P.43)',
  'Service d’Accueil aux Urgences',
  'Service des Urgences Chirurgicales Viscérales : Pavillon 35',
  'Traumato-Orthopédie (A.IV)',
  'Traumatologie (P.32)',
  'Urgences neurochirurgicales',
  'Urologie (A.V)'
]) as x
on conflict do nothing;

-- Harouchi (+ Urgences Pédiatriques)
insert into public.departments (facility_id, name)
select public.facility_id_by_name('Hôpital Mère-Enfant Abderrahim Harouchi'), x
from unnest(array[
  'Chirurgie Viscérale Pédiatrique',
  'Maternité',
  'Orthopédie, Traumatologie Pédiatriques',
  'Pédiatrie I',
  'Pédiatrie II',
  'Pédiatrie III',
  'Pédiatrie IV',
  'Pédiatrie V',
  'Pédopsychiatrie',
  'Radiologie',
  'Réanimation Maternité',
  'Réanimation Polyvalente',
  'Urgences Pédiatriques'
]) as x
on conflict do nothing;

-- 20 Août
insert into public.departments (facility_id, name)
select public.facility_id_by_name('Hôpital 20 Août 1953'), x
from unnest(array[
  'Chirurgie Maxillo-faciale',
  'Hématologie',
  'Ophtalmologie adulte',
  'Ophtalmologie pédiatrique',
  'Oto-rhino-laryngologie et chirurgie cervico-faciale',
  'Phtisiologie',
  'Pneumologie',
  'Radiologie',
  'Réanimation',
  'Urgences'
]) as x
on conflict do nothing;

-- Centre dentaire
insert into public.departments (facility_id, name)
select public.facility_id_by_name('Centre de Consultation et de Traitement Dentaire'), x
from unnest(array[
  'Laboratoire de prothèse',
  'Odontologie Chirurgicale',
  'Odontologie Conservatrice',
  'Orthopédie dento-faciale',
  'Parodontologie',
  'Pédodontie et prévention',
  'Prothèse adjointe',
  'Prothèse conjointe',
  'Radiologie',
  'Urgences dentaires'
]) as x
on conflict do nothing;

-- FMPC / FMDC / Direction Générale
insert into public.departments (facility_id, name)
select public.facility_id_by_name('FMPC'), 'Non spécifié'
on conflict do nothing;

insert into public.departments (facility_id, name)
select public.facility_id_by_name('FMDC'), 'Non spécifié'
on conflict do nothing;

insert into public.departments (facility_id, name)
select public.facility_id_by_name('Direction Générale'), 'Non spécifié'
on conflict do nothing;
