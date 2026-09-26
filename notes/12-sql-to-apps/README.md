# Module 12 — From SQL to applications

Same DB `learn`. Practice against schema **`app_lab`** (alice / bob balances).

**Apply / reset app lab:**

```bash
docker compose exec -T postgres psql -U postgres -d learn < docker/init/12-module12-app-lab.sql
```

| # | Concept | Notes |
|---|---------|-------|
| 01 | ORM vs SQL | [01-orm-vs-sql.md](./01-orm-vs-sql.md) |
| 02 | N+1 & batching | [02-n-plus-one.md](./02-n-plus-one.md) |
| 03 | App transactions | [03-app-transactions.md](./03-app-transactions.md) |
| 04 | Migration tools | [04-migration-tools.md](./04-migration-tools.md) |
| 05 | Testing DB code | [05-testing-db-code.md](./05-testing-db-code.md) |
| 06 | Repositories | [06-repositories.md](./06-repositories.md) |
| 07 | Checkpoint: transfer | [07-checkpoint-transfer.md](./07-checkpoint-transfer.md) |

Matching exercises: `exercises/12-sql-to-apps/`.  
Checkpoint app: `apps/m12-transfer/`.

**Checkpoint:** Run a tiny Node script that transfers money with a real DB transaction and parameterized SQL.
