# Context Gate Checklist

Before proposing or implementing a solution, you must provide evidence that you have consulted the authoritative sources.  Include the following items in your response before writing any code or making changes:

- **Database evidence**: Quote the exact table and column names used from `backup.sql` (for example, `users.email`, `orders.id`).  Provide a snippet or line number if relevant.
- **Edge function evidence**: Reference the specific file(s) in `supabase_backup` that implement the server logic you are using (for example, `supabase_backup/createOrder.ts`).
- **UI evidence**: Mention the component or file names from `react_site` you inspected (for example, `react_site/src/pages/Checkout.jsx`) when replicating flows or layouts.
- **Implementation target**: Specify which Flutter file(s) you plan to create or modify (for example, `lib/screens/checkout_page.dart`).

If you cannot find the required information in these sources, do **not** guess.  Instead, add a TODO entry to `/.ai/TODO.md` with a description of what information is missing and stop until clarification is provided.
