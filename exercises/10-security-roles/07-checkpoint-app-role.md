# Exercise: Checkpoint — app role

Read: `notes/10-security-roles/07-checkpoint-app-role.md`

Reset the sec lab first.

## Tasks

1. As `sec_app`, count customers and insert a new order for customer `1`.
2. As `sec_app`, update that order’s status to `paid`.
3. As `sec_app`, show that `DROP TABLE sec_lab.customers` fails.
4. As `sec_app`, show that `SELECT` on `public.employees` fails.
5. In one sentence: what rights should a production API DB user have?

## Stretch

As `sec_readonly`, prove `DELETE FROM sec_lab.orders` fails.

---

## Solutions

1–2.

```sql
SET ROLE sec_app;
SELECT count(*) FROM sec_lab.customers;
INSERT INTO sec_lab.orders (customer_id, total, status)
VALUES (1, 5.00, 'pending') RETURNING id;
UPDATE sec_lab.orders SET status = 'paid' WHERE customer_id = 1 AND total = 5.00;
RESET ROLE;
```

3. `DROP TABLE sec_lab.customers;` → must be owner / permission denied.
4. `SELECT count(*) FROM public.employees;` → permission denied.
5. DML (+ sequence usage) on its schema only — no DDL, no neighbor data, no superuser.

Stretch:

```sql
SET ROLE sec_readonly;
DELETE FROM sec_lab.orders;  -- fails
RESET ROLE;
```
