# GROUPING SETS, ROLLUP, CUBE (overview)

## One query, several group levels

Instead of `UNION ALL` of multiple `GROUP BY`s:

```sql
SELECT region, employee_id, sum(amount) AS revenue
FROM adv_lab.sales
GROUP BY GROUPING SETS (
  (region, employee_id),
  (region),
  ()
)
ORDER BY region NULLS LAST, employee_id NULLS LAST;
```

`()` = grand total. `GROUPING(col)` is 1 when that col is aggregated away.

## ROLLUP / CUBE shortcuts

```sql
-- region → grand total
SELECT region, sum(amount)
FROM adv_lab.sales
GROUP BY ROLLUP (region);

-- all combinations of region & employee_id
SELECT region, employee_id, sum(amount)
FROM adv_lab.sales
GROUP BY CUBE (region, employee_id);
```

| Helper | Produces |
|--------|----------|
| `ROLLUP (a,b)` | `(a,b)`, `(a)`, `()` |
| `CUBE (a,b)` | all subsets of `{a,b}` |
| `GROUPING SETS` | exactly the sets you list |

## When to care

Dashboards / OLAP-ish summaries. Don’t force cubes into OLTP hot paths.

## Takeaway

`GROUPING SETS` for explicit multi-level totals; `ROLLUP`/`CUBE` when the hierarchy/combinatorics match.
