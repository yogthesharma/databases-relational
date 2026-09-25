# Module 3 — Writing data & integrity (exercises)

Same DB `learn`. Mutate **`write_lab.*` only** unless a task says otherwise.

## Reset the lab anytime

```bash
docker compose exec -T postgres psql -U postgres -d learn < docker/init/03-module3-write-lab.sql
```

## Habit

```sql
BEGIN;
-- try writes here
ROLLBACK;   -- undo
-- or COMMIT; when you mean it
```

If a statement **errors**, run `ROLLBACK;` (or `ROLLBACK TO savepoint`) before more commands — the transaction stays aborted otherwise.

| # | File |
|---|------|
| 01 | [01-insert.md](./01-insert.md) |
| 02 | [02-update-delete-truncate.md](./02-update-delete-truncate.md) |
| 03 | [03-returning.md](./03-returning.md) |
| 04 | [04-constraints.md](./04-constraints.md) |
| 05 | [05-defaults-and-generated.md](./05-defaults-and-generated.md) |
| 06 | [06-upserts.md](./06-upserts.md) |
| 07 | [07-bulk-copy-overview.md](./07-bulk-copy-overview.md) |

Solutions at the bottom — try first.
