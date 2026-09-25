# Exercise: LATERAL

Read: `notes/08-advanced-sql/04-lateral.md`

## Tasks

1. In one sentence: what does `LATERAL` allow that a plain `FROM` subquery doesn’t?
2. For each employee **with sales**, show their top sale amount via `JOIN LATERAL … LIMIT 1`.
3. Same, but keep employees with no sales (`LEFT JOIN LATERAL`).
4. When would you prefer a window top-N over `LATERAL`?
5. Why is `ON TRUE` common with `LEFT JOIN LATERAL`?

## Stretch

Per employee: top sale in region `'West'` only (lateral filter).

---

## Solutions

1. The subquery can reference columns from tables to its left (correlated `FROM`).
2.

```sql
SELECT e.name, t.amount, t.sold_on
FROM adv_lab.employees e
JOIN LATERAL (
  SELECT s.amount, s.sold_on FROM adv_lab.sales s
  WHERE s.employee_id = e.id
  ORDER BY s.amount DESC
  LIMIT 1
) AS t ON TRUE
ORDER BY e.name;
```

3. Swap `JOIN` → `LEFT JOIN`; **Asha** and **Ben** (no sales) appear with NULL amount.
4. When you need the metric on every detail row anyway, or portable ranking.
5. Lateral already correlates; `ON TRUE` means “keep the lateral row(s)” without an extra predicate.

Stretch:

```sql
SELECT e.name, t.amount, t.sold_on
FROM adv_lab.employees e
JOIN LATERAL (
  SELECT s.amount, s.sold_on FROM adv_lab.sales s
  WHERE s.employee_id = e.id AND s.region = 'West'
  ORDER BY s.amount DESC
  LIMIT 1
) AS t ON TRUE
ORDER BY e.name;
```
