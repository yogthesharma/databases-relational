# Exercise: Idempotency & retries

Read: `notes/06-transactions-concurrency/06-idempotency-and-retries.md`

Reset lab for clean balances/keys.

## Tasks

1. Why can retrying a payment transaction be dangerous?
2. Insert a transfer alice→bob of `15` with `idempotency_key = 'lab-key-1'` and update balances in one txn.
3. Run the **same** insert again (same key). What happens? What should the app do?
4. Write an `INSERT … ON CONFLICT (idempotency_key) DO NOTHING` version and explain how you’d know whether to apply balances.
5. Name two Postgres error situations where retrying the **whole** txn is appropriate (if idempotent).

## Stretch

After a successful keyed transfer, confirm `SELECT idempotency_key FROM tx_lab.transfers`.

---

## Solutions

1. A second successful run can double-charge / double-move money.
2.

```sql
BEGIN;
INSERT INTO tx_lab.transfers (from_account_id, to_account_id, amount, idempotency_key)
SELECT a.id, b.id, 15, 'lab-key-1'
FROM tx_lab.accounts a, tx_lab.accounts b
WHERE a.name = 'alice' AND b.name = 'bob';
UPDATE tx_lab.accounts SET balance = balance - 15 WHERE name = 'alice';
UPDATE tx_lab.accounts SET balance = balance + 15 WHERE name = 'bob';
COMMIT;
```

3. `unique_violation` (`23505`) — treat as already processed; **don’t** debit again.
4.

```sql
BEGIN;
INSERT INTO tx_lab.transfers (from_account_id, to_account_id, amount, idempotency_key)
SELECT a.id, b.id, 15, 'lab-key-2'
FROM tx_lab.accounts a, tx_lab.accounts b
WHERE a.name = 'alice' AND b.name = 'bob'
ON CONFLICT (idempotency_key) DO NOTHING
RETURNING id;
-- If a row was returned, run the two UPDATEs below; if not, ROLLBACK/COMMIT with no money moves.
UPDATE tx_lab.accounts SET balance = balance - 15 WHERE name = 'alice';
UPDATE tx_lab.accounts SET balance = balance + 15 WHERE name = 'bob';
COMMIT;
```

Don’t insert a transfer row without the matching balance updates — that orphans a “payment” with no money movement.

5. Deadlock (`40P01`); serialization failure (`40001`).

Stretch: `lab-key-1` (and `lab-key-2` if you ran stretch insert) appear in `transfers`.
