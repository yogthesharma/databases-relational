# JSONB and GIN indexes

Module 5 covered choosing JSONB. Here: **query + index** it for products.

## Operators you’ll use

```sql
SELECT slug, attrs->>'level' AS level
FROM feat_lab.articles
WHERE attrs @> '{"tags":["jsonb"]}'::jsonb;

SELECT slug FROM feat_lab.articles WHERE attrs ? 'likes';
SELECT slug, (attrs->>'likes')::int AS likes
FROM feat_lab.articles
ORDER BY likes DESC NULLS LAST;
```

| Op | Meaning |
|----|---------|
| `->` / `->>` | Get jsonb / text field |
| `@>` | Contains |
| `?` | Top-level key exists |
| `?|` / `?&` | Any / all keys exist |

## GIN on JSONB

Lab already has:

```sql
-- CREATE INDEX articles_attrs_gin ON feat_lab.articles USING gin (attrs);
```

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT slug FROM feat_lab.articles
WHERE attrs @> '{"level":"advanced"}'::jsonb;
```

Tiny tables may still seq-scan — the pattern matters more than the ms here.

## When JSONB columns win

Optional bags, vendor payloads, sparse attrs. Keep `slug`, `title`, `is_published` as real columns.

## Takeaway

Containment (`@>`) + GIN is the product default for JSONB filters. Don’t put your primary keys in JSONB.
