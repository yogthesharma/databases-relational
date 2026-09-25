# Exercise: UPDATE / DELETE / TRUNCATE

Read: `notes/03-writing-and-integrity/02-update-delete-truncate.md`

## Tasks

1. Raise price of `WL-001` to `10.99` and set `updated_at = now()`.
2. Decrement `stock` by 2 for `WL-002` only if stock ≥ 2.
3. Delete all notes for item id `3`.
4. What’s dangerous about `DELETE FROM write_lab.items;` with no WHERE?
5. When would you use `TRUNCATE` instead of `DELETE` in this lab?

## Stretch

Update: set `is_active = false` for every item with `stock = 0` (you may insert a zero-stock row first).

---

## Solutions

```sql
BEGIN;

-- 1
UPDATE write_lab.items
SET price = 10.99, updated_at = now()
WHERE sku = 'WL-001';

-- 2
UPDATE write_lab.items
SET stock = stock - 2, updated_at = now()
WHERE sku = 'WL-002' AND stock >= 2;

-- 3
DELETE FROM write_lab.item_notes WHERE item_id = 3;

ROLLBACK;
```

4. Deletes **every** row (and cascades to all `item_notes`).
5. Resetting the whole lab/table quickly in dev — not for “delete one user” in an API.

Stretch:

```sql
BEGIN;
INSERT INTO write_lab.items (sku, title, price, stock)
VALUES ('WL-000', 'Empty', 1.00, 0);
UPDATE write_lab.items SET is_active = false WHERE stock = 0;
ROLLBACK;
```
