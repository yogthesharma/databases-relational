# Exercise: Set operations

Read: `notes/02-joins-and-sets/05-set-operations.md`

## Tasks

1. All distinct department names from `employees` **and** `departments_budget` (`UNION`).
2. Same idea with `UNION ALL` — how many more rows than (1)? Why?
3. Departments present in **both** tables (`INTERSECT`).
4. Departments in `departments_budget` but not in `employees` (`EXCEPT`).
5. When would you choose `UNION ALL` over `UNION` in an API/report query?

## Stretch

One result set: first names of active Engineering employees **union** first names of employees who placed a cancelled order (deduped).

---

## Solutions

```sql
-- 1
SELECT department FROM employees
UNION
SELECT department FROM departments_budget
ORDER BY 1;

-- 2
SELECT department FROM employees
UNION ALL
SELECT department FROM departments_budget;
-- UNION ALL keeps duplicates: every employee row’s department plus 5 budget rows.
-- Row count is much larger than (1); exact number = 15 + 5 = 20 vs 5 distinct in UNION.

-- 3
SELECT department FROM employees
INTERSECT
SELECT department FROM departments_budget;

-- 4
SELECT department FROM departments_budget
EXCEPT
SELECT department FROM employees;
-- Marketing

-- 5
When duplicates are impossible or acceptable, and you want less work (no dedupe) — e.g. appending log-like rows.

-- Stretch
SELECT first_name FROM employees
WHERE is_active AND department = 'Engineering'
UNION
SELECT e.first_name FROM employees e
JOIN orders o ON o.employee_id = e.id
WHERE o.status = 'cancelled';
```
