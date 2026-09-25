# Lost update (checkpoint)

## The race

Two sessions read stock `10`, each sell `1`, each write `9` → stock ends at **9** instead of **8**. Classic **lost update**.

### Reproduce (two terminals — reset lab first)

Both start from `WIDGET` stock = 10.

**Session A:**

```sql
BEGIN;
SELECT stock FROM tx_lab.products WHERE sku = 'WIDGET';  -- 10
-- pause here
```

**Session B:**

```sql
BEGIN;
SELECT stock FROM tx_lab.products WHERE sku = 'WIDGET';  -- 10
UPDATE tx_lab.products SET stock = 9 WHERE sku = 'WIDGET';  -- 10 - 1
COMMIT;
```

**Session A (continues):**

```sql
UPDATE tx_lab.products SET stock = 9 WHERE sku = 'WIDGET';  -- also thinks 10 - 1
COMMIT;
SELECT stock FROM tx_lab.products WHERE sku = 'WIDGET';  -- 9  ← lost a sale
```

## Fix 1 — atomic UPDATE (simplest)

Don’t read-then-write in the app. Let SQL compute:

```sql
UPDATE tx_lab.products
SET stock = stock - 1
WHERE sku = 'WIDGET' AND stock >= 1
RETURNING stock;
-- 0 rows → out of stock
```

## Fix 2 — `SELECT … FOR UPDATE`

```sql
BEGIN;
SELECT stock FROM tx_lab.products WHERE sku = 'WIDGET' FOR UPDATE;
-- B blocks here until A commits
UPDATE tx_lab.products SET stock = stock - 1 WHERE sku = 'WIDGET';
COMMIT;
```

## Fix 3 — constraints + careful txn

`CHECK (stock >= 0)` stops negatives; still need atomic decrement or locking so two sales don’t clobber each other.

## Takeaway

Lost updates come from read → decide → write without locking or atomic SQL. Prefer `UPDATE … SET stock = stock - 1`, or `FOR UPDATE` inside a transaction.
