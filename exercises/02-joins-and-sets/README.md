# Module 2 — Joins & set thinking (exercises)

## Apply Module 2 seed (once)

Modules 0–1 used `employees` + `products`. Module 2 adds `orders` and `departments_budget`.

If those tables are missing (common if Postgres was already running before this file existed):

```bash
docker compose exec -T postgres psql -U postgres -d learn < docker/init/02-module2-seed.sql
```

(Run from the **repo root**.) Confirm:

```bash
docker compose exec postgres psql -U postgres -d learn -c '\dt'
```

You should see `orders` and `departments_budget` as well.

| # | File |
|---|------|
| 01 | [01-keys-and-relationships.md](./01-keys-and-relationships.md) |
| 02 | [02-inner-join.md](./02-inner-join.md) |
| 03 | [03-outer-and-cross-joins.md](./03-outer-and-cross-joins.md) |
| 04 | [04-join-pitfalls.md](./04-join-pitfalls.md) |
| 05 | [05-set-operations.md](./05-set-operations.md) |
| 06 | [06-subqueries-and-exists.md](./06-subqueries-and-exists.md) |
| 07 | [07-ctes.md](./07-ctes.md) |

Solutions at the bottom of each file — try first.
