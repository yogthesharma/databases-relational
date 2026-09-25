# Exercise: Bulk COPY overview

Read: `notes/03-writing-and-integrity/07-bulk-copy-overview.md`

This one is conceptual + a tiny hands-on — not a full ETL lab.

## Tasks

1. When would you choose `COPY` over a loop of `INSERT`s from Node?
2. Write a multi-row `INSERT` that adds tags `batch-1`, `batch-2`, `batch-3` (good enough for small batches).
3. Run a stdin `COPY` that adds tag `copy-demo` (see solution if stuck).
4. True/False: Prisma `createMany` always uses Postgres `COPY` under the hood.
5. What’s the risk of loading a huge CSV with application-level row loops?

## Stretch

Name one tool/path you’ve heard of that bulk-loads Postgres (dump/restore, ETL, etc.).

---

## Solutions

1. Large volumes (thousands+), file/ETL loads, seeds where throughput matters.
2.

```sql
BEGIN;
INSERT INTO write_lab.tags (name) VALUES ('batch-1'), ('batch-2'), ('batch-3');
ROLLBACK;
```

3.

```bash
printf 'copy-demo\n' | docker compose exec -T postgres \
  psql -U postgres -d learn -c "COPY write_lab.tags (name) FROM STDIN"
```

(Reset lab afterward if you want a clean slate, or `DELETE FROM write_lab.tags WHERE name = 'copy-demo';`.)

4. False — often multi-row insert / batched inserts; not guaranteed COPY.
5. Slow, long transactions, timeouts, more app memory, harder failure recovery.

Stretch examples: `pg_dump`/`pg_restore`, `psql` + COPY, Airbyte/Fivetran, `COPY` in migration seeds.
