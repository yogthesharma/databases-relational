# Module 9 — Postgres features (exercises)

Same DB `learn`. Use schema **`feat_lab`**.

## Reset anytime

```bash
docker compose exec -T postgres psql -U postgres -d learn < docker/init/09-module9-feat-lab.sql
```

| # | File |
|---|------|
| 01 | [01-jsonb-and-gin.md](./01-jsonb-and-gin.md) |
| 02 | [02-full-text-search.md](./02-full-text-search.md) |
| 03 | [03-extensions.md](./03-extensions.md) |
| 04 | [04-views-and-matviews.md](./04-views-and-matviews.md) |
| 05 | [05-functions-and-procedures.md](./05-functions-and-procedures.md) |
| 06 | [06-triggers.md](./06-triggers.md) |
| 07 | [07-rls-notify-checkpoint.md](./07-rls-notify-checkpoint.md) |

Solutions at the bottom of each file.
