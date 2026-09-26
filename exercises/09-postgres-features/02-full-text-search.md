# Exercise: Full-text search

Read: `notes/09-postgres-features/02-full-text-search.md`

## Tasks

1. What types are `tsvector` and `tsquery` for?
2. Find articles matching `jsonb & gin` (english config) via `search_vector`.
3. Rank matches for `postgres | search` with `ts_rank`, highest first.
4. Who updates `search_vector` in this lab when title/body change?
5. Try a trigram similarity search on `title` (`%` operator).

## Stretch

Explain why title is weight `A` and body `B` in the trigger.

---

## Solutions

1. Document search representation / query respectively.
2.

```sql
SELECT slug, title FROM feat_lab.articles
WHERE search_vector @@ to_tsquery('english', 'jsonb & gin');
```

3.

```sql
SELECT slug, ts_rank(search_vector, q) AS rank
FROM feat_lab.articles, to_tsquery('english', 'postgres | search') q
WHERE search_vector @@ q
ORDER BY rank DESC;
```

4. The `BEFORE INSERT OR UPDATE` trigger `articles_search_vector_tg`.
5.

```sql
SELECT slug, title FROM feat_lab.articles WHERE title % 'full text';
```

Stretch: title matches should rank higher than body-only hits.
