# Module 7 — Indexing & performance (exercises)

Same DB `learn`. Use schema **`perf_lab`**.

## Reset anytime

```bash
docker compose exec -T postgres psql -U postgres -d learn < docker/init/07-module7-perf-lab.sql
```

That rebuilds ~50k orders and drops indexes you added.

| # | File |
|---|------|
| 01 | [01-planner-and-explain.md](./01-planner-and-explain.md) |
| 02 | [02-btree-indexes.md](./02-btree-indexes.md) |
| 03 | [03-composite-and-covering.md](./03-composite-and-covering.md) |
| 04 | [04-partial-and-expression.md](./04-partial-and-expression.md) |
| 05 | [05-other-index-types.md](./05-other-index-types.md) |
| 06 | [06-slow-query-patterns.md](./06-slow-query-patterns.md) |
| 07 | [07-stats-vacuum-checkpoint.md](./07-stats-vacuum-checkpoint.md) |

Solutions at the bottom of each file.
