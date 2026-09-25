# Module 8 — Advanced SQL (exercises)

Same DB `learn`. Use schema **`adv_lab`**.

## Reset anytime

```bash
docker compose exec -T postgres psql -U postgres -d learn < docker/init/08-module8-adv-lab.sql
```

| # | File |
|---|------|
| 01 | [01-window-basics.md](./01-window-basics.md) |
| 02 | [02-ranking-and-running.md](./02-ranking-and-running.md) |
| 03 | [03-recursive-ctes.md](./03-recursive-ctes.md) |
| 04 | [04-lateral.md](./04-lateral.md) |
| 05 | [05-filter-aggregates.md](./05-filter-aggregates.md) |
| 06 | [06-grouping-sets.md](./06-grouping-sets.md) |
| 07 | [07-distinct-on-checkpoint.md](./07-distinct-on-checkpoint.md) |

Solutions at the bottom of each file.
