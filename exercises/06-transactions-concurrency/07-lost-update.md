# Exercise: Lost update (checkpoint)

Read: `notes/06-transactions-concurrency/07-lost-update.md`

Reset the lab so `WIDGET` stock is `10`.

## Tasks

1. Explain the lost-update race on `WIDGET` in two sentences.
2. Reproduce it with two sessions (read 10 → both write 9). What stock do you end with?
3. Reset. Fix with a single atomic `UPDATE` that decrements only if `stock >= 1`, using `RETURNING`.
4. Reset. Fix with `SELECT … FOR UPDATE` inside a transaction, then decrement.
5. Why doesn’t `CHECK (stock >= 0)` alone prevent lost updates?

## Stretch

Two atomic decrements in a row: show stock go `10 → 9 → 8`.

---

## Solutions

1. Two txns read the same stock and each write “old−1”, so one sale’s decrement is overwritten.
2. Final stock **9** (should have been 8).
3.

```sql
-- reset lab first
UPDATE tx_lab.products
SET stock = stock - 1
WHERE sku = 'WIDGET' AND stock >= 1
RETURNING sku, stock;
```

4.

```sql
BEGIN;
SELECT stock FROM tx_lab.products WHERE sku = 'WIDGET' FOR UPDATE;
UPDATE tx_lab.products SET stock = stock - 1 WHERE sku = 'WIDGET';
COMMIT;
```

5. It only blocks negatives; two writers can still both set `9` from `10`.

Stretch:

```sql
UPDATE tx_lab.products SET stock = stock - 1 WHERE sku = 'WIDGET' AND stock >= 1 RETURNING stock;
UPDATE tx_lab.products SET stock = stock - 1 WHERE sku = 'WIDGET' AND stock >= 1 RETURNING stock;
```
