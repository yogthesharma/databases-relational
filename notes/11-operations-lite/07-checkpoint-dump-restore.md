# Checkpoint — dump and restore

## Goal

1. Ensure `ops_lab` has widgets  
2. `pg_dump` the schema to a file  
3. `DROP SCHEMA ops_lab CASCADE`  
4. Restore from the dump  
5. Confirm `alpha` / `beta` / `gamma` are back  

## Commands (repo root)

```bash
docker compose exec -T postgres psql -U postgres -d learn < docker/init/11-module11-ops-lab.sql

docker compose exec -T postgres pg_dump -U postgres -d learn -n ops_lab \
  > /tmp/ops_lab.dump.sql

docker compose exec -T postgres psql -U postgres -d learn \
  -c 'DROP SCHEMA ops_lab CASCADE;'

docker compose exec -T postgres psql -U postgres -d learn < /tmp/ops_lab.dump.sql

docker compose exec -T postgres psql -U postgres -d learn \
  -c 'SELECT name, qty FROM ops_lab.widgets ORDER BY name;'
```

## Real backup strategy (say it out loud)

Automated base backups + WAL (or vendor PITR), encrypted offsite copies, **restore drills**, alerts on failure, retention policy — not only “we ran `pg_dump` once.”

## Takeaway

A dump you never restore is a wish. Practice restore in the lab; automate and test in prod.
