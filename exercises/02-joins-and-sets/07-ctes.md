# Exercise: CTEs

Read: `notes/02-joins-and-sets/07-ctes.md`

## Tasks

1. Using a CTE `shipped`: list each employee `first_name` and how many **shipped** orders they have (only people with ≥1 shipped).
2. Rewrite this subquery style as a CTE + join (same result):

```sql
SELECT first_name, salary
FROM employees
WHERE department = 'Engineering'
  AND salary > (SELECT avg(salary) FROM employees WHERE department = 'Engineering');
```

3. Two CTEs: `active_emps` and `order_counts` — for every active employee show `first_name`, `department`, and order count (0 if none).
4. When would you keep a plain `JOIN` instead of introducing a CTE?

## Stretch (optional preview)

Run the recursive “Maya → managers upward” example from the note. List each `first_name` with its `depth`.

---

## Solutions

```sql
-- 1
WITH shipped AS (
  SELECT employee_id
  FROM orders
  WHERE status = 'shipped'
)
SELECT e.id, e.first_name, count(*) AS shipped_orders
FROM shipped s
JOIN employees e ON e.id = s.employee_id
GROUP BY e.id, e.first_name
ORDER BY shipped_orders DESC;

-- 2
WITH eng AS (
  SELECT id, first_name, salary
  FROM employees
  WHERE department = 'Engineering'
),
eng_avg AS (
  SELECT avg(salary) AS avg_salary FROM eng
)
SELECT e.first_name, e.salary
FROM eng e
WHERE e.salary > (SELECT avg_salary FROM eng_avg)
ORDER BY e.salary DESC;

-- 3
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

-- 4
Simple FK hops (order → employee → product) — a CTE adds ceremony without clarity.

-- Stretch (recursive preview from the note)
-- depth 1 = Maya, depth 2 = Ben (her manager), depth 3 = Asha (Ben's manager)
```
