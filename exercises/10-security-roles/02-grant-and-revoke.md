# Exercise: GRANT / REVOKE

Read: `notes/10-security-roles/02-grant-and-revoke.md`

## Tasks

1. As `sec_app`, `SELECT` from `sec_lab.customers`.
2. As `sec_app`, `INSERT` a customer and return the new `id`.
3. As `sec_readonly`, `SELECT` orders — then try an `INSERT` (expect failure).
4. Why grant `USAGE` on the schema before table privileges?
5. What do `GRANT USAGE, SELECT ON ALL SEQUENCES` buy you for `SERIAL`?

## Stretch

`REVOKE DELETE ON sec_lab.orders FROM sec_app;` then try a delete as `sec_app`. Reset the lab afterward.

---

## Solutions

1.

```sql
SET ROLE sec_app;
SELECT * FROM sec_lab.customers;
RESET ROLE;
```

2.

```sql
SET ROLE sec_app;
INSERT INTO sec_lab.customers (email, full_name)
VALUES ('lina@example.com', 'Lina Costa')
RETURNING id, email;
RESET ROLE;
```

3.

```sql
SET ROLE sec_readonly;
SELECT count(*) FROM sec_lab.orders;  -- ok
INSERT INTO sec_lab.orders (customer_id, total) VALUES (1, 1.00);  -- permission denied
RESET ROLE;
```

4. Schema `USAGE` is required to access objects inside the schema.
5. `nextval` for `SERIAL`/`IDENTITY` — without sequence `USAGE`/`SELECT`, inserts fail even with table `INSERT`.

Stretch: delete fails after revoke; run the reset SQL to restore grants.
