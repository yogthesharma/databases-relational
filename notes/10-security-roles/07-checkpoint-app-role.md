# Checkpoint — app role

## Goal

Prove the lab app role matches a real runtime shape:

1. Can `SELECT` / `INSERT` / `UPDATE` / `DELETE` in `sec_lab`  
2. Can use sequences for `SERIAL` inserts  
3. **Cannot** `DROP` tables it uses  
4. **Cannot** read other course schemas / `public.employees`

## Script

```sql
SET ROLE sec_app;

SELECT count(*) FROM sec_lab.customers;

INSERT INTO sec_lab.orders (customer_id, total, status)
VALUES (1, 5.00, 'pending')
RETURNING id, total;

-- Same session only: currval sees the INSERT's nextval
UPDATE sec_lab.orders
SET status = 'paid'
WHERE id = currval('sec_lab.orders_id_seq')
RETURNING id, status;

-- Expect failures (uncomment one at a time):
-- DROP TABLE sec_lab.customers;
-- SELECT count(*) FROM public.employees;
-- SELECT count(*) FROM feat_lab.articles;

RESET ROLE;
```

## Production mirror

| Lab | Prod |
|-----|------|
| `sec_app` NOLOGIN + `SET ROLE` | LOGIN role used by the pool |
| Owner `postgres` | Migration role owns DDL |
| Manual grants in seed | Grants in migration scripts |

## Takeaway

Runtime role = DML + sequence usage, no DDL, no neighbor schemas. That’s the Module 10 checkpoint.
