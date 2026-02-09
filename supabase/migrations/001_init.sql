create extension if not exists "uuid-ossp";

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  role text not null default 'resident' check (role in ('resident','prof','admin')),
  created_at timestamptz not null default now()
);

create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, full_name, role)
  values (new.id, coalesce(new.raw_user_meta_data->>'full_name', ''), 'resident')
  on conflict (id) do nothing;
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();

create table if not exists public.cases (
  id uuid primary key default uuid_generate_v4(),
  type text not null,
  status text not null default 'draft' check (status in ('draft','submitted','validated')),
  date text not null,
  nom text not null,
  prenom text not null,
  service text,
  etablissement text,
  data jsonb not null default '{}'::jsonb,
  created_by uuid not null references auth.users(id) on delete restrict,
  validated_by uuid references auth.users(id) on delete set null,
  validated_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists cases_set_updated_at on public.cases;
create trigger cases_set_updated_at before update on public.cases
for each row execute procedure public.set_updated_at();

create or replace function public.current_role()
returns text
language sql stable as $$
  select coalesce((select role from public.profiles where id = auth.uid()), 'resident');
$$;

create or replace function public.is_prof_or_admin()
returns boolean
language sql stable as $$
  select public.current_role() in ('prof','admin');
$$;

alter table public.profiles enable row level security;
alter table public.cases enable row level security;

drop policy if exists "profiles_read_own" on public.profiles;
create policy "profiles_read_own" on public.profiles
for select to authenticated
using (id = auth.uid());

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own" on public.profiles
for update to authenticated
using (id = auth.uid())
with check (id = auth.uid());

drop policy if exists "cases_read_all_auth" on public.cases;
create policy "cases_read_all_auth" on public.cases
for select to authenticated
using (true);

create or replace function public.force_created_by()
returns trigger as $$
begin
  new.created_by = auth.uid();
  return new;
end;
$$ language plpgsql;

drop trigger if exists cases_force_created_by on public.cases;
create trigger cases_force_created_by before insert on public.cases
for each row execute procedure public.force_created_by();

drop policy if exists "cases_insert_auth" on public.cases;
create policy "cases_insert_auth" on public.cases
for insert to authenticated
with check (true);

drop policy if exists "cases_update_rules" on public.cases;
create policy "cases_update_rules" on public.cases
for update to authenticated
using (
  public.is_prof_or_admin()
  OR (created_by = auth.uid() AND status <> 'validated')
)
with check (
  public.is_prof_or_admin()
  OR (created_by = auth.uid() AND status <> 'validated')
);

drop policy if exists "cases_delete_admin" on public.cases;
create policy "cases_delete_admin" on public.cases
for delete to authenticated
using (public.current_role() = 'admin');
