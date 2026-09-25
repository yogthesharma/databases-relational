# Exercise: Constraints

Read: `notes/03-writing-and-integrity/04-constraints.md`

Use `BEGIN` / `ROLLBACK`. Expect errors — that’s the point.

**Important:** after a statement errors, the transaction is aborted. Use a **SAVEPOINT** before each attempt (see solutions), or a fresh `BEGIN` per failure.

## Tasks

1. Attempt each bad insert; name the constraint that fires:
   - `title` NULL  
   - duplicate `sku` `WL-001`  
   - `price = -5`  
   - `tag_id = 999`
2. Delete tag `clearance`. What happens to items that pointed at it? (`SELECT` after delete.)
3. Delete item `WL-003`. What happens to its notes?
4. When is `ON DELETE CASCADE` appropriate vs `SET NULL`?
5. Which Postgres/SQLSTATE family would you map to HTTP 409 for a duplicate sku? (Unique violation.)

## Stretch

Try to delete a tag that is still referenced if we had `ON DELETE RESTRICT` — explain how the lab’s `SET NULL` differs.

---

## Solutions

After an error, Postgres **aborts the transaction** until `ROLLBACK` (or `ROLLBACK TO savepoint`). Use savepoints to try several failures in one transaction:

```sql
BEGIN;

-- 1a NOT NULL (title)
SAVEPOINT s1;
INSERT INTO write_lab.items (sku, title, price) VALUES ('WL-X', NULL, 1);
-- ERROR — then:
ROLLBACK TO s1;

-- 1b UNIQUE
SAVEPOINT s2;
INSERT INTO write_lab.items (sku, title, price) VALUES ('WL-001', 'Dup', 1);
ROLLBACK TO s2;

-- 1c CHECK
SAVEPOINT s3;
INSERT INTO write_lab.items (sku, title, price) VALUES ('WL-X', 'Bad', -5);
ROLLBACK TO s3;

-- 1d FOREIGN KEY
SAVEPOINT s4;
INSERT INTO write_lab.items (sku, title, price, tag_id)
VALUES ('WL-X', 'Bad', 1, 999);
ROLLBACK TO s4;

ROLLBACK;
```

Or run each failing insert in its own `BEGIN` … `ROLLBACK`.

```sql
BEGIN;
-- 2 SET NULL on items.tag_id
DELETE FROM write_lab.tags WHERE name = 'clearance';
SELECT sku, tag_id FROM write_lab.items WHERE sku = 'WL-004';
-- tag_id is NULL

-- 3 CASCADE notes
DELETE FROM write_lab.items WHERE sku = 'WL-003';
SELECT * FROM write_lab.item_notes WHERE item_id = 3;
-- no rows

ROLLBACK;
```

4. CASCADE: child rows are meaningless alone (notes). SET NULL: child can remain without a tag.
5. Unique violation — SQLSTATE `23505` → often HTTP 409 Conflict.

Stretch: RESTRICT/NO ACTION would **block** deleting the tag while items reference it; SET NULL allows the delete and clears the FK.
