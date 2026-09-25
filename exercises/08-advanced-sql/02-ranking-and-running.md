# Exercise: Ranking & running totals

Read: `notes/08-advanced-sql/02-ranking-and-running.md`

## Tasks

1. Difference between `ROW_NUMBER`, `RANK`, and `DENSE_RANK` in one line each.
2. Rank all sales by `amount` descending (overall).
3. Rank sales **within each region** by amount descending.
4. Using `ROW_NUMBER`, return each employee’s single largest sale.
5. Compute a 3-row moving average of `amount` ordered by `sold_on` (company-wide).

## Stretch

Top 2 sales per region (`rn <= 2`).

---

## Solutions

1. `ROW_NUMBER` unique; `RANK` ties + gaps; `DENSE_RANK` ties + no gaps.
2.

```sql
SELECT e.name, s.amount,
       rank() OVER (ORDER BY s.amount DESC) AS overall_rank
FROM adv_lab.sales s
JOIN adv_lab.employees e ON e.id = s.employee_id
ORDER BY s.amount DESC;
```

3.

```sql
SELECT s.region, e.name, s.amount,
       rank() OVER (PARTITION BY s.region ORDER BY s.amount DESC) AS region_rank
FROM adv_lab.sales s
JOIN adv_lab.employees e ON e.id = s.employee_id
ORDER BY s.region, s.amount DESC;
```

4.

```sql
WITH ranked AS (
  SELECT s.*, row_number() OVER (
    PARTITION BY employee_id ORDER BY amount DESC
  ) AS rn
  FROM adv_lab.sales s
)
SELECT employee_id, amount, sold_on FROM ranked WHERE rn = 1;
```

5.

```sql
SELECT sold_on, amount,
       avg(amount) OVER (
         ORDER BY sold_on
         ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS moving_avg_3
FROM adv_lab.sales
ORDER BY sold_on;
```

Stretch:

```sql
WITH ranked AS (
  SELECT s.*, row_number() OVER (
    PARTITION BY region ORDER BY amount DESC
  ) AS rn
  FROM adv_lab.sales s
)
SELECT region, employee_id, amount, sold_on
FROM ranked
WHERE rn <= 2
ORDER BY region, rn;
```
