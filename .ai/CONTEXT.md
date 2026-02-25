# Project Context (Source of Truth)

This Flutter project is being developed to replicate the functionality of an existing React site. The following sources are **authoritative** and MUST be consulted before making any changes.

## Technology stack
- **Flutter app** – located in the project root. The source code lives under `lib/`, `test/` and other Dart files in the root.
- **Supabase database** – the schema and data are defined in `backup.sql` in the project root.  This file defines all tables, columns, relationships, constraints and enumerations used by the backend.
- **Supabase edge functions** – these server‑side functions are stored under the `supabase_backup` directory in the project root.  They implement REST or RPC handlers used by the React site.  Treat these files as read‑only source of truth for backend behaviour.
- **Legacy React implementation** – located under the `react_site` directory.  This codebase defines existing screens, flows and API interactions that the Flutter app must replicate.

## Order of reference when answering questions or implementing changes
1. **`backup.sql`** – always examine the SQL dump to understand database structure; do not guess schema details.
2. **`supabase_backup`** – use these functions to understand backend logic and endpoints; copy their names and request/response structures.
3. **`react_site`** – inspect this to understand how the existing React app works; replicate the behaviour in Flutter when applicable.
4. **Current Flutter implementation (`/lib/**`)** – examine this to align new code with existing patterns and style.
5. **`.ai/DECISIONS.md` and the project `README`** – for previous architectural decisions and guidelines.

## Non‑negotiable truths
- The database schema, functions and flows are exclusively defined in `backup.sql` and `supabase_backup`.  If a structure or function is not found there, it does **not** exist.
- The user interface flows and interactions must match those in `react_site` unless specified otherwise.
- Keep naming conventions and coding style consistent with the current Flutter codebase.
