# Exercise: RETURNING

Read: `notes/03-writing-and-integrity/03-returning.md`

## Tasks

1. Insert tag `gadgets` and return `id, name` in the same statement.
2. Update `WL-003` stock to `stock + 5`; return `sku, stock, updated_at` (set `updated_at`).
3. Delete one note (any id that exists) and return the deleted row.
4. Insert two tags `alpha`, `beta` with one INSERT and return both ids.
5. In a Node API, why is `RETURNING *` after INSERT better than insert-then-select-by-sku?

## Stretch

Update price of `WL-001` and return `price` and `price_cents` together.

---

## Solutions

```sql
BEGIN;

-- 1
INSERT INTO write_lab.tags (name)
VALUES ('gadgets')
RETURNING id, name;

-- 2
UPDATE write_lab.items
SET stock = stock + 5, updated_at = now()
WHERE sku = 'WL-003'
RETURNING sku, stock, updated_at;

-- 3
DELETE FROM write_lab.item_notes
WHERE id = 1
RETURNING *;

-- 4
INSERT INTO write_lab.tags (name)
VALUES ('alpha'), ('beta')
RETURNING id, name;

-- Stretch
UPDATE write_lab.items
SET price = 12.34
WHERE sku = 'WL-001'
RETURNING price, price_cents;

ROLLBACK;
```

5. One round-trip; no race; you get DB defaults/generated values immediately for the JSON response.
