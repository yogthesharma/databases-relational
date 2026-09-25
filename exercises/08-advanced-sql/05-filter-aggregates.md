# Exercise: FILTER aggregates

Read: `notes/08-advanced-sql/05-filter-aggregates.md`

## Tasks

1. Rewrite `sum(CASE WHEN amount >= 100 THEN amount END)` using `FILTER`.
2. Per `region`: total sales count and count of sales with `amount >= 100`.
3. Single-row query: west vs east sale counts using `FILTER` (no `GROUP BY`).
4. Can `FILTER` be used with window aggregates? Show a tiny example.
5. Why prefer `FILTER` over `CASE` for conditional aggregates?

## Stretch

Per employee: `sum(amount)` and `sum(amount) FILTER (WHERE region = 'West')`.

---

## Solutions

1. `sum(amount) FILTER (WHERE amount >= 100)`
2.

```sql
SELECT region,
       count(*) AS sales,
       count(*) FILTER (WHERE amount >= 100) AS big_sales
FROM adv_lab.sales
GROUP BY region
ORDER BY region;
```

3.

```sql
SELECT
  count(*) FILTER (WHERE region = 'West') AS west_n,
  count(*) FILTER (WHERE region = 'East') AS east_n
FROM adv_lab.sales;
```

4. Yes — e.g. `count(*) FILTER (WHERE amount >= 100) OVER (PARTITION BY employee_id)`.
5. Clearer intent; less `CASE` noise when only the predicate differs.

Stretch:

```sql
SELECT employee_id,
       sum(amount) AS all_amt,
       sum(amount) FILTER (WHERE region = 'West') AS west_amt
FROM adv_lab.sales
GROUP BY employee_id
ORDER BY employee_id;
```
