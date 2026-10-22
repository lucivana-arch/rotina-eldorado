-- Rotina da Casa da Eldorado: tabelas do app
-- Cole tudo no SQL Editor do Supabase e clique em "Run".

create table if not exists public.rotina_marcas (
  semana        text        not null,           -- segunda-feira da semana, ex.: 2026-10-19
  item_id       text        not null,           -- ex.: seg-1-0
  dia           text        not null,           -- seg, qua, sex, sab
  feito         boolean     not null default false,
  feito_por     text,
  atualizado_em timestamptz not null default now(),
  primary key (semana, item_id)
);

create table if not exists public.rotina_dia (
  semana        text        not null,
  dia           text        not null,
  escolha       text,                            -- tarefa alternada da quarta
  notas         text,                            -- observações do dia
  atualizado_em timestamptz not null default now(),
  primary key (semana, dia)
);

-- O app usa a chave pública, então liberamos leitura e gravação só nestas duas tabelas.
alter table public.rotina_marcas enable row level security;
alter table public.rotina_dia    enable row level security;

drop policy if exists "app_rotina_marcas" on public.rotina_marcas;
create policy "app_rotina_marcas" on public.rotina_marcas
  for all to anon using (true) with check (true);

drop policy if exists "app_rotina_dia" on public.rotina_dia;
create policy "app_rotina_dia" on public.rotina_dia
  for all to anon using (true) with check (true);

grant select, insert, update on public.rotina_marcas to anon;
grant select, insert, update on public.rotina_dia    to anon;

-- Atualização ao vivo entre os celulares
alter publication supabase_realtime add table public.rotina_marcas;
alter publication supabase_realtime add table public.rotina_dia;
