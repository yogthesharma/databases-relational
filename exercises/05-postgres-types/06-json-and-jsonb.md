# Exercise: JSON / JSONB

Read: `notes/05-postgres-types/06-json-and-jsonb.md`

## Tasks

1. Why prefer `JSONB` over `JSON`?
2. Select `sku` and `attrs->>'color'` for products that have a `color` key.
3. Find products where `attrs` contains `"dimmable": true`.
4. Should `price` have been `JSONB` instead of `NUMERIC`? Why/why not?
5. Expand `regions` for the Travel Adapter into one row per region.

## Stretch

Set `attrs = attrs || '{"warranty_months": 24}'::jsonb` on `TP-001` and re-read color + warranty.

---

## Solutions

1. Binary storage, deduped keys, indexable, equality that makes sense — default choice.
2.

```sql
SELECT sku, attrs->>'color' AS color
FROM types_lab.products
WHERE attrs ? 'color';
```

3.

```sql
SELECT sku FROM types_lab.products
WHERE attrs @> '{"dimmable": true}'::jsonb;
```

4. **No** — price is core, typed, constrained, summed; belongs in a column.
5.

```sql
SELECT sku, jsonb_array_elements_text(attrs->'regions') AS region
FROM types_lab.products
WHERE sku = 'TP-004';
```

Stretch:

```sql
UPDATE types_lab.products
SET attrs = attrs || '{"warranty_months": 24}'::jsonb
WHERE sku = 'TP-001';

SELECT sku, attrs->>'color', attrs->>'warranty_months'
FROM types_lab.products WHERE sku = 'TP-001';
```
