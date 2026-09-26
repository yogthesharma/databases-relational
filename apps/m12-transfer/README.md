# m12-transfer

Module 12 checkpoint: move money between `app_lab.accounts` with parameterized SQL and a real transaction.

```bash
# from repo root
docker compose exec -T postgres psql -U postgres -d learn < docker/init/12-module12-app-lab.sql

cd apps/m12-transfer
npm install
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/learn npm run transfer -- alice bob 25
```
