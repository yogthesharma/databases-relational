# Secrets and SQL injection

## Secrets

| Do | Don’t |
|----|-------|
| `DATABASE_URL` in env / secret manager | Commit `.env` with passwords |
| Rotate credentials | Share superuser with the app |
| Different creds per env | Reuse prod passwords in local notes |

This repo’s `.env.example` is a template — real secrets stay out of git.

## SQL injection

Never build SQL with string concatenation of user input:

```js
// BAD
client.query(`SELECT * FROM users WHERE email = '${email}'`);

// GOOD — parameterized
client.query('SELECT * FROM users WHERE email = $1', [email]);
```

ORMs/query builders still need care (raw fragments). Least-privilege DB roles **limit blast radius** if injection happens — they don’t remove the bug.

## Takeaway

Env-based secrets + parameterized queries are non-negotiable. Grants are defense in depth, not a substitute for safe SQL.
