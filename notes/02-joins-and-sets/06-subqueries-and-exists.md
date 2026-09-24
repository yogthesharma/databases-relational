# Subqueries and EXISTS

A subquery is a query nested inside another. Use them for filters, computed values, or “does a match exist?”

## Scalar subquery (one value)

```sql
SELECT first_name, salary
FROM employees
WHERE salary > (SELECT avg(salary) FROM employees WHERE is_active);
```

Must return **at most one row** (and usually one column).

## IN (list from a query)

```sql
SELECT first_name, department
FROM employees
WHERE id IN (SELECT DISTINCT employee_id FROM orders);
```

## EXISTS (correlated)

`EXISTS` asks: “is there at least one matching row?” — it doesn’t build a big list.

```sql
SELECT e.first_name, e.department
FROM employees e
WHERE EXISTS (
  SELECT 1
  FROM orders o
  WHERE o.employee_id = e.id
    AND o.status = 'pending'
);
```

The inner query references `e` from the outer query → **correlated**.

### NOT EXISTS

```sql
SELECT e.first_name
FROM employees e
WHERE NOT EXISTS (
  SELECT 1 FROM orders o WHERE o.employee_id = e.id
);
```

Same idea as `LEFT JOIN … WHERE o.id IS NULL`; both are valid.

## EXISTS vs IN

| | Prefer when |
|--|-------------|
| `EXISTS` | Checking presence; nullable columns; often clearer for “any matching row” |
| `IN` | Small fixed lists, or simple “id in this set” |

**Watch:** `NOT IN (subquery)` if the subquery can return `NULL` — the whole `NOT IN` becomes unknown and you get zero rows. Prefer `NOT EXISTS` for anti-joins.

## Uncorrelated vs correlated

- **Uncorrelated:** inner query doesn’t reference outer — can run once.
- **Correlated:** depends on outer row — conceptually per-row (planner may still optimize).

## Node angle

Subqueries are fine in `pg` strings. If the same subquery repeats, a CTE (next note) or a join often reads better.

## Takeaway

Scalar for one value; `IN` for membership; `EXISTS`/`NOT EXISTS` for presence — especially safer than `NOT IN` with NULLs.
