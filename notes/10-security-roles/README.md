# Module 10 — Security, roles & access

Same DB `learn`. Practice in schema **`sec_lab`** with roles **`sec_app`** (DML) and **`sec_readonly`** (SELECT).

**Apply / reset sec lab** (from repo root):

```bash
docker compose exec -T postgres psql -U postgres -d learn < docker/init/10-module10-sec-lab.sql
```

Roles are `NOLOGIN` — demo with `SET ROLE sec_app;` then `RESET ROLE;` as `postgres`.

| # | Concept | Notes |
|---|---------|-------|
| 01 | Roles & users | [01-roles-and-users.md](./01-roles-and-users.md) |
| 02 | GRANT / REVOKE | [02-grant-and-revoke.md](./02-grant-and-revoke.md) |
| 03 | Ownership vs grants | [03-ownership-vs-grants.md](./03-ownership-vs-grants.md) |
| 04 | Schemas & least privilege | [04-schemas-and-least-privilege.md](./04-schemas-and-least-privilege.md) |
| 05 | Connection security | [05-connection-security.md](./05-connection-security.md) |
| 06 | Secrets & SQL injection | [06-secrets-and-sqli.md](./06-secrets-and-sqli.md) |
| 07 | Checkpoint: app role | [07-checkpoint-app-role.md](./07-checkpoint-app-role.md) |

Matching exercises: `exercises/10-security-roles/`.

**Checkpoint:** Prove `sec_app` can DML in `sec_lab` but cannot drop tables or read other course schemas.
