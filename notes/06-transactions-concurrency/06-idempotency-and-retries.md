# Idempotency and safe retries

## Why retries exist

Networks flake. Serialization failures and deadlocks ask you to **retry** the whole transaction. Retries are only safe if repeating the work doesn’t double-apply side effects.

## Idempotency key (lab pattern)

`tx_lab.transfers.idempotency_key` is `UNIQUE`. Client sends a key per logical transfer.

**Important:** if the `INSERT` hits `unique_violation` (`23505`), the transaction is **aborted** — `ROLLBACK` and treat the payment as already done. Do **not** run the balance `UPDATE`s after a failed insert in the same txn.

Safer pattern — insert first with `ON CONFLICT DO NOTHING`, move money only if a row was inserted:

```sql
BEGIN;

INSERT INTO tx_lab.transfers (from_account_id, to_account_id, amount, idempotency_key)
SELECT a.id, b.id, 15, 'xfer-002'
FROM tx_lab.accounts a, tx_lab.accounts b
WHERE a.name = 'alice' AND b.name = 'bob'
ON CONFLICT (idempotency_key) DO NOTHING
RETURNING id;
-- If RETURNING is empty → already processed; ROLLBACK (or COMMIT with no updates).
-- If RETURNING has a row → apply balances:

UPDATE tx_lab.accounts SET balance = balance - 15 WHERE name = 'alice';
UPDATE tx_lab.accounts SET balance = balance + 15 WHERE name = 'bob';

COMMIT;
```

## What to retry

| Safe to retry | Dangerous without idempotency |
|---------------|-------------------------------|
| Whole txn after deadlock / serialization failure | “Debit then commit” without a unique key |
| `INSERT … ON CONFLICT DO NOTHING` flows | Fire-and-forget double `INSERT` of payments |

## Node angle

Pass `Idempotency-Key` from the API into SQL. On `23505` / conflict, return the original result, don’t debit again.

## Takeaway

Retries need idempotency. Unique keys (or upserts) make “run twice” equal “run once.”
