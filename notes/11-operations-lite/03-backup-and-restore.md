# Backup and restore

## Logical dump (what you’ll practice)

```bash
# from repo root — dump only ops_lab
docker compose exec -T postgres pg_dump -U postgres -d learn -n ops_lab \
  > /tmp/ops_lab.dump.sql

# peek
head /tmp/ops_lab.dump.sql
```

Restore into the same DB (after drop):

```bash
docker compose exec -T postgres psql -U postgres -d learn \
  -c 'DROP SCHEMA IF EXISTS ops_lab CASCADE;'

docker compose exec -T postgres psql -U postgres -d learn < /tmp/ops_lab.dump.sql
```

`pg_dump` / `pg_restore` (custom format) are **logical** backups — great for schema moves and learning.

## Continuous backup mindset (prod)

| Piece | Role |
|-------|------|
| Base backup | Snapshot of data files |
| WAL archiving | Replay every change since base |
| PITR | Restore to a timestamp |

Managed Postgres (RDS, Cloud SQL, Neon, …) usually does this for you — still know what “WAL” means.

## Takeaway

Lab: `pg_dump` schema ↔ restore. Prod: automated base + WAL (or vendor equivalent), tested restores.
