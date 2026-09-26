# Exercise: Connection security

Read: `notes/10-security-roles/05-connection-security.md`

## Tasks

1. What does `pg_hba.conf` control (one sentence)?
2. Why require SSL for a database on the public internet?
3. Name two fields you’d expect in a production connection string.
4. Is Docker Compose Postgres on localhost “production secure”? Why/why not?
5. How do grants relate to `pg_hba` (order of defense)?

## Stretch

Check how you connect in this repo (compose / `.env.example`) — what’s the user?

---

## Solutions

1. Who may connect from where, with which auth method (before SQL runs).
2. Stop credentials and data from being sniffed / MITM’d on the wire.
3. e.g. host, db name, user, password, `sslmode`.
4. **No** — local trust/password on a bridged port is a learning setup, not a hardened deploy.
5. `pg_hba` (+ TLS) first; grants after you’re connected.

Stretch: usually `postgres` / values from `.env.example` — fine for lab, not for prod apps.
