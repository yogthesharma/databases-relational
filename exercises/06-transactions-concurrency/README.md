# Module 6 — Transactions & concurrency (exercises)

Same DB `learn`. Use schema **`tx_lab`**.

## Reset anytime

```bash
docker compose exec -T postgres psql -U postgres -d learn < docker/init/06-module6-tx-lab.sql
```

Two-session demos: open two terminals with  
`docker compose exec postgres psql -U postgres -d learn`  
and leave both open (closing rolls back open txns / releases locks).

| # | File |
|---|------|
| 01 | [01-transactions.md](./01-transactions.md) |
| 02 | [02-acid.md](./02-acid.md) |
| 03 | [03-isolation-levels.md](./03-isolation-levels.md) |
| 04 | [04-phenomena.md](./04-phenomena.md) |
| 05 | [05-locks-and-deadlocks.md](./05-locks-and-deadlocks.md) |
| 06 | [06-idempotency-and-retries.md](./06-idempotency-and-retries.md) |
| 07 | [07-lost-update.md](./07-lost-update.md) |

Solutions at the bottom of each file.
