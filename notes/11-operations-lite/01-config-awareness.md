# Config awareness

## Knobs you’ll hear about (names only)

| Setting | Rough meaning |
|---------|----------------|
| `max_connections` | Cap on concurrent sessions |
| `shared_buffers` | Main Postgres cache of pages |
| `work_mem` | Memory for sort/hash per operation |
| `maintenance_work_mem` | Vacuum / index build memory |
| `effective_cache_size` | Planner hint for OS cache |

```sql
SHOW max_connections;
SHOW shared_buffers;
```

You don’t tune these in this lab — know **what they affect** when someone says “we’re out of connections” or “sort spilled to disk.”

## Connections vs apps

Each client session costs memory. App servers that open one connection per request without a pool will hit `max_connections` fast.

## Takeaway

Know the names. Tuning is ops/SRE territory; developers feel the symptoms (timeouts, slow sorts, connection errors).
