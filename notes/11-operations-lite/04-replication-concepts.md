# Replication concepts

## Primary / replica

| Node | Role |
|------|------|
| **Primary** (writer) | Accepts writes; source of truth |
| **Replica** (standby) | Replays WAL; usually read-only |

## Why read replicas

- Scale **read-heavy** traffic  
- Isolate analytics / reporting  
- Failover target (with orchestration)

## What replicas are not

- Not a substitute for backups (correlated failure / bad DELETE replicates)  
- Async replicas can **lag** — reads may be slightly stale  
- You still need connection routing (app or proxy)

## Takeaway

Replicas help read scale and HA designs. Backups + tested restore remain mandatory.
