# Exercise: Subqueries and EXISTS

Read: `notes/02-joins-and-sets/06-subqueries-and-exists.md`

## Tasks

1. Employees earning **above** the company-wide average salary (active employees only in the average).
2. Employees who appear in `orders` (using `IN`).
3. Same as (2) using `EXISTS`.
4. Employees with **no** orders using `NOT EXISTS`.
5. Employees who have at least one **pending** order (`EXISTS`).
6. Why is `NOT EXISTS` safer than `NOT IN` when the subquery might return NULLs?

## Stretch

Products that have never been ordered (`NOT EXISTS` or `LEFT JOIN`).

---

## Solutions

```sql
-- 1
SELECT first_name, salary
FROM employees
WHERE salary > (
  SELECT avg(salary) FROM employees WHERE is_active
)
ORDER BY salary DESC;

-- 2
SELECT first_name, department
FROM employees
WHERE id IN (SELECT employee_id FROM orders);

-- 3
SELECT e.first_name, e.department
FROM employees e
WHERE EXISTS (
  SELECT 1 FROM orders o WHERE o.employee_id = e.id
);

-- 4
SELECT e.first_name
FROM employees e
WHERE NOT EXISTS (
  SELECT 1 FROM orders o WHERE o.employee_id = e.id
);

-- 5
SELECT e.first_name
FROM employees e
WHERE EXISTS (
  SELECT 1 FROM orders o
  WHERE o.employee_id = e.id AND o.status = 'pending'
);

-- 6
If the IN-list contains NULL, NOT IN becomes UNKNOWN for every row → empty result.
NOT EXISTS doesn’t have that trap.

-- Stretch
SELECT p.name
FROM products p
WHERE NOT EXISTS (
  SELECT 1 FROM orders o WHERE o.product_id = p.id
);
```
