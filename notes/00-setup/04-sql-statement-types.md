# SQL statement types

SQL isn’t one thing — statements fall into families. Knowing which family you’re in helps when reading docs, migrations, and ORM output.

## The families

| Family | Name | Purpose | Examples |
|--------|------|---------|----------|
| **DDL** | Data Definition | Shape the schema | `CREATE TABLE`, `ALTER TABLE`, `DROP TABLE`, `CREATE INDEX` |
| **DML** | Data Manipulation | Change/read row data | `SELECT`, `INSERT`, `UPDATE`, `DELETE` |
| **DCL** | Data Control | Who can do what | `GRANT`, `REVOKE` |
| **TCL** | Transaction Control | Commit / undo groups of changes | `BEGIN`, `COMMIT`, `ROLLBACK` |

Some people call `SELECT` “DQL” (query). In practice you’ll hear “DML” for all row ops including reads.

## Node full-stack mapping

| You do in app land | Typical SQL family |
|--------------------|--------------------|
| Prisma `migrate` / drizzle-kit | DDL |
| `findMany` / `db.query` / route handlers | DML (`SELECT` / writes) |
| Creating a read-only DB user for analytics | DCL |
| Checkout that reserves stock + creates order | DML inside TCL (`BEGIN`…`COMMIT`) |

## Examples on our DB

```sql
-- DDL (don’t run casually in prod)
-- CREATE TABLE ...

-- DML read
SELECT first_name, department FROM employees;

-- DML write (try in exercises later; Module 3 owns this)
-- UPDATE employees SET salary = salary + 1000 WHERE id = 13;

-- TCL
BEGIN;
-- ... statements ...
ROLLBACK;  -- undo
```

## Takeaway

Schema changes = DDL. App CRUD = DML. Permissions = DCL. Multi-step correctness = TCL. Migrations tools generate DDL; your route handlers issue DML (ideally parameterized).
