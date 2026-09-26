# Ownership vs grants

## Owner

The role that **owns** an object can drop/alter it and often bypasses RLS (unless `FORCE`). Lab tables are owned by `postgres`.

```sql
SELECT tablename, tableowner
FROM pg_tables
WHERE schemaname = 'sec_lab';
```

## Grants

Everyone else needs explicit `GRANT`s (or inherits via role membership).

| Action | Owner | `sec_app` (DML grants) |
|--------|-------|-------------------------|
| `SELECT`/`INSERT`/… | yes | yes |
| `DROP TABLE` | yes | **no** |
| `TRUNCATE` | often owner / special | not granted here |
| `ALTER TABLE` | yes | **no** |

```sql
SET ROLE sec_app;
DROP TABLE sec_lab.orders;  -- ERROR: must be owner
RESET ROLE;
```

## Don’t own as the app

If the runtime role owns tables, a SQL injection can `DROP` them. Own as a migration role; grant DML to the app role.

## Takeaway

Ownership ≠ grant. App roles should hold grants, not ownership of production tables.
