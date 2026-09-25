# Bulk load (`COPY`) overview

## When INSERT isn’t enough

Thousands/millions of rows: row-by-row `INSERT` from Node is slow. Postgres **`COPY`** streams data in bulk (how `pg_dump` / many ETL tools load).

## Basic idea

```sql
-- From a file the *server* can read (server filesystem)
-- COPY write_lab.tags (name) FROM '/path/on/server/tags.csv' WITH (FORMAT csv, HEADER true);

-- From stdin (what clients use)
COPY write_lab.tags (name) FROM STDIN WITH (FORMAT csv);
electronics
office
\.
```

From the host via `psql`:

```bash
# Example shape — run after reset if you experiment
echo "bulk-a
bulk-b" | docker compose exec -T postgres \
  psql -U postgres -d learn -c "COPY write_lab.tags (name) FROM STDIN"
```

## Node ecosystem

| Approach | Role |
|----------|------|
| Many `INSERT`s / multi-row INSERT | Fine for small batches |
| `COPY` via `pg` (`copyFrom` / streams) | Fast path for large loads |
| ORM `createMany` | Convenience; may not be true COPY |

You don’t need to master COPY for Module 3 — know **it exists**, that it’s the bulk tool, and that migrations/seeds sometimes use it.

## vs multi-row INSERT

```sql
INSERT INTO write_lab.tags (name) VALUES ('a'), ('b'), ('c');
```

Good up to moderate batches. For big files → COPY.

## Takeaway

OLTP apps: parameterized INSERT/UPDATE. Data loads / seeds at scale: COPY. Don’t prematurely optimize — but don’t loop 100k inserts in JS either.
