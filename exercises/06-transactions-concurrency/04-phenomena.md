# Exercise: Phenomena

Read: `notes/06-transactions-concurrency/04-phenomena.md`

## Tasks

1. Define dirty read, non-repeatable read, and phantom read in one line each.
2. Which of those three does Postgres allow at default isolation? What about phantoms under Postgres **Repeatable Read**?
3. Reset the lab. Two-session demo: Session A `BEGIN` and set alice balance to `1` (don’t commit). Session B `SELECT` alice. What does B see? What phenomenon was prevented?
4. In words: how would you demo a non-repeatable read with two sessions?
5. What is write skew (one sentence)?

## Stretch

Name one defense against write skew besides Serializable.

---

## Solutions

1. Dirty: see uncommitted data. Non-repeatable: same row changes between reads due to another commit. Phantom: new rows appear in a re-run range query.
2. At **Read Committed**: non-repeatable and phantoms (not dirty reads). At Postgres **Repeatable Read**: phantoms are prevented too (still watch write skew / serialization anomalies).
3. B still sees the last committed balance (e.g. `100` after reset). **Dirty read** prevented.
4. A: `BEGIN`; `SELECT` alice; wait. B: `UPDATE` alice and commit. A: `SELECT` alice again → different value under Read Committed.
5. Two transactions each preserve an invariant alone but together break it.

Stretch: explicit locks (`FOR UPDATE`), constraints, or single-row atomic updates that encode the rule.
