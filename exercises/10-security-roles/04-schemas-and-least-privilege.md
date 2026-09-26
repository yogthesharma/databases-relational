# Exercise: Schemas & least privilege

Read: `notes/10-security-roles/04-schemas-and-least-privilege.md`

## Tasks

1. As `sec_app`, try `SELECT count(*) FROM public.employees;`
2. As `sec_app`, try `SELECT count(*) FROM feat_lab.articles;` (reset/feat lab if missing).
3. As `sec_readonly`, confirm you can read `sec_lab.orders` but not insert.
4. What privilege opens a schema “door”?
5. Why set a tight `search_path` on app connections?

## Stretch

`SHOW search_path;` as `postgres` — what schemas are listed?

---

## Solutions

1. Permission denied (no grants on `public.employees`).
2. Permission denied (no `USAGE`/`SELECT` on `feat_lab`).
3. `SELECT` OK; `INSERT` fails.
4. `USAGE` on the schema.
5. Avoid resolving objects from unexpected schemas (name-spoofing / confusion).

Stretch: typically `"$user", public` (or similar).
