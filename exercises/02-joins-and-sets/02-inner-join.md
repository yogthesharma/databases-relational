# Exercise: INNER JOIN

Read: `notes/02-joins-and-sets/02-inner-join.md`

## Tasks

Write SQL for:

1. All orders with employee `first_name`, product `name`, `quantity`, `status` (inner-join both).
2. Only **shipped** orders with the same columns as (1).
3. Self-join: each employee who has a manager — columns `employee`, `manager` (first names).
4. How many result rows does (3) return vs total employees (15)? Why the difference?
5. Orders placed by people in the **Sales** department (join `orders` → `employees`, filter department).

## Stretch

Total quantity ordered per product name (join + `GROUP BY`).

---

## Solutions

```sql
-- 1
SELECT o.id, e.first_name, p.name, o.quantity, o.status
FROM orders o
JOIN employees e ON e.id = o.employee_id
JOIN products  p ON p.id = o.product_id
ORDER BY o.id;

-- 2
SELECT o.id, e.first_name, p.name, o.quantity, o.status
FROM orders o
JOIN employees e ON e.id = o.employee_id
JOIN products  p ON p.id = o.product_id
WHERE o.status = 'shipped'
ORDER BY o.id;

-- 3
SELECT e.first_name AS employee, m.first_name AS manager
FROM employees e
JOIN employees m ON m.id = e.manager_id
ORDER BY e.first_name;

-- 4
-- 11 rows with managers vs 15 employees: 4 have manager_id NULL (INNER drops them).

-- 5
SELECT o.id, e.first_name, o.status
FROM orders o
JOIN employees e ON e.id = o.employee_id
WHERE e.department = 'Sales'
ORDER BY o.id;

-- Stretch
SELECT p.id, p.name, sum(o.quantity) AS total_qty
FROM orders o
JOIN products p ON p.id = o.product_id
GROUP BY p.id, p.name
ORDER BY total_qty DESC;
```
