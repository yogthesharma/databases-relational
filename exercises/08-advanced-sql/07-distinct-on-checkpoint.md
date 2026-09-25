# Exercise: DISTINCT ON & checkpoint

Read: `notes/08-advanced-sql/07-distinct-on-checkpoint.md`

## Tasks

1. What does `DISTINCT ON (employee_id)` keep?
2. Using `DISTINCT ON`, return the **latest** sale per employee (`sold_on DESC`).
3. Why must `ORDER BY` start with the same expressions as `DISTINCT ON`?
4. **Checkpoint:** Write a window query for each employee’s highest-amount sale (name, amount, sold_on).
5. **Checkpoint:** Recursive CTE — all employees under Chen (including Chen).

## Stretch

Portable version of task 2 using `ROW_NUMBER` instead of `DISTINCT ON`.

---

## Solutions

1. The first row of each `employee_id` group according to `ORDER BY`.
2.

```sql
SELECT DISTINCT ON (employee_id)
  employee_id, sold_on, amount
FROM adv_lab.sales
ORDER BY employee_id, sold_on DESC;
```

3. Postgres requires that so “first” is well-defined for each distinct key.
4.

```sql
WITH ranked AS (
  SELECT e.name, s.amount, s.sold_on,
         row_number() OVER (
           PARTITION BY s.employee_id
           ORDER BY s.amount DESC, s.sold_on DESC
         ) AS rn
  FROM adv_lab.sales s
  JOIN adv_lab.employees e ON e.id = s.employee_id
)
SELECT name, amount, sold_on FROM ranked WHERE rn = 1 ORDER BY name;
```

5.

```sql
WITH RECURSIVE under_chen AS (
  SELECT id, name, manager_id FROM adv_lab.employees WHERE name = 'Chen'
  UNION ALL
  SELECT e.id, e.name, e.manager_id
  FROM adv_lab.employees e
  JOIN under_chen u ON e.manager_id = u.id
)
SELECT * FROM under_chen ORDER BY name;
```

Stretch:

```sql
WITH ranked AS (
  SELECT employee_id, sold_on, amount,
         row_number() OVER (
           PARTITION BY employee_id ORDER BY sold_on DESC
         ) AS rn
  FROM adv_lab.sales
)
SELECT employee_id, sold_on, amount
FROM ranked
WHERE rn = 1
ORDER BY employee_id;
```
