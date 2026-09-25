# Exercise: INSERT

Read: `notes/03-writing-and-integrity/01-insert.md`

Reset lab if needed. Use `BEGIN` / `ROLLBACK` so retries stay clean.

## Tasks

1. Insert a tag named `furniture`; confirm with `SELECT`.
2. Insert two tags in one statement: `outdoor`, `kitchen`.
3. Insert item `WL-050` / `Binder` / price `6.00` **omitting** `stock` — what stock do you get?
4. Try inserting another item with sku `WL-001`. What happens?
5. Why should API inserts list column names instead of `INSERT INTO t VALUES (...)`?

## Stretch

Insert an item that references tag `office` by looking up `tag_id` in a subquery (or two-step).

---

## Solutions

```sql
BEGIN;

-- 1
INSERT INTO write_lab.tags (name) VALUES ('furniture');
SELECT * FROM write_lab.tags WHERE name = 'furniture';

-- 2
INSERT INTO write_lab.tags (name) VALUES ('outdoor'), ('kitchen');

-- 3
INSERT INTO write_lab.items (sku, title, price)
VALUES ('WL-050', 'Binder', 6.00);
-- stock = 0 (DEFAULT)

-- 4
INSERT INTO write_lab.items (sku, title, price)
VALUES ('WL-001', 'Dup', 1.00);
-- ERROR: unique violation on sku

ROLLBACK;
```

5. Column order/defaults change over time; named columns stay stable and clear.

Stretch:

```sql
BEGIN;
INSERT INTO write_lab.items (sku, title, price, tag_id)
VALUES (
  'WL-051',
  'Stapler',
  3.25,
  (SELECT id FROM write_lab.tags WHERE name = 'office')
);
ROLLBACK;
```
