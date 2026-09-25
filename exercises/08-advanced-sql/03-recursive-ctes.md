# Exercise: Recursive CTEs

Read: `notes/08-advanced-sql/03-recursive-ctes.md`

## Tasks

1. What are the two parts of a recursive CTE?
2. List Asha and everyone under her (include `depth`).
3. List only people under Ben (include Ben), ordered by depth.
4. How would you stop recursion on a cyclic graph (one sentence)?
5. Count how many employees are in Eng’s subtree starting at Ben (including Ben).

## Stretch

Build a `path` text like `Asha > Ben > Deepa` for each person under Asha.

---

## Solutions

1. **Anchor** query + **recursive** query joined with `UNION ALL`.
2.

```sql
WITH RECURSIVE reports AS (
  SELECT id, name, manager_id, 0 AS depth
  FROM adv_lab.employees WHERE name = 'Asha'
  UNION ALL
  SELECT e.id, e.name, e.manager_id, r.depth + 1
  FROM adv_lab.employees e
  JOIN reports r ON e.manager_id = r.id
)
SELECT * FROM reports ORDER BY depth, name;
```

3. Same pattern with `WHERE name = 'Ben'`.
4. Track visited ids in an array/path; stop when the next id is already present.
5.

```sql
WITH RECURSIVE eng AS (
  SELECT id FROM adv_lab.employees WHERE name = 'Ben'
  UNION ALL
  SELECT e.id FROM adv_lab.employees e JOIN eng ON e.manager_id = eng.id
)
SELECT count(*) FROM eng;
```

Stretch:

```sql
WITH RECURSIVE reports AS (
  SELECT id, name, manager_id, 0 AS depth, name::text AS path
  FROM adv_lab.employees WHERE name = 'Asha'
  UNION ALL
  SELECT e.id, e.name, e.manager_id, r.depth + 1,
         r.path || ' > ' || e.name
  FROM adv_lab.employees e
  JOIN reports r ON e.manager_id = r.id
)
SELECT name, depth, path FROM reports ORDER BY depth, name;
```
