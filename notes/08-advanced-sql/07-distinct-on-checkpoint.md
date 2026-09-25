# DISTINCT ON and the checkpoint

## `DISTINCT ON` (Postgres)

Keep the **first** row per expression after `ORDER BY`:

```sql
SELECT DISTINCT ON (employee_id)
  employee_id, sold_on, amount
FROM adv_lab.sales
ORDER BY employee_id, sold_on DESC;
-- latest sale per employee
```

`ORDER BY` must start with the `DISTINCT ON` expressions. Portable alternative: `ROW_NUMBER() … WHERE rn = 1`.

## Checkpoint — kill the app loop

**Bad (app):** fetch all sales → loop employees → track max amount in JS.

**Good (SQL):**

```sql
-- Window approach
WITH ranked AS (
  SELECT
    e.name,
    s.amount,
    s.sold_on,
    row_number() OVER (
      PARTITION BY s.employee_id
      ORDER BY s.amount DESC, s.sold_on DESC
    ) AS rn
  FROM adv_lab.sales s
  JOIN adv_lab.employees e ON e.id = s.employee_id
)
SELECT name, amount, sold_on
FROM ranked
WHERE rn = 1
ORDER BY name;
```

Or recursive: “all engineers under Ben” without walking the tree in the API.

```sql
WITH RECURSIVE eng AS (
  SELECT id, name, manager_id FROM adv_lab.employees WHERE name = 'Ben'
  UNION ALL
  SELECT e.id, e.name, e.manager_id
  FROM adv_lab.employees e
  JOIN eng ON e.manager_id = eng.id
)
SELECT * FROM eng ORDER BY name;
```

## Takeaway

`DISTINCT ON` for “first row per group” in Postgres. Checkpoint: windows/recursion in SQL beat procedural loops for these shapes.
