# Full-text search

## `tsvector` / `tsquery`

```sql
SELECT slug, title
FROM feat_lab.articles
WHERE search_vector @@ to_tsquery('english', 'jsonb & index');

SELECT slug, ts_rank(search_vector, q) AS rank
FROM feat_lab.articles,
     to_tsquery('english', 'postgres | search') AS q
WHERE search_vector @@ q
ORDER BY rank DESC;
```

Lab maintains `search_vector` with a **trigger** (title weight A, body weight B).

## Indexes

`GIN` on `tsvector` (already on `articles_search_gin`). For fuzzy title match, `pg_trgm` GIN:

```sql
SELECT slug, title
FROM feat_lab.articles
WHERE title % 'full text';          -- similarity
-- or: title ILIKE '%search%'
```

## vs Elasticsearch

Postgres FTS is enough for many apps (docs, blogs, admin search). Move out when you need heavy relevance tuning, multi-language analyzers at scale, or separate search SLAs.

## Takeaway

`@@` + `ts_rank` + GIN. Keep the vector updated (generated col or trigger). Trigram helps typos / ILIKE-ish search.
