# FILTER aggregates

## Conditional aggregates without messy `CASE`

```sql
SELECT
  region,
  count(*) AS sales,
  count(*) FILTER (WHERE amount >= 100) AS big_sales,
  sum(amount) FILTER (WHERE amount >= 100) AS big_revenue
FROM adv_lab.sales
GROUP BY region
ORDER BY region;
```

Equivalent old style: `sum(CASE WHEN amount >= 100 THEN amount END)`.

## Multiple metrics, one scan

```sql
SELECT
  count(*) FILTER (WHERE region = 'West') AS west_n,
  count(*) FILTER (WHERE region = 'East') AS east_n,
  sum(amount) FILTER (WHERE region = 'West') AS west_sum,
  sum(amount) FILTER (WHERE region = 'East') AS east_sum
FROM adv_lab.sales;
```

## With windows

```sql
SELECT
  employee_id,
  amount,
  count(*) FILTER (WHERE amount >= 100) OVER (PARTITION BY employee_id) AS big_deals_for_emp
FROM adv_lab.sales;
```

## Takeaway

`FILTER (WHERE …)` keeps conditional aggregates readable. Prefer it over `CASE` soup when the only difference is the predicate.
