# Module 9 — Postgres product features

Same DB `learn`. Practice in schema **`feat_lab`** (articles with JSONB + FTS + views/triggers/RLS).

**Apply / reset feat lab** (from repo root):

```bash
docker compose exec -T postgres psql -U postgres -d learn < docker/init/09-module9-feat-lab.sql
```

Extensions used: `pg_trgm`, `pgcrypto` (created if missing).

| # | Concept | Notes |
|---|---------|-------|
| 01 | JSONB + GIN | [01-jsonb-and-gin.md](./01-jsonb-and-gin.md) |
| 02 | Full-text search | [02-full-text-search.md](./02-full-text-search.md) |
| 03 | Extensions | [03-extensions.md](./03-extensions.md) |
| 04 | Views & matviews | [04-views-and-matviews.md](./04-views-and-matviews.md) |
| 05 | Functions & procedures | [05-functions-and-procedures.md](./05-functions-and-procedures.md) |
| 06 | Triggers | [06-triggers.md](./06-triggers.md) |
| 07 | RLS, NOTIFY & checkpoint | [07-rls-notify-checkpoint.md](./07-rls-notify-checkpoint.md) |

Matching exercises: `exercises/09-postgres-features/`.

**Checkpoint:** Ship one small feature using JSONB **or** FTS **or** a materialized view (not all three).
