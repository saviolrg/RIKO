-- RIKO · criar a tabela no Supabase
-- Cole tudo no Supabase → SQL Editor → New query → Run. Pode correr mais de uma vez sem problema.

-- 1) Tabela: cada linha é um "documento" do RIKO (um mês, uma conta fixa, um gasto, uma meta…)
create table if not exists public.riko_docs (
  user_id    uuid        not null default auth.uid() references auth.users(id) on delete cascade,
  path       text        not null,              -- ex.: meses/2026-10, fixas/abc123, config/setup
  col        text        not null,              -- coleção: meses, fixas, avulsas, extras, metas, retiradas, guardado, config
  data       jsonb       not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (user_id, path)
);

create index if not exists riko_docs_user_col on public.riko_docs (user_id, col);

-- 2) Segurança: cada conta só vê e altera os seus próprios dados
alter table public.riko_docs enable row level security;

drop policy if exists "riko ler os seus"     on public.riko_docs;
drop policy if exists "riko criar os seus"   on public.riko_docs;
drop policy if exists "riko alterar os seus" on public.riko_docs;
drop policy if exists "riko apagar os seus"  on public.riko_docs;

create policy "riko ler os seus"     on public.riko_docs for select to authenticated using (user_id = auth.uid());
create policy "riko criar os seus"   on public.riko_docs for insert to authenticated with check (user_id = auth.uid());
create policy "riko alterar os seus" on public.riko_docs for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "riko apagar os seus"  on public.riko_docs for delete to authenticated using (user_id = auth.uid());

-- 3) Tempo real: o que muda num aparelho aparece logo nos outros
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'riko_docs'
  ) then
    alter publication supabase_realtime add table public.riko_docs;
  end if;
end $$;
