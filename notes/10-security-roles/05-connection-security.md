# Connection security (awareness)

## `pg_hba.conf` mindset

Postgres decides **who can connect from where, how**:

| Idea | Example |
|------|---------|
| Local trust (dev only) | Docker lab convenience |
| Password / scram | App & humans |
| Host SSL required | Production WAN |
| Reject | Everything else |

You won’t edit `pg_hba` in this module — know that **network + auth** are first gates before SQL grants matter.

## SSL / TLS

Prefer encrypted connections to managed Postgres (`sslmode=require` / verify-full in apps). Lab Docker on localhost is often plaintext — fine for learning, not for prod.

## Connection strings

```text
postgresql://app_user:***@db.example.com:5432/app?sslmode=require
```

Host, DB name, user, password, SSL mode — all part of the security story.

## Takeaway

Grants protect after connect. `pg_hba` + TLS protect the front door. Prod apps: strong auth + SSL + least-privilege DB user.
