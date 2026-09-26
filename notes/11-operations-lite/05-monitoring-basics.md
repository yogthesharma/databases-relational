# Monitoring basics

## What to watch

| Signal | Why |
|--------|-----|
| Slow query log / `log_min_duration_statement` | Catch outliers |
| `pg_stat_statements` | Aggregated query totals (extension) |
| Connections / waiting | Pool exhaustion, locks |
| Replication lag | Stale reads / failover risk |
| Disk / bloat / vacuum | Ops health |

```sql
-- May be off until created in shared_preload / CREATE EXTENSION
-- SELECT query, calls, total_exec_time
-- FROM pg_stat_statements
-- ORDER BY total_exec_time DESC
-- LIMIT 5;
```

In this Docker lab, `pg_stat_statements` may not be preloaded — know the **name** and purpose.

## Developer habit

When an endpoint is slow: capture SQL → `EXPLAIN (ANALYZE, BUFFERS)` → fix index/query (Module 7).

## Takeaway

You can’t fix what you don’t measure. Slow log + `EXPLAIN` cover most app-side DB pain.
