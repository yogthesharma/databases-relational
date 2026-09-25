# ACID in practice

## The four letters (Postgres edition)

| Letter | Meaning | What you actually do |
|--------|---------|----------------------|
| **A**tomicity | All or nothing | `BEGIN`…`COMMIT` / `ROLLBACK`; constraints abort bad txns |
| **C**onsistency | DB rules hold after commit | `CHECK`, `FK`, `UNIQUE`, app invariants inside the txn |
| **I**solation | Concurrent txns don’t step on each other wrongly | Isolation level + locks (next notes) |
| **D**urability | Committed data survives crash | WAL + `fsync` (ops detail later); for you: **COMMIT means kept** |

## Atomic transfer (lab)

Wrong (two autocommit statements — crash/error between them loses money):

```sql
UPDATE tx_lab.accounts SET balance = balance - 20 WHERE name = 'alice';
-- power blip / app crash here
UPDATE tx_lab.accounts SET balance = balance + 20 WHERE name = 'bob';
```

Right:

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

If the second `UPDATE` fails (e.g. overdraft `CHECK`), the transaction is **aborted** — run `ROLLBACK` and **neither** balance change is kept.

## Consistency ≠ “business always happy”

ACID consistency = schema constraints + whatever you enforce in the transaction. It does **not** automatically mean “correct pricing strategy.” You still write correct SQL.

## Takeaway

Atomic multi-step writes live in one transaction. Constraints are your consistency net. Isolation and durability are the other half — next notes and ops.
