# Connection pooling

## Why pools exist

Opening a Postgres session is relatively expensive. Node/`pg` **Pool** reuses a small set of server connections across many requests.

```js
import pg from 'pg';
const pool = new pg.Pool({ connectionString: process.env.DATABASE_URL, max: 10 });
```

## Why PgBouncer (and friends)

At larger scale, many app instances × pool size ≈ too many DB connections. **PgBouncer** (or cloud poolers) sits in front and multiplexes client connections onto fewer server backends.

| Layer | Role |
|-------|------|
| App pool (`pg.Pool`) | Reuse within one process |
| PgBouncer / pooler | Cap connections across the fleet |

## Transaction vs session pooling

PgBouncer “transaction” mode is common for web apps (no session-sticky features). Session mode needed for some session-level features (`LISTEN`, temp tables, prepared statements caveats).

## Takeaway

Always use a pool in apps. Add an external pooler when instance count × pool size threatens `max_connections`.
