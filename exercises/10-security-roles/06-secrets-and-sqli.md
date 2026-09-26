# Exercise: Secrets & SQL injection

Read: `notes/10-security-roles/06-secrets-and-sqli.md`

## Tasks

1. Where should `DATABASE_URL` live in a Node app?
2. Why is `.env` with real passwords a git risk?
3. Rewrite this safely for `pg`:  
   `` `SELECT * FROM customers WHERE email = '${email}'` ``
4. Does least-privilege remove the need for parameterized queries?
5. Give one ORM footgun related to injection / raw SQL.

## Stretch

Skim this repo’s `.env.example` — does it look like a secret or a template?

---

## Solutions

1. Environment / secret manager — not source control.
2. Leaks credentials via history, forks, and CI logs.
3. `client.query('SELECT * FROM customers WHERE email = $1', [email])`
4. **No** — it limits damage; injection is still a bug.
5. Passing user strings into `$queryRaw` / `.raw()` without parameters.

Stretch: template / placeholders — safe to commit; real `.env` is not.
