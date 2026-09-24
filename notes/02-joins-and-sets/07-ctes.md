# CTEs (`WITH`)

A CTE (common table expression) names a temporary result you can reuse in one statement — readability first, sometimes reuse.

## Basic shape

```sql
WITH shipped AS (
  SELECT employee_id, product_id, quantity
  FROM orders
  WHERE status = 'shipped'
)
SELECT e.id, e.first_name, count(*) AS shipped_orders
FROM shipped s
JOIN employees e ON e.id = s.employee_id
GROUP BY e.id, e.first_name
ORDER BY shipped_orders DESC;
```

Group by `e.id` (not only `first_name`) so two people with the same name never get merged.
## Why bother?

- Break complex logic into steps (like intermediate variables)
- Same structure as nested subqueries, easier to read
- Can chain multiple CTEs:

```sql
WITH
  active_emps AS (
    SELECT id, first_name, department
    FROM employees
    WHERE is_active
  ),
  order_counts AS (
    SELECT employee_id, count(*) AS n
    FROM orders
    GROUP BY employee_id
  )
SELECT a.first_name, a.department, coalesce(o.n, 0) AS orders
FROM active_emps a
LEFT JOIN order_counts o ON o.employee_id = a.id
ORDER BY orders DESC, a.first_name;
```

## CTE vs subquery

Same power for most Module 2 cases. Prefer CTE when nesting would get deep. Prefer a plain join when it’s a simple FK hop.

## Recursive CTEs (preview)

`WITH RECURSIVE` walks trees/graphs (org chart, category tree). You’ll use it for “manager → reports → …” later; not required to master yet.

```sql
-- Preview only: employee + all managers up the chain (simplified)
WITH RECURSIVE chain AS (
  SELECT id, first_name, manager_id, 1 AS depth
  FROM employees
  WHERE first_name = 'Maya'
  UNION ALL
  SELECT e.id, e.first_name, e.manager_id, c.depth + 1
  FROM employees e
  JOIN chain c ON e.id = c.manager_id
)
SELECT * FROM chain;
```

Skim this; exercises focus on non-recursive `WITH`.

## Node angle

CTEs are just SQL text in `pool.query`. Great for keeping report endpoints readable without moving logic into JS loops.

## Takeaway

`WITH` names intermediate results for clearer multi-step SQL. Use joins for simple relationships; CTEs when the query would otherwise nest awkwardly.
