# Outer and cross joins

## LEFT JOIN (most common outer join)

Keep **all rows from the left** table. If the right side has no match, right-hand columns are `NULL`.

```sql
SELECT
  e.first_name,
  m.first_name AS manager
FROM employees AS e
LEFT JOIN employees AS m ON m.id = e.manager_id
ORDER BY e.id;
```

Top-level managers show `manager` as `NULL`.

### Find rows with no match

```sql
-- Employees who never placed an order
SELECT e.id, e.first_name
FROM employees e
LEFT JOIN orders o ON o.employee_id = e.id
WHERE o.id IS NULL;
```

Pattern: `LEFT JOIN` … `WHERE right.pk IS NULL`.

### Departments with no staff (seed includes Marketing)

```sql
SELECT d.department, d.budget, e.first_name
FROM departments_budget d
LEFT JOIN employees e ON e.department = d.department
ORDER BY d.department, e.first_name;
```

Marketing appears with `first_name` NULL.

## COALESCE (fill NULLs)

`COALESCE(a, b)` returns the first non-NULL argument. Handy after outer joins:

```sql
SELECT e.first_name, coalesce(m.first_name, '(none)') AS manager
FROM employees e
LEFT JOIN employees m ON m.id = e.manager_id;
```

Also common: `coalesce(order_count, 0)` when a left-joined aggregate is NULL.

## RIGHT JOIN

Same idea, keep all rows from the **right** table. Rare in practice — people rewrite as `LEFT JOIN` with tables swapped. Know it exists.

## FULL OUTER JOIN

Keep rows from **either** side; non-matches get NULLs on the other side. Useful for “reconcile two lists.”

```sql
SELECT d.department AS budget_dept, e.department AS emp_dept
FROM departments_budget d
FULL OUTER JOIN (SELECT DISTINCT department FROM employees) e
  ON e.department = d.department;
```

## CROSS JOIN

Every row of A paired with every row of B (cartesian product). No `ON`.

```sql
SELECT e.first_name, p.sku
FROM employees e
CROSS JOIN products p;   -- 15 × 15 = 225 rows — usually accidental
```

Use deliberately (e.g. generate combinations). Accidental cross joins explode row counts — next note.

## Takeaway

`LEFT JOIN` preserves the left table and fills gaps with NULL. “Missing related rows” = left join + `WHERE right.id IS NULL`. Avoid accidental `CROSS JOIN`.
