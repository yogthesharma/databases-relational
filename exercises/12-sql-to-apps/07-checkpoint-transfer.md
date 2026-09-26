# 07 — Checkpoint: run the transfer app

```bash
# reset
docker compose exec -T postgres psql -U postgres -d learn < docker/init/12-module12-app-lab.sql

cd apps/m12-transfer
npm install
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/learn npm run transfer -- alice bob 25
```

Then in `psql`:

```sql
SELECT name, balance FROM app_lab.accounts ORDER BY name;
```

Expect alice `75.00`, bob `75.00`.

Optional: try `alice bob 1000` and confirm balances unchanged (insufficient funds).
