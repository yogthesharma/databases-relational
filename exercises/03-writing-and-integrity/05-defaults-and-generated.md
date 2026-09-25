# Exercise: Defaults and generated columns

Read: `notes/03-writing-and-integrity/05-defaults-and-generated.md`

## Tasks

1. Insert `WL-120` / `Clip` / `1.25` with only those three columns. Select the row — report `stock`, `is_active`, and that `created_at` is set.
2. Select `price` and `price_cents` for `WL-002`.
3. Update `WL-002` price to `5.00`. Does `price_cents` become `500`?
4. Try to `UPDATE … SET price_cents = 999`. What happens?
5. Why enforce `stock >= 0` in a CHECK instead of only in Express middleware?

## Stretch

Insert an item with explicit `stock = DEFAULT` and `is_active = DEFAULT` in the VALUES list.

---

## Solutions

```sql
BEGIN;

-- 1
INSERT INTO write_lab.items (sku, title, price)
VALUES ('WL-120', 'Clip', 1.25)
RETURNING sku, stock, is_active, created_at;
-- stock 0, is_active true, created_at ≈ now()

-- 2
SELECT price, price_cents FROM write_lab.items WHERE sku = 'WL-002';

-- 3
UPDATE write_lab.items SET price = 5.00 WHERE sku = 'WL-002'
RETURNING price, price_cents;
-- price_cents = 500

-- 4
UPDATE write_lab.items SET price_cents = 999 WHERE sku = 'WL-002';
-- ERROR: column "price_cents" can only be updated to DEFAULT (generated column)

ROLLBACK;
```

5. Middleware can be bypassed (bugs, other clients, raw SQL). CHECK always applies.

Stretch:

```sql
BEGIN;
INSERT INTO write_lab.items (sku, title, price, stock, is_active)
VALUES ('WL-121', 'Pin', 0.50, DEFAULT, DEFAULT)
RETURNING *;
ROLLBACK;
```
