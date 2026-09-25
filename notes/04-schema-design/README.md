# Module 4 — Schema design & normalization

Same DB `learn`. Design work lives in schema **`design_lab`** (starts with a messy spreadsheet table).

**Apply / reset design lab** (from repo root):

```bash
docker compose exec -T postgres psql -U postgres -d learn < docker/init/04-module4-design-lab.sql
```

| # | Concept | Notes |
|---|---------|-------|
| 01 | Entities & relationships | [01-entities-and-relationships.md](./01-entities-and-relationships.md) |
| 02 | Keys | [02-keys.md](./02-keys.md) |
| 03 | Normalization (1NF–3NF) | [03-normalization.md](./03-normalization.md) |
| 04 | BCNF & denormalization | [04-bcnf-and-denormalization.md](./04-bcnf-and-denormalization.md) |
| 05 | Naming & schemas | [05-naming-and-schemas.md](./05-naming-and-schemas.md) |
| 06 | Migrations mindset | [06-migrations-mindset.md](./06-migrations-mindset.md) |
| 07 | Modeling patterns | [07-modeling-patterns.md](./07-modeling-patterns.md) |

Matching exercises: `exercises/04-schema-design/`.

**Checkpoint:** Turn `design_lab.raw_enrollments` into a normalized schema you can query cleanly.
