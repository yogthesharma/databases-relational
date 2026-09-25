# Module 4 — Schema design (exercises)

Same DB `learn`. Use schema **`design_lab`**.

## Reset anytime

```bash
docker compose exec -T postgres psql -U postgres -d learn < docker/init/04-module4-design-lab.sql
```

That restores the messy `raw_enrollments` table and drops any tables you created in `design_lab`.

| # | File |
|---|------|
| 01 | [01-entities-and-relationships.md](./01-entities-and-relationships.md) |
| 02 | [02-keys.md](./02-keys.md) |
| 03 | [03-normalization.md](./03-normalization.md) |
| 04 | [04-bcnf-and-denormalization.md](./04-bcnf-and-denormalization.md) |
| 05 | [05-naming-and-schemas.md](./05-naming-and-schemas.md) |
| 06 | [06-migrations-mindset.md](./06-migrations-mindset.md) |
| 07 | [07-modeling-patterns.md](./07-modeling-patterns.md) |

Solutions at the bottom — design answers can vary slightly; match the intent.
