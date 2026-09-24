# Join pitfalls

## 1. Row multiplication

Joining 1:N duplicates the “one” side once per match.

```sql
-- Employee appears once per order
SELECT e.first_name, o.id AS order_id
FROM employees e
JOIN orders o ON o.employee_id = e.id;
```

If you then `SUM(e.salary)` across that join, **salary is counted once per order** — classic bug.

```sql
-- WRONG if you meant “total salary of people who ordered”
SELECT sum(e.salary) FROM employees e
JOIN orders o ON o.employee_id = e.id;

-- Better: don’t multiply parent measures across a 1:N join
SELECT sum(salary) FROM employees e
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.employee_id = e.id);
-- (sum(DISTINCT salary) is also wrong if two people share a salary)
```

## 2. Filter in ON vs WHERE (with outer joins)

With `LEFT JOIN`, a condition in `WHERE` on the right table can turn it into an inner join.

```sql
-- Still a left join: non-matches kept (right side NULL)
SELECT e.first_name, o.id, o.status
FROM employees e
LEFT JOIN orders o ON o.employee_id = e.id AND o.status = 'pending';

-- Drops employees with no pending order (behaves like inner for that filter)
SELECT e.first_name, o.id, o.status
FROM employees e
LEFT JOIN orders o ON o.employee_id = e.id
WHERE o.status = 'pending';
```

Rule of thumb: **preserve-left filters on the right table → put them in `ON`**. Filters that should apply to the final result → `WHERE`.

## 3. Selecting ambiguous columns

```sql
-- ERROR if both have id
-- SELECT id FROM orders o JOIN employees e ON ...

SELECT o.id AS order_id, e.id AS employee_id
FROM orders o
JOIN employees e ON e.id = o.employee_id;
```

Always qualify (`table.column`) when names collide.

## 4. Join condition forgotten / wrong

Missing `ON` → syntax error in Postgres for `JOIN` (good). Wrong key → silent wrong results. Prefer joining FK → PK.

## Node angle

If an API returns duplicated parent objects after a join, you either:

- aggregate/nest in SQL (`json_agg` later), or
- query parent + children separately, or
- fix the join / post-process carefully

Don’t `sum` measures from the parent table across a 1:N join without thinking.

## Takeaway

Watch duplication, know `ON` vs `WHERE` on outer joins, always qualify columns, join on real keys.
