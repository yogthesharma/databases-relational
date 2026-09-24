# INNER JOIN

## Idea

Return rows that have a **match on both sides**. Non-matching rows are dropped.

```sql
SELECT
  o.id AS order_id,
  e.first_name,
  p.name AS product_name,
  o.quantity,
  o.status
FROM orders AS o
INNER JOIN employees AS e ON e.id = o.employee_id
INNER JOIN products  AS p ON p.id = o.product_id
ORDER BY o.id;
```

`INNER JOIN` and `JOIN` mean the same thing in Postgres.

## Anatomy

```sql
FROM left_table
JOIN right_table ON <match condition>
```

- `ON` = how rows pair (usually FK = PK)
- Table aliases (`o`, `e`, `p`) keep multi-table queries readable — use them

## Self-join (same table twice)

```sql
SELECT
  e.first_name AS employee,
  m.first_name AS manager
FROM employees AS e
INNER JOIN employees AS m ON m.id = e.manager_id
ORDER BY e.first_name;
```

Employees with `manager_id IS NULL` disappear here — that’s INNER JOIN behavior. Use `LEFT JOIN` when you need them (next note).

## Filter after joining

```sql
SELECT e.first_name, p.name, o.status
FROM orders o
JOIN employees e ON e.id = o.employee_id
JOIN products  p ON p.id = o.product_id
WHERE o.status = 'shipped';
```

## Node angle

```js
const { rows } = await pool.query(
  `SELECT o.id, e.first_name, p.name, o.quantity
   FROM orders o
   JOIN employees e ON e.id = o.employee_id
   JOIN products  p ON p.id = o.product_id
   WHERE o.status = $1
   ORDER BY o.id`,
  ['shipped']
);
```

One query beats looping orders and querying products one-by-one.

## Takeaway

`INNER JOIN` = matches only. Alias tables. Prefer joining on keys, then filter with `WHERE`.
