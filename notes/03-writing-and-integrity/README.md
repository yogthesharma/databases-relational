# Module 3 — Writing data & integrity

Same database `learn`. Practice writes in schema **`write_lab`** so Module 1–2 tables stay intact.

**Apply / reset write lab** (from repo root; safe to re-run anytime):

```bash
docker compose exec -T postgres psql -U postgres -d learn < docker/init/03-module3-write-lab.sql
```

Prefer `BEGIN;` … try writes … `ROLLBACK;` while learning.

**If a statement errors:** the open transaction is aborted until you `ROLLBACK` (or `ROLLBACK TO savepoint`). Don’t stack failing inserts without savepoints.


| # | Concept | Notes |
|---|---------|-------|
| 01 | INSERT | [01-insert.md](./01-insert.md) |
| 02 | UPDATE / DELETE / TRUNCATE | [02-update-delete-truncate.md](./02-update-delete-truncate.md) |
| 03 | RETURNING | [03-returning.md](./03-returning.md) |
| 04 | Constraints & FK actions | [04-constraints.md](./04-constraints.md) |
| 05 | Defaults & generated columns | [05-defaults-and-generated.md](./05-defaults-and-generated.md) |
| 06 | Upserts (ON CONFLICT) | [06-upserts.md](./06-upserts.md) |
| 07 | Bulk load (COPY overview) | [07-bulk-copy-overview.md](./07-bulk-copy-overview.md) |

Matching exercises: `exercises/03-writing-and-integrity/`.

**Checkpoint:** Invalid states fail at the DB; successful writes use `RETURNING` / upserts cleanly.
