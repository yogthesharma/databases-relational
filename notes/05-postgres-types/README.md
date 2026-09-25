# Module 5 — PostgreSQL types

Same DB `learn`. Practice in schema **`types_lab`** (catalog + customers + orders).

**Apply / reset types lab** (from repo root):

```bash
docker compose exec -T postgres psql -U postgres -d learn < docker/init/05-module5-types-lab.sql
```

| # | Concept | Notes |
|---|---------|-------|
| 01 | Numeric types | [01-numeric.md](./01-numeric.md) |
| 02 | Text & collations | [02-text.md](./02-text.md) |
| 03 | Temporal types | [03-temporal.md](./03-temporal.md) |
| 04 | Boolean, UUID, arrays | [04-boolean-uuid-arrays.md](./04-boolean-uuid-arrays.md) |
| 05 | Enums & domains | [05-enums-and-domains.md](./05-enums-and-domains.md) |
| 06 | JSON / JSONB | [06-json-and-jsonb.md](./06-json-and-jsonb.md) |
| 07 | inet, ranges & type choices | [07-inet-and-ranges.md](./07-inet-and-ranges.md) |

Matching exercises: `exercises/05-postgres-types/`.

**Checkpoint:** Justify the type of every important column in a small app schema.
