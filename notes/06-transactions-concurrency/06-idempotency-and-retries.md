# Idempotency and safe retries

## Why retries exist

Networks flake. Serialization failures and deadlocks ask you to **retry** the whole transaction. Retries are only safe if repeating the work doesn’t double-apply side effects.

## Idempotency key (lab pattern)

`tx_lab.transfers.idempotency_key` is `UNIQUE`. Client sends a key per logical transfer.

**Important:** if the `INSERT` hits `unique_violation` (`23505`), the transaction is **aborted** — `ROLLBACK` and treat the payment as already done. Do **not** run the balance `UPDATE`s after a failed insert in the same txn.

Safer pattern — insert with `ON CONFLICT DO NOTHING`, and only move money if the insert won (CTE so a blind retry can’t debit twice):

```sql
BEGIN;

WITH ins AS (
  INSERT INTO tx_lab.transfers (from_account_id, to_account_id, amount, idempotency_key)
  SELECT a.id, b.id, 15, 'xfer-002'
  FROM tx_lab.accounts a, tx_lab.accounts b
  WHERE a.name = 'alice' AND b.name = 'bob'
  ON CONFLICT (idempotency_key) DO NOTHING
  RETURNING id
)
UPDATE tx_lab.accounts AS acct
SET balance = acct.balance + deltas.delta
FROM (VALUES
  ('alice', -15::numeric),
  ('bob',    15::numeric)
) AS deltas(name, delta)
WHERE acct.name = deltas.name
  AND EXISTS (SELECT 1 FROM ins);

COMMIT;
```

If `ins` is empty (key already used), the `UPDATE` matches zero rows — balances unchanged.

## What to retry

| Safe to retry | Dangerous without idempotency |
|---------------|-------------------------------|
| Whole txn after deadlock / serialization failure | “Debit then commit” without a unique key |
| `INSERT … ON CONFLICT DO NOTHING` flows | Fire-and-forget double `INSERT` of payments |

## Node angle

Pass `Idempotency-Key` from the API into SQL. On `23505` / conflict, return the original result, don’t debit again.

## Takeaway

Retries need idempotency. Unique keys (or upserts) make “run twice” equal “run once.”
