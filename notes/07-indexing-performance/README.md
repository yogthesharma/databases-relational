# Module 7 — Indexing & query performance

Same DB `learn`. Practice in schema **`perf_lab`** (~5k users, ~50k orders — enough for plans to matter).

**Apply / reset perf lab** (from repo root; takes a few seconds):

```bash
docker compose exec -T postgres psql -U postgres -d learn < docker/init/07-module7-perf-lab.sql
```

Reset wipes indexes you created. PK indexes remain only after a fresh seed until you add more.

| # | Concept | Notes |
|---|---------|-------|
| 01 | Planner & `EXPLAIN` | [01-planner-and-explain.md](./01-planner-and-explain.md) |
| 02 | B-tree indexes | [02-btree-indexes.md](./02-btree-indexes.md) |
| 03 | Composite & covering | [03-composite-and-covering.md](./03-composite-and-covering.md) |
| 04 | Partial & expression indexes | [04-partial-and-expression.md](./04-partial-and-expression.md) |
| 05 | Other index types (awareness) | [05-other-index-types.md](./05-other-index-types.md) |
| 06 | Slow-query patterns | [06-slow-query-patterns.md](./06-slow-query-patterns.md) |
| 07 | Stats, vacuum & checkpoint | [07-stats-vacuum-checkpoint.md](./07-stats-vacuum-checkpoint.md) |

Matching exercises: `exercises/07-indexing-performance/`.

**Checkpoint:** `EXPLAIN ANALYZE` a slow filter → add the right index → prove a better plan.
