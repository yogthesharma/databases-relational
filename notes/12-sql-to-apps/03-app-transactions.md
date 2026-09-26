# Transactions in application code

Module 6 covered isolation. In apps you **begin / commit / rollback** around a use case:

```js
const client = await pool.connect();
try {
  await client.query('BEGIN');
  // … parameterized updates …
  await client.query('COMMIT');
} catch (e) {
  await client.query('ROLLBACK');
  throw e;
} finally {
  client.release();
}
```

## Rules

1. Use **one client** for the whole transaction (not `pool.query` mid-txn — that may use another connection).  
2. Parameterize every value (`$1`, `$2`).  
3. Keep transactions short (no HTTP calls inside).  
4. Prefer DB constraints + `CHECK` over “hope the app remembered.”

## Takeaway

Business invariants that span rows belong in a transaction. Hold a dedicated client until commit/rollback.
