# Boolean, UUID, arrays

## Boolean

```sql
SELECT sku, is_active FROM types_lab.products WHERE is_active;
-- WHERE is_active  ≡  WHERE is_active = TRUE
```

Prefer real `BOOLEAN` over `'Y'/'N'` text. In SQL, only `TRUE` / `FALSE` / `NULL` — unknown is `NULL`, not a fourth state you invent.

## UUID

```sql
SELECT id, email FROM types_lab.customers;
-- id is UUID, default gen_random_uuid() (built into Postgres 13+)
```

| | UUID PK | `SERIAL` / identity |
|--|---------|---------------------|
| Pros | Opaque, merge-friendly, no sequence guessability | Compact, readable, fast indexes |
| Cons | Larger indexes; random inserts can fragment | Sequential, guessable |

Both are fine. Many APIs expose UUID externally and keep integer PKs internally — pick one story and stick to it.

## Arrays

```sql
SELECT sku, tags FROM types_lab.products WHERE 'usb' = ANY (tags);
SELECT sku, tags[1] AS first_tag FROM types_lab.products;
SELECT sku FROM types_lab.products WHERE tags @> ARRAY['desk'];
```

Arrays are great for **small tags / short lists**. They’re a poor substitute for a real child table when you need FKs, per-item attributes, or heavy filtering — normalize then (Module 4 habits).

## Node / `pg`

Booleans map cleanly. UUIDs arrive as strings. Arrays become JS arrays for text/int arrays.

## Takeaway

`BOOLEAN` for flags. UUID when you want opaque IDs. Arrays for small multi-values — not a free pass to skip tables.
