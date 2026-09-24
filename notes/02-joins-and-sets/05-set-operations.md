# Set operations

Stack result sets vertically. Column count and types must line up.

## UNION vs UNION ALL

```sql
-- Distinct departments that appear in either employees or budgets
SELECT department FROM employees
UNION
SELECT department FROM departments_budget
ORDER BY 1;
```

| | Behavior |
|--|----------|
| `UNION` | Concatenate + **remove duplicate** rows |
| `UNION ALL` | Concatenate; **keep** duplicates (faster) |

Prefer `UNION ALL` when you know there’s no overlap or duplicates are fine.

## INTERSECT

Rows that appear in **both** results:

```sql
SELECT department FROM employees
INTERSECT
SELECT department FROM departments_budget;
```

(Marketing is only in budgets → excluded.)

## EXCEPT

Rows in the first result but not the second:

```sql
-- Budget departments with no employees
SELECT department FROM departments_budget
EXCEPT
SELECT department FROM employees;
```

## Rules

- Same number of columns
- Compatible types (Postgres will cast when sensible)
- `ORDER BY` applies to the **whole** combined result (use column positions or aliases from the first SELECT)
- `UNION` dedupes whole rows, not one column in isolation when selecting multiple columns

## vs JOIN

| Need | Prefer |
|------|--------|
| Combine columns from related rows | `JOIN` |
| Combine rows from similar queries | `UNION` / `INTERSECT` / `EXCEPT` |

## Takeaway

`UNION ALL` for stacking; `UNION` when you need distinct; `INTERSECT`/`EXCEPT` for set math on query results.
