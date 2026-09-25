# Enums and domains

## Enum (`CREATE TYPE ... AS ENUM`)

Fixed set of labels stored efficiently:

```sql
SELECT enum_range(NULL::types_lab.order_status);
-- {pending,paid,shipped,cancelled}

SELECT id, status FROM types_lab.orders WHERE status = 'paid';
```

| Pros | Cons |
|------|------|
| Typo-proof vs free text | Adding/renaming values needs `ALTER TYPE` |
| Clear in `\dT` | Can’t attach extra metadata (label, sort order) |

For lists that grow or need metadata, prefer a **lookup table** (Module 4). Enums shine for tiny stable sets.

## Domain (`CREATE DOMAIN`)

A domain is a base type + optional constraint, reusable:

```sql
-- Already in the lab:
-- CREATE DOMAIN types_lab.money_amount AS NUMERIC(12,2) CHECK (VALUE >= 0);

SELECT pg_typeof(price) FROM types_lab.products LIMIT 1;
```

Use domains when many columns share the same rule (`email_text`, `money_amount`, `nonempty_text`). Changing the domain updates the rule in one place (with migration care).

## Enum vs check vs lookup

| Approach | Best for |
|----------|----------|
| `ENUM` | 2–8 frozen labels |
| `TEXT` + `CHECK` | Small set, easy to edit in migrations |
| Lookup table | Growing list, labels, i18n, FK reuse |

## Takeaway

Enums = tiny frozen vocabularies. Domains = reusable typed constraints. Lookup tables when the set is data, not a type.
