# Exercise: Join pitfalls

Read: `notes/02-joins-and-sets/04-join-pitfalls.md`

## Tasks

1. Run both and compare row counts / who appears:

```sql
-- A
SELECT e.first_name, o.id, o.status
FROM employees e
LEFT JOIN orders o ON o.employee_id = e.id AND o.status = 'pending';

-- B
SELECT e.first_name, o.id, o.status
FROM employees e
LEFT JOIN orders o ON o.employee_id = e.id
WHERE o.status = 'pending';
```

Which one keeps employees with no pending orders? Why?

2. Why is this a bad way to compute “total salary of employees who have at least one order”?

```sql
SELECT sum(e.salary) FROM employees e
JOIN orders o ON o.employee_id = e.id;
```

3. Fix (2) using `EXISTS` (or `IN` with distinct ids).
4. Write a join that selects both `orders.id` and `employees.id` with clear aliases (no ambiguous `id`).

## Stretch

Explain in one sentence what would go wrong if an API mapped the raw rows from a 1:N join into a list of “Employee” objects without grouping.

---

## Solutions

1. **A** keeps everyone (non-matches have NULL order cols). **B** filters `o.status = 'pending'`, which drops NULL statuses → employees without pending orders disappear (acts like inner for that predicate).
2. Employees with multiple orders contribute their salary multiple times → inflated sum.
3.

```sql
SELECT sum(salary) FROM employees e
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.employee_id = e.id);
```

4.

```sql
SELECT o.id AS order_id, e.id AS employee_id, e.first_name
FROM orders o
JOIN employees e ON e.id = o.employee_id;
```

Stretch: the same employee appears once per order, so you’d duplicate parent entities in JSON.
