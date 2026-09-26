# Exercise: Triggers

Read: `notes/09-postgres-features/06-triggers.md`

## Tasks

1. What event fires `articles_search_vector_tg`?
2. Update the body of `postgres-jsonb` and show `updated_at` changed.
3. Confirm `search_vector` is still non-null after that update.
4. Give one good trigger use case and one bad one.
5. Row-level vs statement-level trigger — which does the lab use?

## Stretch

Why update `search_vector` in a trigger instead of only in app code?

---

## Solutions

1. `BEFORE INSERT OR UPDATE OF title, body` on `feat_lab.articles` (not every column).
2.

```sql
UPDATE feat_lab.articles
SET body = body || ' Updated.'
WHERE slug = 'postgres-jsonb'
RETURNING slug, updated_at;
```

3. `SELECT search_vector IS NOT NULL FROM feat_lab.articles WHERE slug = 'postgres-jsonb';`
4. Good: maintain derived search/audit fields. Bad: hide emails / payments / business workflows.
5. **Row-level** (`FOR EACH ROW`).

Stretch: any writer (SQL console, script, ORM) stays consistent — not only the Node path.
