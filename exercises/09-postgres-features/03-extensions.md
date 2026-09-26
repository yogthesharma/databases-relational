# Exercise: Extensions

Read: `notes/09-postgres-features/03-extensions.md`

## Tasks

1. List installed extensions (`\dx` or catalog).
2. Which two extensions does the Module 9 seed enable?
3. What is `pg_trgm` for?
4. When would you add PostGIS?
5. Why be careful enabling extensions in production migrations?

## Stretch

Generate a UUID with `gen_random_uuid()` (core) — confirm it works without `uuid-ossp`.

---

## Solutions

1. `\dx` or `SELECT extname FROM pg_extension;`
2. `pg_trgm` and `pgcrypto`.
3. Trigram similarity / fuzzy matching (and `ILIKE`-friendly indexes).
4. When you store/query real geospatial data (maps, distances).
5. Needs privileges; not on all hosts; becomes a hard dependency for restores.

Stretch: `SELECT gen_random_uuid();`
