# Concurrency phenomena

Names you’ll hear in interviews and docs. Postgres prevents some by default.

| Phenomenon | Meaning | Postgres default (Read Committed) |
|------------|---------|-----------------------------------|
| **Dirty read** | See another txn’s uncommitted write | **Prevented** |
| **Non-repeatable read** | Re-read a row; committed update changed it | **Possible** |
| **Phantom read** | Re-run a range query; new matching rows appeared | **Possible** at Read Committed. **Prevented** at Repeatable Read / Serializable in Postgres (stronger than the SQL standard’s RR) |
| **Write skew** | Two txns each OK alone, together break an invariant | Possible at RC **and** Postgres RR (snapshot isolation); Serializable targets this |

## Dirty read — blocked

Session A:

```sql
BEGIN;
UPDATE tx_lab.accounts SET balance = 0 WHERE name = 'alice';
-- not committed
```

Session B:

```sql
SELECT balance FROM tx_lab.accounts WHERE name = 'alice';
-- still 100 — cannot see A’s uncommitted 0
```

## Non-repeatable read — possible at Read Committed

Session A:

```sql
BEGIN;
SELECT balance FROM tx_lab.accounts WHERE name = 'alice';  -- 100
-- wait…
SELECT balance FROM tx_lab.accounts WHERE name = 'alice';  -- maybe 80 if B committed
COMMIT;
```

Session B (between A’s two selects):

```sql
UPDATE tx_lab.accounts SET balance = balance - 20 WHERE name = 'alice';
-- autocommit
```

## Write skew (awareness)

Classic: two doctors on call; each txn checks “at least one on call,” both go off duty. Each read looked fine; together they violate the rule. Serializable (or explicit locks / constraints) fixes it. Know the name; you’ll practice simpler races in the lost-update note.

## Takeaway

No dirty reads in Postgres. Non-repeatable reads and phantoms are possible at Read Committed; Postgres Repeatable Read blocks both (still watch write skew). Practice the simpler lost-update race next.
