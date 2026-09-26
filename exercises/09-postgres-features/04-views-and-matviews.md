# Exercise: Views & matviews

Read: `notes/09-postgres-features/04-views-and-matviews.md`

## Tasks

1. Select from `feat_lab.published_articles` — how many rows vs base `articles`?
2. What’s the freshness difference between a view and a matview?
3. Select `tag_stats` ordered by `article_count` descending.
4. Insert a new **published** article with tag `extensions`, then `REFRESH MATERIALIZED VIEW feat_lab.tag_stats`. Did `extensions` appear?
5. When prefer a matview over querying live every time?

## Stretch

Why does `REFRESH … CONCURRENTLY` need a unique index?

---

## Solutions

1. View shows only `is_published` (3 on seed); base has 4 (includes draft).
2. View always current; matview until `REFRESH`.
3. `SELECT * FROM feat_lab.tag_stats ORDER BY article_count DESC;`
4.

```sql
INSERT INTO feat_lab.articles (slug, title, body, attrs, is_published)
VALUES (
  'ext-demo', 'Extension demo', 'Talking about pg_trgm.',
  '{"tags":["extensions","postgres"],"level":"beginner","likes":1}'::jsonb,
  TRUE
);
REFRESH MATERIALIZED VIEW feat_lab.tag_stats;
SELECT * FROM feat_lab.tag_stats WHERE tag = 'extensions';
```

5. Expensive aggregates / dashboards you can refresh on a schedule.

Stretch: so Postgres can replace rows concurrently without a full exclusive rewrite lock (unique index required).
