# Exercise: Migrations mindset

Read: `notes/04-schema-design/06-migrations-mindset.md`

## Tasks

1. You need to rename `students.full_name` → `students.name` in production with zero downtime. Outline expand/contract steps.
2. Why is `DROP SCHEMA design_lab CASCADE` fine here but catastrophic as a “migration” in prod?
3. Prisma/Drizzle generate SQL — should you still read it before applying to prod? Why?
4. Order these: backfill data, add nullable column, drop old column, deploy app that writes both / reads new.
5. What’s wrong with changing a column type in place on a large table during peak traffic (high level)?

## Stretch

Write the expand SQL only: add `students.name TEXT` (nullable) without dropping `full_name`.

---

## Solutions

1. Add `name` → backfill from `full_name` → deploy app dual-write / read `name` → stop using `full_name` → drop `full_name`.
2. Lab data is disposable; prod holds irreplaceable data and live traffic.
3. Yes — tools can emit locks, rewrites, or unsafe drops; you own the blast radius.
4. Add nullable column → backfill → deploy app that writes both / reads new → drop old column.
5. Possible long locks / table rewrites / app errors if old code expects the old type.

Stretch:

```sql
ALTER TABLE design_lab.students ADD COLUMN name TEXT;
-- later: UPDATE design_lab.students SET name = full_name WHERE name IS NULL;
```
