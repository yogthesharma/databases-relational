# JSON and JSONB

## When columns win vs documents

| Prefer real columns | Prefer `JSONB` |
|---------------------|----------------|
| Filter/sort/join often | Rarely queried bag of optional attrs |
| Need FKs / strong types | Per-row shape varies |
| Constraints matter | Prototyping / vendor payloads |

Lab: product `attrs` is document-ish; `price` / `sku` stay columns.

## `JSON` vs `JSONB`

Use **`JSONB`** (binary, indexable, no duplicate keys). Plain `JSON` stores text as-written — almost never what you want.

## Operators (starter set)

```sql
SELECT sku, attrs->>'color' AS color          -- text
FROM types_lab.products;

SELECT sku, attrs->'warranty_months'          -- jsonb
FROM types_lab.products
WHERE attrs ? 'warranty_months';              -- key exists

SELECT sku FROM types_lab.products
WHERE attrs @> '{"dimmable": true}'::jsonb;

SELECT sku, jsonb_array_elements_text(attrs->'regions') AS region
FROM types_lab.products
WHERE attrs ? 'regions';
```

## Node angle

Pass objects with `JSON.stringify` or let `pg` handle JS objects into `jsonb`. Read back as objects. Don’t shove your entire app model into one `data jsonb` column.

## Deeper later

GIN indexes, path queries, and “when JSONB is the feature” → Module 9. Here: choose the type and query basics.

## Takeaway

Columns for the contract; `JSONB` for flexible leftovers. Prefer `JSONB` over `JSON`.
