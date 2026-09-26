# Exercise: Functions & procedures

Read: `notes/09-postgres-features/05-functions-and-procedures.md`

## Tasks

1. Call `feat_lab.article_likes(id)` for the `postgres-jsonb` article.
2. Is that function `LANGUAGE sql` or `plpgsql`? Why does that matter?
3. Name one good reason to put logic in the DB.
4. Name one good reason to keep logic in the Node app.
5. What’s the difference between a function and a procedure at a high level?

## Stretch

Write a tiny SQL function `feat_lab.published_count()` returning the number of published articles.

---

## Solutions

1.

```sql
SELECT feat_lab.article_likes(id)
FROM feat_lab.articles WHERE slug = 'postgres-jsonb';
-- 12
```

2. `LANGUAGE sql` — simpler; planner can inline more often than procedural code.
3. Shared invariants / one definition for every client.
4. Product workflow, HTTP, rapid change, orchestration.
5. Functions return values in queries; procedures are `CALL`ed and can manage transactions (PG 11+).

Stretch:

```sql
CREATE OR REPLACE FUNCTION feat_lab.published_count()
RETURNS bigint
LANGUAGE sql
STABLE
AS $$
  SELECT count(*) FROM feat_lab.articles WHERE is_published;
$$;
SELECT feat_lab.published_count();
```
