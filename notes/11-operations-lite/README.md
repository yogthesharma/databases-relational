# Module 11 — Operations lite

Same DB `learn`. Practice dump/restore on schema **`ops_lab`**.

**Apply / reset ops lab:**

```bash
docker compose exec -T postgres psql -U postgres -d learn < docker/init/11-module11-ops-lab.sql
```

| # | Concept | Notes |
|---|---------|-------|
| 01 | Config awareness | [01-config-awareness.md](./01-config-awareness.md) |
| 02 | Connection pooling | [02-connection-pooling.md](./02-connection-pooling.md) |
| 03 | Backup & restore | [03-backup-and-restore.md](./03-backup-and-restore.md) |
| 04 | Replication concepts | [04-replication-concepts.md](./04-replication-concepts.md) |
| 05 | Monitoring basics | [05-monitoring-basics.md](./05-monitoring-basics.md) |
| 06 | Migrations in teams | [06-migrations-in-teams.md](./06-migrations-in-teams.md) |
| 07 | Checkpoint: dump/restore | [07-checkpoint-dump-restore.md](./07-checkpoint-dump-restore.md) |

Matching exercises: `exercises/11-operations-lite/`.

**Checkpoint:** Dump `ops_lab`, drop it, restore it, confirm rows.
