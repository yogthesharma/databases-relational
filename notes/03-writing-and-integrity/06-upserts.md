# Upserts (`INSERT … ON CONFLICT`)

## Problem

“Create or update” — e.g. sync by `sku`, or idempotent `POST` with a natural key.

Naive approach: SELECT then INSERT or UPDATE → race conditions under concurrency.

## Postgres upsert

```sql
INSERT INTO write_lab.items (sku, title, price, stock)
VALUES ('WL-001', 'USB Cable Pro', 11.99, 40)
ON CONFLICT (sku) DO UPDATE
SET
  title = EXCLUDED.title,
  price = EXCLUDED.price,
  updated_at = now()
RETURNING id, sku, title, price;
```

- Conflict target: unique constraint/index columns — here `(sku)`.
- `EXCLUDED` = the row you tried to insert.
- `DO NOTHING` = skip on conflict (no error, no update).

```sql
INSERT INTO write_lab.tags (name)
VALUES ('electronics')
ON CONFLICT (name) DO NOTHING
RETURNING id, name;   -- empty if it already existed
```

## Partial updates

Only bump stock if inserting a known sku again:

```sql
INSERT INTO write_lab.items (sku, title, price, stock)
VALUES ('WL-002', 'Notebook Pack', 4.50, 10)
ON CONFLICT (sku) DO UPDATE
SET stock = write_lab.items.stock + EXCLUDED.stock,
    updated_at = now()
RETURNING sku, stock;
```

## Conditional update

You can attach a `WHERE` to `DO UPDATE`. If it fails, the existing row is **left unchanged** (and `RETURNING` is empty — `INSERT 0 0`):

```sql
INSERT INTO write_lab.items (sku, title, price, stock)
VALUES ('WL-001', 'USB Cable', 100.00, 40)
ON CONFLICT (sku) DO UPDATE
SET price = EXCLUDED.price,
    updated_at = now()
WHERE write_lab.items.price < EXCLUDED.price
RETURNING sku, price;
```

## Node

```js
await pool.query(
  `INSERT INTO write_lab.items (sku, title, price, stock)
   VALUES ($1, $2, $3, $4)
   ON CONFLICT (sku) DO UPDATE
   SET title = EXCLUDED.title,
       price = EXCLUDED.price,
       updated_at = now()
   RETURNING *`,
  [sku, title, price, stock]
);
```

## Takeaway

Prefer `ON CONFLICT` over check-then-insert for idempotent writes. Target a real UNIQUE/PK. Use `RETURNING` to see what happened.
