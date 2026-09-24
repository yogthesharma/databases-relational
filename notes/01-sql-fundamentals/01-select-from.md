# SELECT and FROM

## Mental model

`SELECT` chooses **columns** (or expressions). `FROM` chooses the **table**. Postgres returns a **result set** (rows) — what your Node `pool.query` puts in `rows`.

```sql
SELECT first_name, last_name, department
FROM employees;
```

## Select everything vs explicit columns

```sql
SELECT * FROM products;           -- fine for exploring
SELECT sku, name, price FROM products;  -- better in APIs
```

In Node APIs, prefer **explicit columns**. `SELECT *` over-fetches, breaks when columns are added, and makes response shapes unstable.

## Expressions

```sql
SELECT
  first_name,
  salary,
  salary / 12 AS monthly   -- expression (alias covered soon)
FROM employees;
```

## One table for now

Joins come in Module 2. Here every query has a single `FROM` table.

## Node shape

```js
const { rows } = await pool.query(
  'SELECT id, first_name, department FROM employees'
);
// rows → [{ id: 1, first_name: 'Asha', department: 'Engineering' }, ...]
```

## Takeaway

`SELECT` projects columns; `FROM` picks the relation. Be intentional about columns in application queries.
