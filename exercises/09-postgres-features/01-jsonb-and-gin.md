# Exercise: JSONB & GIN

Read: `notes/09-postgres-features/01-jsonb-and-gin.md`

## Tasks

1. Select `slug` and `attrs->>'level'` for all articles.
2. Find articles whose `attrs` contain tag `fts` (`@>`).
3. Order articles by `(attrs->>'likes')::int` descending.
4. Why is there a GIN index on `attrs`?
5. Should `is_published` live in JSONB instead of a boolean column? Why/why not?

## Stretch

`EXPLAIN` a containment query on `attrs` — note whether the GIN index appears (tiny table may still seq-scan).

---

## Solutions

1.

```sql
SELECT slug, attrs->>'level' AS level FROM feat_lab.articles;
```

2.

```sql
SELECT slug FROM feat_lab.articles
WHERE attrs @> '{"tags":["fts"]}'::jsonb;
```

3.

```sql
SELECT slug, (attrs->>'likes')::int AS likes
FROM feat_lab.articles
ORDER BY likes DESC NULLS LAST;
```

4. Speeds `@>` / key-existence style filters on JSONB at scale.
5. **No** — core filter/filterable flags belong in real columns (constraints, indexes, clarity).

Stretch: `EXPLAIN (ANALYZE, BUFFERS) SELECT slug FROM feat_lab.articles WHERE attrs @> '{"level":"advanced"}'::jsonb;`
