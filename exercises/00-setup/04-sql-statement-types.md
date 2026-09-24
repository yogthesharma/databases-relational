# Exercise: SQL statement types

Read: `notes/00-setup/04-sql-statement-types.md`

## Tasks

Label each statement **DDL / DML / DCL / TCL**:

1. `CREATE TABLE orders (id SERIAL PRIMARY KEY);`
2. `SELECT * FROM products WHERE price > 100;`
3. `GRANT SELECT ON products TO readonly;`
4. `BEGIN;`
5. `ALTER TABLE employees ADD COLUMN middle_name TEXT;`
6. `DELETE FROM products WHERE is_discontinued = TRUE;`
7. `COMMIT;`
8. `REVOKE ALL ON SCHEMA public FROM PUBLIC;`

## Node mapping

9. Is a Prisma migration file mostly DDL or DML? Why?
10. Is `prisma.user.findMany()` closer to DDL or DML?

## Stretch

In `psql`, run a **read-only** DML statement against `employees` that returns one column you care about. Do **not** run DDL that drops tables.

---

## Solutions

1. DDL  
2. DML  
3. DCL  
4. TCL  
5. DDL  
6. DML  
7. TCL  
8. DCL  
9. DDL — migrations create/alter schema.  
10. DML — it reads rows (`SELECT` under the hood).
