# Constraints and FK actions

Constraints are rules the database enforces on every write — your last line of defense when a buggy route or race slips through.

## Core constraint types

| Constraint | Meaning | Lab example |
|------------|---------|-------------|
| `NOT NULL` | Column must have a value | `title` |
| `UNIQUE` | No duplicate values | `sku`, `tags.name` |
| `CHECK` | Expression must be true | `price >= 0`, `stock >= 0` |
| `PRIMARY KEY` | NOT NULL + UNIQUE identity | `items.id` |
| `FOREIGN KEY` | Value must exist in parent | `items.tag_id` → `tags.id` |

```sql
-- These fail (try each with BEGIN / ROLLBACK — or SAVEPOINT between attempts).
-- After an error, the transaction is aborted until ROLLBACK (or ROLLBACK TO savepoint).

INSERT INTO write_lab.items (sku, title, price) VALUES ('WL-X', NULL, 1);   -- NOT NULL (title)
INSERT INTO write_lab.items (sku, title, price) VALUES ('WL-001', 'x', 1); -- UNIQUE (sku)
INSERT INTO write_lab.items (sku, title, price) VALUES ('WL-9', 'x', -1);  -- CHECK (price)
INSERT INTO write_lab.items (sku, title, price, tag_id)
  VALUES ('WL-9', 'x', 1, 999);  -- FK (tag_id)
```

## FK actions (ON DELETE / ON UPDATE)

When the **parent** row changes:

| Action | Effect on child |
|--------|-----------------|
| `NO ACTION` / `RESTRICT` | Block parent delete/update if children exist (similar for beginners; RESTRICT is immediate) |
| `CASCADE` | Delete/update children too |
| `SET NULL` | Child FK becomes NULL (column must be nullable) |
| `SET DEFAULT` | Child FK set to default |

In the lab:

- `items.tag_id` → `tags(id)` **`ON DELETE SET NULL`**
- `item_notes.item_id` → `items(id)` **`ON DELETE CASCADE`**

```sql
-- Deleting tag leaves items; tag_id becomes NULL
-- Deleting an item deletes its notes automatically
```

Choose CASCADE only when the child has no meaning without the parent (notes on an item). Prefer RESTRICT/SET NULL when orphans would be dangerous or you need soft cleanup in app code.

## Naming & errors in Node

Postgres error code `23505` = unique_violation, `23503` = foreign_key_violation, `23514` = check_violation. Map them in your error middleware.

## Takeaway

Put integrity in the schema. Know your FK delete actions — CASCADE is powerful and easy to regret.
