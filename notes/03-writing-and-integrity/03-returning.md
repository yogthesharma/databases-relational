# RETURNING

## Idea

Postgres can return the rows a write touched — no follow-up `SELECT`.

```sql
INSERT INTO write_lab.tags (name)
VALUES ('gadgets')
RETURNING id, name;
```

```sql
UPDATE write_lab.items
SET stock = stock + 5, updated_at = now()
WHERE sku = 'WL-002'
RETURNING id, sku, stock, updated_at;
```

```sql
DELETE FROM write_lab.item_notes
WHERE id = 1
RETURNING id, item_id, body;
```

## Why Node cares

Classic awkward flow:

1. `INSERT`
2. `SELECT` by sku / `currval` / guess

Better:

```js
const { rows } = await pool.query(
  `INSERT INTO write_lab.items (sku, title, price)
   VALUES ($1, $2, $3)
   RETURNING *`,
  [sku, title, price]
);
res.status(201).json(rows[0]);
```

Same for PATCH/DELETE responses.

## With multiple rows

```sql
INSERT INTO write_lab.tags (name)
VALUES ('a'), ('b')
RETURNING id, name;
```

Returns one result row per inserted row.

## Takeaway

Use `RETURNING` on INSERT/UPDATE/DELETE in APIs. It’s a Postgres (and some other DB) feature — not universal SQL, but standard in this stack.
