# Schemas and least privilege

## Schemas as security boundaries

`USAGE` on a schema is the door. No door → no tables inside (even if you somehow know names).

```sql
SET ROLE sec_app;
SELECT * FROM feat_lab.articles;     -- should fail (no USAGE / no SELECT)
SELECT * FROM public.employees;      -- should fail without grants
RESET ROLE;
```

Course labs live in separate schemas (`write_lab`, `feat_lab`, …) so you can grant per domain.

## Search path caution

```sql
SHOW search_path;
-- Don’t put untrusted schemas first; attackers love object-name tricks
```

App connections should set a tight `search_path` (e.g. `sec_lab, public`) in the connection options.

## PUBLIC

Privileges to role `PUBLIC` apply to everyone. Avoid `GRANT … TO PUBLIC` on sensitive tables.

## Takeaway

Schema `USAGE` + object grants = least privilege by area. Keep the app out of migration and other teams’ schemas.
