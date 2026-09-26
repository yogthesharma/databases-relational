# GRANT and REVOKE

## Schema first, then objects

```sql
GRANT USAGE ON SCHEMA sec_lab TO sec_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA sec_lab TO sec_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA sec_lab TO sec_app;
```

Without `USAGE` on the schema, table grants don’t help.

`SERIAL` / identity inserts also need **`USAGE` (and typically `SELECT`) on the sequence** — otherwise you get `permission denied for sequence …`.

## Demo

```sql
SET ROLE sec_app;
SELECT * FROM sec_lab.customers;
INSERT INTO sec_lab.customers (email, full_name)
VALUES ('lina@example.com', 'Lina Costa')
RETURNING id, email;
RESET ROLE;
```

```sql
SET ROLE sec_readonly;
SELECT count(*) FROM sec_lab.orders;
-- INSERT should fail
RESET ROLE;
```

## REVOKE

```sql
REVOKE INSERT ON sec_lab.orders FROM sec_app;
-- later: GRANT INSERT … again after lab reset
```

## Default privileges

`ALTER DEFAULT PRIVILEGES` covers **future** tables created by the same owner. Lab seed sets defaults for `sec_lab`.

## Takeaway

Grant schema `USAGE`, then table/sequence rights. Prefer role-based grants over granting to every login individually.
