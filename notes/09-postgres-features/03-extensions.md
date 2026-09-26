# Extensions

## What they are

Optional packages: `CREATE EXTENSION name;` (often superuser / privileged once per DB).

```sql
\dx
SELECT extname FROM pg_extension ORDER BY 1;
```

Lab enables:

| Extension | Why |
|-----------|-----|
| `pg_trgm` | Fuzzy / similarity (`%`, `gin_trgm_ops`) |
| `pgcrypto` | Hashing / PGP helpers (prefer app-side password policy; `gen_random_uuid()` is in **core** since PG 13) |

## Awareness list

| Extension | Use |
|-----------|-----|
| `pg_stat_statements` | Track slow queries (ops) |
| `uuid-ossp` | Older UUID gens (prefer core `gen_random_uuid()`) |
| `postgis` | Geospatial — big install, know the name |
| `pgcrypto` | Hashing / PGP (prefer app secrets mgmt for passwords at rest policy) |

## Node angle

Enable extensions in migrations carefully (permissions, prod approval). Don’t assume every host has `postgis`.

## Takeaway

Extensions unlock features; treat them as deliberate deps. Start with `pg_trgm` / stats; add PostGIS only when you need maps.
