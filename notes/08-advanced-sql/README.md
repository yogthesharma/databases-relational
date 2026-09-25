# Module 8 — Advanced SQL

Same DB `learn`. Practice in schema **`adv_lab`** (org chart + sales).

**Apply / reset adv lab** (from repo root):

```bash
docker compose exec -T postgres psql -U postgres -d learn < docker/init/08-module8-adv-lab.sql
```

| # | Concept | Notes |
|---|---------|-------|
| 01 | Window basics | [01-window-basics.md](./01-window-basics.md) |
| 02 | Ranking & running totals | [02-ranking-and-running.md](./02-ranking-and-running.md) |
| 03 | Recursive CTEs | [03-recursive-ctes.md](./03-recursive-ctes.md) |
| 04 | `LATERAL` joins | [04-lateral.md](./04-lateral.md) |
| 05 | `FILTER` aggregates | [05-filter-aggregates.md](./05-filter-aggregates.md) |
| 06 | GROUPING SETS / ROLLUP / CUBE | [06-grouping-sets.md](./06-grouping-sets.md) |
| 07 | `DISTINCT ON` & checkpoint | [07-distinct-on-checkpoint.md](./07-distinct-on-checkpoint.md) |

Matching exercises: `exercises/08-advanced-sql/`.

**Checkpoint:** Replace “loop in the app” with a window or recursive CTE.
