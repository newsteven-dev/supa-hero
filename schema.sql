-- Supa Hero leaderboard schema (already applied to project ibbevgvkvtoffgjucvlz as migration "supa_hero_game")
create table public.game_players (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(btrim(name)) between 2 and 20 and name ~ '^[A-Za-z0-9 _.\-]+$'),
  created_at timestamptz not null default now()
);
create unique index game_players_name_lower_idx on public.game_players (lower(name));

create table public.game_scores (
  id bigint generated always as identity primary key,
  player_id uuid not null references public.game_players(id) on delete cascade,
  score integer not null check (score between 0 and 100000),
  created_at timestamptz not null default now()
);
create index game_scores_player_idx on public.game_scores (player_id);
create index game_scores_score_idx on public.game_scores (score desc);

alter table public.game_players enable row level security;
alter table public.game_scores enable row level security;

-- Public read + insert only. No update/delete policies, so nobody can edit or wipe scores from the browser.
create policy "Anyone can read players" on public.game_players for select to anon, authenticated using (true);
create policy "Anyone can register a player" on public.game_players for insert to anon, authenticated with check (true);
create policy "Anyone can read scores" on public.game_scores for select to anon, authenticated using (true);
create policy "Anyone can submit a score" on public.game_scores for insert to anon, authenticated with check (true);

-- Best score per registered name, top 30
create view public.game_leaderboard with (security_invoker = true) as
select p.name, max(s.score) as best_score, count(*) as games_played, max(s.created_at) as last_played
from public.game_scores s
join public.game_players p on p.id = s.player_id
group by p.id, p.name
order by best_score desc, last_played asc
limit 30;

grant select on public.game_leaderboard to anon, authenticated;
