# Checkpoint — transactional transfer app

## Goal

Wire Node (`pg`) to `app_lab.accounts` and move money **inside one transaction**.

## Steps

1. Reset lab:

```bash
docker compose exec -T postgres psql -U postgres -d learn < docker/init/12-module12-app-lab.sql
```

2. From `apps/m12-transfer/`:

```bash
cp ../../.env.example .env   # or export DATABASE_URL
npm install
npm run transfer -- alice bob 25
```

3. Confirm:

```sql
SELECT name, balance FROM app_lab.accounts ORDER BY name;
-- alice 75.00, bob 75.00
```

4. Re-run a second transfer or try an amount that would go negative — constraint / app check should keep balances valid.

## Takeaway

Parameterized SQL + one client + `BEGIN`/`COMMIT`/`ROLLBACK` is the production pattern for multi-row money moves.
