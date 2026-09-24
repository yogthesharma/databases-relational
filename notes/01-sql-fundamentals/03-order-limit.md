# ORDER BY, LIMIT, OFFSET

## Sorting

```sql
SELECT name, price
FROM products
ORDER BY price DESC;
```

Multiple keys:

```sql
SELECT first_name, department, salary
FROM employees
ORDER BY department ASC, salary DESC;
```

`ASC` is default. NULLs sort last in ASC by default in Postgres (`NULLS FIRST` / `NULLS LAST` to override).

## Limit

```sql
SELECT name, price FROM products
ORDER BY price DESC
LIMIT 5;          -- top 5 most expensive
```

## Offset pagination (know the trap)

```sql
SELECT id, name FROM products
ORDER BY id
LIMIT 10 OFFSET 20;   -- “page 3” if page size 10
```

**Problem:** Large `OFFSET` still makes Postgres walk/skips many rows — gets slower as pages deepen. Fine for admin UIs; for infinite scroll prefer **keyset** pagination later (`WHERE id > $lastId ORDER BY id LIMIT 10`).

## Stable order

If you `LIMIT` without `ORDER BY`, order is **undefined**. Always `ORDER BY` when you care about “top N” or pages.

## Node list endpoint pattern

```js
const limit = 20;
const offset = page * limit;
await pool.query(
  `SELECT id, name, price FROM products
   ORDER BY id
   LIMIT $1 OFFSET $2`,
  [limit, offset]
);
```

## Takeaway

`ORDER BY` defines sequence; `LIMIT` caps rows. Prefer keyset over deep `OFFSET` when lists grow.
