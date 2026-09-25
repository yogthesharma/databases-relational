# Exercise: Upserts

Read: `notes/03-writing-and-integrity/06-upserts.md`

## Tasks

1. Upsert sku `WL-001`: set title to `USB Cable Pro`, price to `11.99` on conflict; `RETURNING` id, sku, title, price.
2. Insert tag `electronics` with `ON CONFLICT (name) DO NOTHING` — confirm no error and empty/partial return.
3. Upsert `WL-002` adding `10` to existing stock on conflict (`stock = items.stock + EXCLUDED.stock`).
4. Insert a **new** sku `WL-777` via the same upsert shape (should insert, not update).
5. Why is upsert safer than “SELECT then INSERT or UPDATE” in a busy API?

## Stretch

`DO UPDATE` only when the new price is higher than the old price (`WHERE` on the update clause).

---

## Solutions

```sql
BEGIN;

-- 1
INSERT INTO write_lab.items (sku, title, price, stock)
VALUES ('WL-001', 'USB Cable Pro', 11.99, 40)
ON CONFLICT (sku) DO UPDATE
SET title = EXCLUDED.title,
    price = EXCLUDED.price,
    updated_at = now()
RETURNING id, sku, title, price;

-- 2
INSERT INTO write_lab.tags (name)
VALUES ('electronics')
ON CONFLICT (name) DO NOTHING
RETURNING id, name;

-- 3
INSERT INTO write_lab.items (sku, title, price, stock)
VALUES ('WL-002', 'Notebook Pack', 4.50, 10)
ON CONFLICT (sku) DO UPDATE
SET stock = write_lab.items.stock + EXCLUDED.stock,
    updated_at = now()
RETURNING sku, stock;

-- 4
INSERT INTO write_lab.items (sku, title, price, stock)
VALUES ('WL-777', 'New Thing', 19.00, 5)
ON CONFLICT (sku) DO UPDATE
SET title = EXCLUDED.title,
    price = EXCLUDED.price,
    updated_at = now()
RETURNING *;

ROLLBACK;
```

5. Two requests can both “not find” the row and both insert — unique error or duplicates. Upsert is one atomic statement.

Stretch:

```sql
BEGIN;
-- price goes up (WHERE passes) → row updated, RETURNING has a row
INSERT INTO write_lab.items (sku, title, price, stock)
VALUES ('WL-001', 'USB Cable', 100.00, 40)
ON CONFLICT (sku) DO UPDATE
SET price = EXCLUDED.price,
    updated_at = now()
WHERE write_lab.items.price < EXCLUDED.price
RETURNING sku, price;

-- lower price (WHERE fails) → existing row unchanged, RETURNING empty (INSERT 0 0)
INSERT INTO write_lab.items (sku, title, price, stock)
VALUES ('WL-001', 'USB Cable', 1.00, 40)
ON CONFLICT (sku) DO UPDATE
SET price = EXCLUDED.price,
    updated_at = now()
WHERE write_lab.items.price < EXCLUDED.price
RETURNING sku, price;
ROLLBACK;
```
