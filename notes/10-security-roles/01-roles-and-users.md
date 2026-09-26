# Roles and users

## Postgres model

Everything is a **role**. A “user” is a role with `LOGIN`. Groups are roles you `GRANT` to other roles.

```sql
CREATE ROLE reporting NOLOGIN;          -- group-ish
CREATE ROLE alice LOGIN PASSWORD '...'; -- user
GRANT reporting TO alice;
```

Lab uses `NOLOGIN` roles + `SET ROLE` so you don’t bake passwords into seed scripts.

```sql
SELECT rolname, rolcanlogin, rolsuper
FROM pg_roles
WHERE rolname LIKE 'sec_%';
```

## Least privilege

Give each app / human the **minimum** rights to do their job:

| Role idea | Typical rights |
|-----------|----------------|
| migrations | DDL on app schema |
| app runtime | DML (+ sequence USAGE) only |
| readonly analytics | `SELECT` only |
| admin | break-glass; not used by the API |

## Superuser

`postgres` in this lab is a superuser — bypasses almost everything (RLS, many checks). **Never** point your Node app at a superuser in real life.

## Takeaway

Roles are the unit of access. Prefer NOLOGIN groups + LOGIN users (or SET ROLE in labs). App ≠ superuser.
