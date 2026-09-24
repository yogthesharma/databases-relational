# Exercise: Outer and cross joins

Read: `notes/02-joins-and-sets/03-outer-and-cross-joins.md`

## Tasks

1. All employees with their manager’s first name (include people with no manager).
2. Employees who have **never** placed an order.
3. All departments from `departments_budget` with employee `first_name` (Marketing should appear with NULL name).
4. Which department in `departments_budget` has no employees? Write it with `LEFT JOIN` + `WHERE … IS NULL` **or** with `EXCEPT` (either is fine).
5. Roughly how many rows does `SELECT * FROM employees CROSS JOIN products` return? (Compute: counts multiplied.)

## Stretch

For each employee: `first_name` and count of orders (0 if none) — hint: `LEFT JOIN` + `GROUP BY` + `count(o.id)`.

---

## Solutions

```sql
-- 1
SELECT e.first_name AS employee, m.first_name AS manager
FROM employees e
LEFT JOIN employees m ON m.id = e.manager_id
ORDER BY e.id;

-- 2
SELECT e.id, e.first_name
FROM employees e
LEFT JOIN orders o ON o.employee_id = e.id
WHERE o.id IS NULL
ORDER BY e.id;

-- 3
SELECT d.department, d.budget, e.first_name
FROM departments_budget d
LEFT JOIN employees e ON e.department = d.department
ORDER BY d.department, e.first_name;

-- 4
SELECT d.department
FROM departments_budget d
LEFT JOIN employees e ON e.department = d.department
WHERE e.id IS NULL;
-- or: SELECT department FROM departments_budget EXCEPT SELECT department FROM employees;

-- 5
-- 15 * 15 = 225

-- Stretch
SELECT e.first_name, count(o.id) AS order_count
FROM employees e
LEFT JOIN orders o ON o.employee_id = e.id
GROUP BY e.id, e.first_name
ORDER BY order_count DESC, e.first_name;
```
