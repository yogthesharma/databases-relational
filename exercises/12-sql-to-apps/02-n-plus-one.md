# 02 — Spot the N+1

Given this pseudo-code:

```js
const users = await db.query('SELECT id, name FROM users');
for (const u of users.rows) {
  u.orders = (await db.query('SELECT * FROM orders WHERE user_id = $1', [u.id])).rows;
}
```

1. How many round-trips for 100 users?
2. Rewrite as one (or two) SQL statements that avoid N+1.
