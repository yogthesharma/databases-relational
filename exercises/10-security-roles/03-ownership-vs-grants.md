# Exercise: Ownership vs grants

Read: `notes/10-security-roles/03-ownership-vs-grants.md`

## Tasks

1. Who owns `sec_lab.customers`?
2. As `sec_app`, try `DROP TABLE sec_lab.orders;` — what happens?
3. As `sec_app`, try `TRUNCATE sec_lab.orders;` — what happens?
4. Why shouldn’t the runtime app role **own** production tables?
5. Who should own tables instead (one sentence)?

## Stretch

`\dp sec_lab.customers` (or catalog ACL query) — spot `sec_app` vs owner.

---

## Solutions

1. `postgres` (lab owner).

```sql
SELECT tablename, tableowner FROM pg_tables WHERE schemaname = 'sec_lab';
```

2. Error — must be owner (or superuser).
3. Error — `TRUNCATE` not granted (and isn’t plain DELETE).
4. Compromised app credentials could DDL/drop the schema away.
5. A migration / deployer role owns DDL; app gets DML grants only.

Stretch: access privileges show `sec_app=arwd/...` style grants; owner is separate.
