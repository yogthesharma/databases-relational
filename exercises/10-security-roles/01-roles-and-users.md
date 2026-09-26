# Exercise: Roles & users

Read: `notes/10-security-roles/01-roles-and-users.md`

## Tasks

1. List `sec_app` and `sec_readonly` from `pg_roles` — can they log in?
2. What’s the difference between a `LOGIN` role and a `NOLOGIN` role?
3. Why is the lab using `SET ROLE` instead of passwords in the seed?
4. Should your Node app connect as a superuser? Why/why not?
5. Name three least-privilege role “shapes” (e.g. app / readonly / …).

## Stretch

`SELECT current_user, session_user;` then `SET ROLE sec_app;` and run it again — what changed?

---

## Solutions

1.

```sql
SELECT rolname, rolcanlogin, rolsuper
FROM pg_roles WHERE rolname LIKE 'sec_%' ORDER BY 1;
-- rolcanlogin = false
```

2. `LOGIN` may connect; `NOLOGIN` is for groups / `SET ROLE` membership.
3. Avoid committing passwords; `postgres` assumes the role for demos.
4. **No** — bypasses protections; huge blast radius.
5. App (DML), readonly (`SELECT`), migrations (DDL), admin (break-glass).

Stretch: `current_user` becomes `sec_app`; `session_user` stays `postgres`. Privilege checks now follow `sec_app` (superuser powers are off until `RESET ROLE`).
