# Supa Hero

A side-scrolling flying game: the Supabase bolt flies as a caped superhero and clears rival obstacles
(Legacy DB, Vendor Lock-in, Slow Queries, Cold Starts...). One point per obstacle cleared.

- `index.html`: the whole game (canvas + supabase-js from the jsDelivr CDN). Already configured with
  your project URL and publishable key.
- `schema.sql`: tables, RLS policies and the `game_leaderboard` view (already applied to your project).

## Run it
Open `index.html` in a browser, or host it on any static host (Vercel, Netlify, GitHub Pages, Supabase Storage).
For local testing: `npx serve .` or `python3 -m http.server`.

## Controls
Space / ↑ / W / click / tap to fly up. Enter or Space restarts after game over.

## How data flows
1. First visit: player registers a name -> row in `game_players` (names are unique, case-insensitive).
   The player id is remembered in the browser's localStorage.
2. Game over: score inserted into `game_scores`.
3. Leaderboard: `game_leaderboard` view = best score per name, top 30.

## Notes
- Scores are submitted from the browser, so a determined player could post a fake score with the public key.
  For a casual game that's normal; to harden it, move submission into an Edge Function that validates runs.
- The Supabase logo is Supabase's trademark. Fine for a fan/internal game; check their brand guidelines before
  publishing it commercially.
