# Aliases and DISTINCT

## Column aliases

Rename output columns with `AS` (optional keyword):

```sql
SELECT
  first_name AS given_name,
  salary / 12 AS monthly_salary
FROM employees;
```

Aliases shine in Node: shape JSON keys without renaming in JS.

```js
// rows[].monthly_salary already named
```

## Table aliases

More useful once you join (Module 2), but valid now:

```sql
SELECT e.first_name, e.department
FROM employees AS e
WHERE e.is_active;
```

## DISTINCT

Remove duplicate **result rows**:

```sql
SELECT DISTINCT department FROM employees;
SELECT DISTINCT category FROM products ORDER BY category;
```

`DISTINCT` applies to the whole selected row, not one column in isolation when you select multiple columns:

```sql
SELECT DISTINCT department, job_title FROM employees;
```

## DISTINCT vs GROUP BY

For “unique values of a column,” `DISTINCT` is fine. For “unique values **plus** counts/sums,” use `GROUP BY` (next note).

## Takeaway

Aliases shape the result for APIs. `DISTINCT` dedupes full result rows — don’t confuse it with aggregation.
