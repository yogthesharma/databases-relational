# Recursive CTEs

## Shape

```sql
WITH RECURSIVE name AS (
  -- anchor (base rows)
  SELECT …
  UNION ALL
  -- recursive step (references name)
  SELECT …
  FROM name JOIN …
)
SELECT * FROM name;
```

Postgres walks until the recursive branch returns **no new rows**. On cyclic graphs it can recurse until an error unless you guard with a visited path (below).

## Org chart — everyone under Asha

```sql
WITH RECURSIVE reports AS (
  SELECT id, name, manager_id, 0 AS depth
  FROM adv_lab.employees
  WHERE name = 'Asha'

  UNION ALL

  SELECT e.id, e.name, e.manager_id, r.depth + 1
  FROM adv_lab.employees e
  JOIN reports r ON e.manager_id = r.id
)
SELECT * FROM reports ORDER BY depth, name;
```

## Path / cycle guard (awareness)

For graphs with cycles, track a path array and stop when an id repeats:

```sql
-- sketch
-- WHERE NOT e.id = ANY (r.path)
-- SELECT …, r.path || e.id
```

Trees (single parent) are safer starters.

## Node angle

Org charts, category trees, bill-of-materials — pull the closure in SQL once instead of N+1 queries.

## Takeaway

Anchor + `UNION ALL` + self-join. Great for trees; watch cycles on general graphs.
