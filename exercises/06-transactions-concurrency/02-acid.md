# Exercise: ACID

Read: `notes/06-transactions-concurrency/02-acid.md`

## Tasks

1. Map each ACID letter to one concrete Postgres/SQL behavior.
2. Why is transferring money as two separate autocommit `UPDATE`s not atomic?
3. Write a single transaction that transfers `20` alice→bob **and** inserts a `transfers` row (no idempotency key yet).
4. Force a failure: transfer more than alice has inside a transaction — after `ROLLBACK`, have balances changed?
5. Does a successful `CHECK` constraint mean your business rules are complete? Why/why not?

## Stretch

After a successful transfer txn, run `SELECT sum(balance) FROM tx_lab.accounts` and compare to the sum of seed balances (175) plus/minus any earlier exercises — conservation check.

---

## Solutions

1. **A** `COMMIT`/`ROLLBACK`; **C** constraints/invariants; **I** isolation levels/locks; **D** committed data survives (WAL).
2. A crash between them can leave money vanished or duplicated relative to intent.
3.

```sql
BEGIN;
UPDATE tx_lab.accounts SET balance = balance - 20 WHERE name = 'alice';
UPDATE tx_lab.accounts SET balance = balance + 20 WHERE name = 'bob';
INSERT INTO tx_lab.transfers (from_account_id, to_account_id, amount)
SELECT a.id, b.id, 20
FROM tx_lab.accounts a, tx_lab.accounts b
WHERE a.name = 'alice' AND b.name = 'bob';
COMMIT;
```

4. No — `ROLLBACK` restores; overdraft hits `balance >= 0` and aborts the txn (then roll back).
5. No — constraints catch invalid states you declared; business logic can still be wrong.

Stretch: sum should stay `175.00` if you only moved money between accounts (no external insert of funds).
