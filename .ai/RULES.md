# Development Rules

These rules are non‑negotiable.  You must adhere to them at all times while working in this repository.

## No Hallucination
- **Do not invent database tables, columns, types or functions.** Always verify their existence in `backup.sql` or `supabase_backup` before using them.
- **Do not invent UI elements, routes or pages.** Always verify them in `react_site` or the existing Flutter code.
- If a required detail cannot be found, record a TODO in `/.ai/TODO.md` and ask for clarification rather than guessing.

## Code Quality
- Keep changes **small and focused**. Avoid large refactors unless mandated by the product requirements.
- Follow existing project conventions: use null‑safety in Dart, camelCase naming, and format code consistently.
- Write clear, maintainable code with proper error handling.  Do not leave incomplete or commented‑out code in the codebase.

## Supabase
- Use the **exact names** of tables, columns, stored procedures and edge function endpoints as defined in `backup.sql` and `supabase_backup`.
- Do **not** make destructive SQL changes without explicit instruction.

## Supabase Edge Functions
- When implementing API calls or replicating server logic, refer to the corresponding file in `supabase_backup` to determine the correct request and response structures.

## File Updates
- After each change, update `/.ai/TODO.md` or `/.ai/DECISIONS.md` with tasks completed, decisions made and any outstanding questions.  This keeps future sessions informed and prevents duplicate work.
