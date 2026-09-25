# INSERT

## Goal

Add rows. In Node this is every `POST` that persists data.

## Basic forms

```sql
-- Column list (prefer this)
INSERT INTO write_lab.tags (name)
VALUES ('furniture');

-- Multiple rows
INSERT INTO write_lab.tags (name)
VALUES ('outdoor'), ('kitchen');
```

Always name columns — order and “insert everything” break when the table evolves.

## Insert from a query

```sql
INSERT INTO write_lab.tags (name)
SELECT 'from-select'
WHERE NOT EXISTS (
  SELECT 1 FROM write_lab.tags WHERE name = 'from-select'
);
```

## Defaults

Omit a column that has a default — Postgres fills it:

```sql
INSERT INTO write_lab.items (sku, title, price)
VALUES ('WL-100', 'Stapler', 3.25);
-- stock defaults to 0, is_active to true, created_at to now()
```

## Failures are good

```sql
-- duplicate sku → unique violation
INSERT INTO write_lab.items (sku, title, price)
VALUES ('WL-001', 'Dup', 1.00);
```

Your API should map these to 409/400 — don’t only validate in JS.

## Node

```js
const { rows } = await pool.query(
  `INSERT INTO write_lab.items (sku, title, price, stock)
   VALUES ($1, $2, $3, $4)
   RETURNING id, sku, created_at`,
  ['WL-200', 'Pen', 1.5, 50]
);
```

(`RETURNING` is the next note — use it so you don’t need a second SELECT.)

## Search path tip

Qualify with `write_lab.` or:

```sql
SET search_path TO write_lab, public;
```

## Takeaway

Named columns + parameters. Let constraints reject bad data. Prefer `RETURNING` on insert for APIs.
