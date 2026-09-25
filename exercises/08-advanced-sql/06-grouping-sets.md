# Exercise: GROUPING SETS

Read: `notes/08-advanced-sql/06-grouping-sets.md`

## Tasks

1. What does an empty grouping set `()` mean?
2. Produce revenue by `(region, employee_id)`, by `region`, and grand total in **one** query (`GROUPING SETS`).
3. What does `ROLLUP (region)` generate?
4. How does `CUBE (region, employee_id)` differ from `ROLLUP (region, employee_id)`?
5. When should you avoid `CUBE` in an OLTP request path?

## Stretch

Use `GROUPING(region)` to label total rows as `'ALL'` in the output.

---

## Solutions

1. Grand total over all rows (no group columns).
2.

```sql
SELECT region, employee_id, sum(amount) AS revenue
FROM adv_lab.sales
GROUP BY GROUPING SETS ((region, employee_id), (region), ())
ORDER BY region NULLS LAST, employee_id NULLS LAST;
```

3. `(region)` and `()` — region subtotals + grand total.
4. `CUBE` adds every subset (including `(employee_id)` alone); `ROLLUP` follows the hierarchy only.
5. Combinatorial explosion / heavy aggregates on hot paths — use for reporting.

Stretch:

```sql
SELECT CASE WHEN GROUPING(region) = 1 THEN 'ALL' ELSE region END AS region,
       sum(amount)
FROM adv_lab.sales
GROUP BY ROLLUP (region);
```
