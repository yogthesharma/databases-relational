# Module 2 — Multi-table SQL (joins & set thinking)

Relate rows across tables. This module adds `orders` and `departments_budget`.

**If `\dt` does not show those tables** (Postgres was already running before they were added), apply once from the repo root:

```bash
docker compose exec -T postgres psql -U postgres -d learn < docker/init/02-module2-seed.sql
```

| # | Concept | Notes |
|---|---------|-------|
| 01 | Keys & relationships | [01-keys-and-relationships.md](./01-keys-and-relationships.md) |
| 02 | INNER JOIN | [02-inner-join.md](./02-inner-join.md) |
| 03 | Outer & cross joins | [03-outer-and-cross-joins.md](./03-outer-and-cross-joins.md) |
| 04 | Join pitfalls | [04-join-pitfalls.md](./04-join-pitfalls.md) |
| 05 | Set operations | [05-set-operations.md](./05-set-operations.md) |
| 06 | Subqueries & EXISTS | [06-subqueries-and-exists.md](./06-subqueries-and-exists.md) |
| 07 | CTEs | [07-ctes.md](./07-ctes.md) |

Matching exercises: `exercises/02-joins-and-sets/`.

**Checkpoint:** Rewrite a nested subquery as a join or CTE; know when `EXISTS` beats `IN`.
