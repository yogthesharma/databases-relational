# RLS, LISTEN/NOTIFY, and checkpoint

## Row Level Security (overview)

Policies add invisible `WHERE` filters for a role.

```sql
-- Lab policy (simplified): see published rows OR rows you authored
-- author match uses: current_setting('app.user_key', true)

SET app.user_key = 'chen';
SET ROLE feat_reader;
SELECT slug, is_published, author_key FROM feat_lab.articles;
RESET ROLE;
```

Table **owners bypass RLS** unless `ALTER TABLE … FORCE ROW LEVEL SECURITY`. For demos as `postgres`, either `SET ROLE feat_reader` or force RLS.

## LISTEN / NOTIFY (optional)

Lightweight pub/sub on a connection:

```sql
-- Session A:
LISTEN article_events;

-- Session B:
NOTIFY article_events, 'slug=postgres-jsonb';
```

Good for cache invalidation hints; not a queue replacement (payload size limits, no persistence).

## Checkpoint — pick one

Build **one** of:

1. **JSONB:** query published articles with tag `postgres` via `@>` (use GIN).  
2. **FTS:** search `search_vector` for `view | materialize` and order by `ts_rank`.  
3. **Matview:** `REFRESH` `tag_stats` after inserting a published article with a new tag; show the new count.

## Takeaway

RLS = DB-enforced tenancy filters. NOTIFY = optional push hint. Checkpoint = one real product feature, not a kitchen sink.
