# Exercise: RLS, NOTIFY & checkpoint

Read: `notes/09-postgres-features/07-rls-notify-checkpoint.md`

Reset if you mutated data heavily.

## Tasks

1. As `feat_reader` with `app.user_key = 'chen'`, which article slugs are visible? Why?
2. Why might `postgres` see all rows even with RLS enabled?
3. Write a `NOTIFY` of channel `article_events` with payload `slug=draft-rls`.
4. One sentence: when is LISTEN/NOTIFY a bad queue substitute?
5. **Checkpoint (pick one and run it):**
   - JSONB: published articles with tag `postgres`
   - FTS: `search_vector` matches `view | materialize`, order by rank
   - Matview: refresh `tag_stats` after adding a tagged published article

## Stretch

`ALTER TABLE feat_lab.articles FORCE ROW LEVEL SECURITY;` then select as table owner — what changes? (Reset lab after.)

---

## Solutions

1.

```sql
SET app.user_key = 'chen';
SET ROLE feat_reader;
SELECT slug, is_published, author_key FROM feat_lab.articles;
RESET ROLE;
```

Published rows **plus** `draft-rls` (author `chen`).

2. Owners bypass RLS unless `FORCE ROW LEVEL SECURITY`.
3. `NOTIFY article_events, 'slug=draft-rls';`
4. No persistence, limited payload, delivery only to live listeners.
5. Examples:

```sql
-- JSONB
SELECT slug FROM feat_lab.articles
WHERE is_published AND attrs @> '{"tags":["postgres"]}'::jsonb;

-- FTS
SELECT slug, ts_rank(search_vector, q) AS rank
FROM feat_lab.articles, to_tsquery('english', 'view | materialize') q
WHERE search_vector @@ q
ORDER BY rank DESC;

-- Matview: INSERT published article with new tag, then:
REFRESH MATERIALIZED VIEW feat_lab.tag_stats;
SELECT * FROM feat_lab.tag_stats ORDER BY article_count DESC;
```

Stretch: owner also becomes subject to policies until you drop FORCE / reset lab.
