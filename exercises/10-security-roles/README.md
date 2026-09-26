# Module 10 — Security & roles (exercises)

Same DB `learn`. Use schema **`sec_lab`** and roles **`sec_app`** / **`sec_readonly`**.

## Reset anytime

```bash
docker compose exec -T postgres psql -U postgres -d learn < docker/init/10-module10-sec-lab.sql
```

Demo rights with `SET ROLE …;` / `RESET ROLE;` as `postgres`.

| # | File |
|---|------|
| 01 | [01-roles-and-users.md](./01-roles-and-users.md) |
| 02 | [02-grant-and-revoke.md](./02-grant-and-revoke.md) |
| 03 | [03-ownership-vs-grants.md](./03-ownership-vs-grants.md) |
| 04 | [04-schemas-and-least-privilege.md](./04-schemas-and-least-privilege.md) |
| 05 | [05-connection-security.md](./05-connection-security.md) |
| 06 | [06-secrets-and-sqli.md](./06-secrets-and-sqli.md) |
| 07 | [07-checkpoint-app-role.md](./07-checkpoint-app-role.md) |

Solutions at the bottom of each file.
