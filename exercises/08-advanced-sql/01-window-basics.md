# Exercise: Window basics

Read: `notes/08-advanced-sql/01-window-basics.md`

## Tasks

1. How does a window `sum` differ from `GROUP BY sum` in what rows you get back?
2. For each sale, show employee name, amount, and that employee’s total sales (`sum … OVER`).
3. Add a running total of `amount` per employee ordered by `sold_on` (`ROWS` frame).
4. What does `PARTITION BY` do inside `OVER`?
5. Why might you still see the same `emp_total` on every row for one employee?

## Stretch

Company-wide running total ordered by `sold_on` (no partition).

---

## Solutions

1. Window keeps detail rows; `GROUP BY` collapses to one row per group.
2.

```sql
SELECT e.name, s.sold_on, s.amount,
       sum(s.amount) OVER (PARTITION BY s.employee_id) AS emp_total
FROM adv_lab.sales s
JOIN adv_lab.employees e ON e.id = s.employee_id
ORDER BY e.name, s.sold_on;
```

3.

```sql
SELECT employee_id, sold_on, amount,
       sum(amount) OVER (
         PARTITION BY employee_id ORDER BY sold_on
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_total
FROM adv_lab.sales
ORDER BY employee_id, sold_on;
```

4. Splits peers into independent windows (resets the calculation).
5. The partition sum is the same for every row in that partition.

Stretch:

```sql
SELECT sold_on, amount,
       sum(amount) OVER (ORDER BY sold_on) AS company_running
FROM adv_lab.sales
ORDER BY sold_on;
```
