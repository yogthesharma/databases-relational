# Module 6 — Transactions, concurrency & ACID

Same DB `learn`. Practice in schema **`tx_lab`** (accounts, transfers, products).

**Apply / reset tx lab** (from repo root):

```bash
docker compose exec -T postgres psql -U postgres -d learn < docker/init/06-module6-tx-lab.sql
```

Some demos need **two `psql` sessions** (two terminals). Label them A and B. Keep both sessions open while the other runs — closing a session rolls back an open transaction and drops its locks.


| # | Concept | Notes |
|---|---------|-------|
| 01 | BEGIN / COMMIT / ROLLBACK / savepoints | [01-transactions.md](./01-transactions.md) |
| 02 | ACID in practice | [02-acid.md](./02-acid.md) |
| 03 | Isolation levels | [03-isolation-levels.md](./03-isolation-levels.md) |
| 04 | Concurrency phenomena | [04-phenomena.md](./04-phenomena.md) |
| 05 | Locks & deadlocks | [05-locks-and-deadlocks.md](./05-locks-and-deadlocks.md) |
| 06 | Idempotency & retries | [06-idempotency-and-retries.md](./06-idempotency-and-retries.md) |
| 07 | Lost update (checkpoint) | [07-lost-update.md](./07-lost-update.md) |

Matching exercises: `exercises/06-transactions-concurrency/`.

**Checkpoint:** Reproduce a lost update on stock, then fix it with a transaction + row lock (or atomic `UPDATE`).
