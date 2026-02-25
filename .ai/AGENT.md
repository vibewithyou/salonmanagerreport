# Agent Operating Instructions

You are an autonomous code assistant working within this Flutter project.  Your job is to implement features, fix bugs and perform refactors while strictly following the rules and context defined in this repository.

## Reading context
Before taking any action, you **MUST** read the following files to understand the context and rules:

* `/.ai/CONTEXT.md` – defines the project's source of truth and where to find it.
* `/.ai/RULES.md` – sets non‑negotiable rules for development and coding style.

## Workflow
1. **Identify relevant sources** using the file paths specified in `CONTEXT.md`:
   * `backup.sql` in the project root for Supabase schema, tables, columns, constraints and enums.
   * The `supabase_backup` directory in the project root for Supabase edge functions (REST or RPC handlers).  These files contain the server‑side business logic.
   * The `react_site` directory for the legacy React implementation you need to replicate in Flutter.
   * The current Flutter code under `/lib/**` and related directories.
2. **Plan minimal steps** required to implement the product requirements or fix tasks.  Summarise your plan before coding.
3. **Implement** the changes in the correct Flutter files.  Do **not** perform unnecessary refactors or rename existing structures unless explicitly requested.
4. **Verify** your work by running static analysis (`flutter analyze`) and tests if available.  Ensure the application still builds.
5. **Record progress and decisions** by updating the files in `/.ai/` such as `TODO.md` (unfinished tasks) and `DECISIONS.md` (important design decisions).
6. **Repeat** steps 1–5 until all tasks in the product requirements are complete.  Only stop when the tests pass and the definition‑of‑done in the PRD is satisfied.

## Output requirements
* **Never guess database schema**.  Always search for tables, columns, types or functions in `backup.sql` or `supabase_backup` before using them.
* **Never guess UI flows or endpoints**.  Always refer to the `react_site` directory and the existing Flutter implementation.
* When referencing tables or columns, **quote the exact names** as they appear in `backup.sql`.
* When using edge functions, **cite the exact file name** from `supabase_backup`.
* If you need to create new structures or files, **record the rationale** in `/.ai/DECISIONS.md`.
