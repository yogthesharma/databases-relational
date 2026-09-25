# Window function basics

## Windows vs `GROUP BY`

`GROUP BY` collapses rows. **Window functions** compute across related rows **while keeping each row**.

```sql
SELECT
  e.name,
  s.sold_on,
  s.amount,
  sum(s.amount) OVER (PARTITION BY s.employee_id) AS emp_total
FROM adv_lab.sales s
JOIN adv_lab.employees e ON e.id = s.employee_id
ORDER BY e.name, s.sold_on;
```

Each sale row stays; `emp_total` repeats the employee’s sum.

## Anatomy

```text
function(...) OVER (
  [PARTITION BY ...]
  [ORDER BY ...]
  [frame clause]
)
```

| Piece | Role |
|-------|------|
| `PARTITION BY` | Reset the window (like a group, without collapsing) |
| `ORDER BY` inside `OVER` | Order peers for ranking / running frames |
| Frame | Which rows in the partition count (defaults matter) |

## Simple frame demo

```sql
SELECT
  employee_id,
  sold_on,
  amount,
  sum(amount) OVER (
    PARTITION BY employee_id
    ORDER BY sold_on
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS running_total
FROM adv_lab.sales
ORDER BY employee_id, sold_on;
```

`ROWS` = physical peer offsets; `RANGE` = value peers (ties share).  

**Default frame:** if you write `ORDER BY` inside `OVER` but omit a frame, Postgres uses roughly “from partition start through current peer” (`RANGE … CURRENT ROW`) — so `sum(...) OVER (ORDER BY sold_on)` is already a running total. Spell out `ROWS BETWEEN …` when you want an explicit physical window.

## Node angle

Prefer one SQL window over fetch-all + loop-in-JS for rankings and running totals.

## Takeaway

Windows add columns from a peer set. Partition to split peers; order (+ frame) for running math.
