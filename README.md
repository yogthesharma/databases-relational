# Relational Databases (PostgreSQL)

Standalone learning repo. Work here on its own — no other repos required.

**Phase (for your own roadmap):** Data  
**Primary engine:** PostgreSQL (learn relational ideas here; apply them in Postgres)  
**App context:** Node.js full-stack (`pg`, connection strings, parameterized queries)

## Context

SQL databases are still the default for most product data. Joins, indexes, transactions, and query plans decide whether your app is correct and fast. This repo is the place to learn **relational databases end-to-end**, with **PostgreSQL as the main engine** — from SQL basics through schema design, concurrency, performance, and production Postgres features.

Clone it, open it, and treat it as a complete unit of study.

## Outcomes

When you finish this curriculum, you should be able to:

- Model real domains with sound schemas (keys, constraints, normalization tradeoffs)
- Write correct, readable SQL for reads and writes (joins, CTEs, window functions, upserts)
- Use transactions and isolation levels correctly under concurrency
- Read `EXPLAIN (ANALYZE)` and fix obvious slow queries with indexes / rewrites
- Use Postgres-specific strengths (types, JSONB, full-text search, extensions) when they fit
- Operate a local Postgres confidently (roles, backups basics, migrations mindset)

---

## Curriculum

Work top to bottom. Each module → notes in `notes/`, drills in `exercises/`, then apply in `projects/` when noted.

### Module 0 — Setup & mental model

- What a relational DB is (tables, rows, columns, relations vs documents)
- Client vs server; connection; `psql` and a GUI (e.g. pgAdmin / DBeaver / TablePlus)
- Postgres via **Docker Compose in this repo only** (not a system package install)
- `psql` essentials: `\l`, `\c`, `\dt`, `\d`, `\x`, `\timing`, `\e`
- SQL vs DDL / DML / DCL / TCL
- How Node apps talk to Postgres (`pg` Pool, `DATABASE_URL`, parameterized queries)

**Checkpoint:** Connect with `psql`, create a DB, run a trivial `SELECT 1`.

---

### Module 1 — SQL fundamentals (read path)

- `SELECT`, `FROM`, `WHERE`, operators, `NULL` semantics (`IS NULL`, three-valued logic)
- Ordering, limiting: `ORDER BY`, `LIMIT` / `OFFSET` (and why OFFSET pagination hurts)
- Filtering patterns: `IN`, `BETWEEN`, `LIKE` / `ILIKE`, pattern matching basics
- Expressions, aliases, `DISTINCT`
- Aggregations: `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`, `GROUP BY`, `HAVING`
- Case expressions: `CASE WHEN`

**Checkpoint:** Answer multi-table-ish questions on a single wide table with filters + aggregates.

---

### Module 2 — Multi-table SQL (joins & set thinking)

- Primary keys, foreign keys, referential integrity
- Join types: `INNER`, `LEFT` / `RIGHT` / `FULL OUTER`, cross joins
- Join pitfalls: row multiplication, filtering in `ON` vs `WHERE`
- Set operations: `UNION` / `UNION ALL`, `INTERSECT`, `EXCEPT`
- Subqueries: scalar, `IN` / `EXISTS`, correlated vs non-correlated
- CTEs: `WITH` (readable queries; recursive CTEs intro)

**Checkpoint:** Rewrite nested subqueries as joins/CTEs; explain when `EXISTS` beats `IN`.

---

### Module 3 — Writing data & integrity

- `INSERT`, `UPDATE`, `DELETE`, `TRUNCATE` (and when each is appropriate)
- `RETURNING`
- Constraints: `NOT NULL`, `UNIQUE`, `CHECK`, `PRIMARY KEY`, `FOREIGN KEY` (actions: `ON DELETE` / `ON UPDATE`)
- Default values, generated columns (Postgres)
- Upserts: `INSERT ... ON CONFLICT`
- Bulk loading mindset (`COPY` overview)

**Checkpoint:** Design constraints so invalid states cannot be inserted; demonstrate with failing inserts.

---

### Module 4 — Schema design & normalization

- Entities, attributes, relationships (1:1, 1:N, M:N)
- Keys: candidate, primary, surrogate vs natural
- Normalization: 1NF → 2NF → 3NF (and when BCNF matters)
- When to denormalize (read-heavy paths, aggregates, caching columns) — consciously
- Naming conventions; schemas (`public` vs app schemas)
- Migrations mindset: evolve schema without breaking apps (expand/contract)
- Modeling patterns: soft deletes, audit columns, enums vs lookup tables

**Checkpoint:** Take a messy spreadsheet domain → normalized schema + seed data.

---

### Module 5 — Types in PostgreSQL (use the type system)

- Numeric types; money pitfalls; `numeric` vs float
- Text: `text` vs `varchar`; collations basics
- Temporal: `date`, `time`, `timestamp`, `timestamptz` (prefer timestamptz), intervals
- Boolean; UUID; arrays
- Enums; domains
- JSON / JSONB: when relational columns win vs document-ish payloads
- Other useful types: `inet`, ranges (overview)

**Checkpoint:** Pick correct types for a sample app schema and justify each choice.

---

### Module 6 — Transactions, concurrency & ACID

- Transactions: `BEGIN` / `COMMIT` / `ROLLBACK`; savepoints
- ACID in practice
- Isolation levels: Read Committed (Postgres default), Repeatable Read, Serializable
- Phenomena: dirty read, non-repeatable read, phantom read, write skew
- Locks: row locks, `SELECT FOR UPDATE` / `FOR SHARE`; deadlocks
- Idempotency and safe retries at the SQL layer

**Checkpoint:** Reproduce a race (lost update) and fix it with a transaction + locking or constraints.

---

### Module 7 — Indexing & query performance

- How Postgres plans queries (planner + executor overview)
- B-tree indexes (default); when indexes help vs hurt
- Composite indexes; column order; covering / index-only scans (overview)
- Partial indexes; expression indexes
- Other index types (awareness): Hash, GiST, GIN, BRIN — when each shows up
- `EXPLAIN` / `EXPLAIN (ANALYZE, BUFFERS)` — read seq scan vs index scan vs bitmap, costs, actual time
- Common slow-query patterns and rewrites
- Statistics: `ANALYZE`; bloat awareness (high level)
- Vacuum / autovacuum (what they do and why you care)

**Checkpoint:** Take a slow query → `EXPLAIN ANALYZE` → add the right index or rewrite → prove improvement.

---

### Module 8 — Advanced SQL (set-based power tools)

- Window functions: `OVER`, partitions, frames; ranking; running totals
- Advanced CTEs; recursive queries (graphs, trees, org charts)
- Lateral joins (`LATERAL`)
- Filtering aggregates: `FILTER (WHERE ...)`
- Grouping sets / `ROLLUP` / `CUBE` (overview)
- Distinct on (`DISTINCT ON`) — Postgres-specific patterns

**Checkpoint:** Replace procedural “loop in app” logic with window functions / recursive CTEs.

---

### Module 9 — Postgres features that matter in products

- JSONB operators & indexing (GIN); when to use JSONB columns
- Full-text search: `tsvector` / `tsquery`, ranking, simple indexes
- Extensions ecosystem: `CREATE EXTENSION` (e.g. `pgcrypto`, `uuid-ossp` / `pgcrypto` gen, `pg_trgm`, `postgis` awareness)
- Views & materialized views
- Functions & procedures (SQL/PL/pgSQL) — when logic belongs in DB vs app
- Triggers (use sparingly; audit/derived data cases)
- Row Level Security (RLS) overview
- Listen/notify overview (optional)

**Checkpoint:** Build one feature that needs JSONB **or** FTS **or** a materialized view — not all three.

---

### Module 10 — Security, roles & access

- Roles, users, login roles; least privilege
- `GRANT` / `REVOKE`; privileges on tables, sequences, schemas
- Ownership vs grants
- Connection security basics (pg_hba mindset; SSL awareness)
- Secrets: never commit connection strings; env-based config
- SQL injection: parameterized queries only (app side)

**Checkpoint:** Create an app role that can DML on app tables but cannot drop them or read other schemas.

---

### Module 11 — Operations lite (enough to not fear production)

- Config awareness: connections, memory (names only — don’t memorize every knobs)
- Connection pooling (why PgBouncer exists)
- Backup / restore basics: `pg_dump` / `pg_restore`; continuous backup concept (WAL)
- Replication concepts: primary / replica; read replicas use cases
- Monitoring basics: slow query log, `pg_stat_statements` awareness
- Migrations in real teams (expand/contract; zero-downtime mindset)

**Checkpoint:** Dump and restore a local database; explain what you’d need for a real backup strategy.

---

### Module 12 — From SQL to applications

- ORMs vs query builders vs raw SQL — tradeoffs
- N+1 queries; batching; transactions across app code
- Migrations tools awareness (e.g. Prisma Migrate, Flyway, golang-migrate, sqitch — pick what you use later)
- Testing DB code: fixtures, transactional tests
- Designing repositories / data access so SQL stays inspectable

**Checkpoint:** Wire a tiny app (any language you know) to Postgres with parameterized queries and one transactional use case.

---

## Suggested projects (ship at least 2)

Pick from these after Modules 4–7 (more as you go):

1. **Schema lab** — Domain you care about (e.g. bookstore, jobs board, habit tracker): ERD → migrations → seed → integrity tests via SQL
2. **Query gym** — Fixed schema + 20+ questions escalating from filters → joins → windows → `EXPLAIN` fixes
3. **Concurrency kata** — Bank transfer / inventory reservation that stays correct under parallel clients
4. **Search & JSON** — Product catalog with relational core + JSONB attributes + trigram or FTS search
5. **App slice** — Minimal API/CLI over Postgres with roles, migrations, and one transactional workflow

---

## How to work in this repo

1. Start Postgres: `cp .env.example .env` then `docker compose up -d`.
2. Read a concept under `notes/<module>/`.
3. Do the **same-named** file under `exercises/<module>/`.
4. Run SQL via `docker compose exec postgres psql -U postgres -d learn`.
5. Ship projects under `projects/` later (leave that folder alone until you’re ready).
6. Tick the progress checklist below as you go.

Notes and exercises share paths: `notes/01-sql-fundamentals/01-select-from.md` ↔ `exercises/01-sql-fundamentals/01-select-from.md`.

You do not need any other curriculum repo open while you work here.

## Layout

```
databases-relational/
├── README.md
├── docker-compose.yml      # Postgres 16 (Docker only)
├── .env.example
├── docker/init/            # Schema + seed on first boot
├── notes/
│   ├── 00-setup/
│   ├── 01-sql-fundamentals/
│   ├── 02-joins-and-sets/
│   ├── 03-writing-and-integrity/
│   ├── 04-schema-design/
│   ├── 05-postgres-types/
│   ├── 06-transactions-concurrency/
│   ├── 07-indexing-performance/
│   └── 08-advanced-sql/
├── exercises/              # Same module/concept filenames as notes/
│   ├── 00-setup/
│   ├── 01-sql-fundamentals/
│   ├── 02-joins-and-sets/
│   ├── 03-writing-and-integrity/
│   ├── 04-schema-design/
│   ├── 05-postgres-types/
│   ├── 06-transactions-concurrency/
│   ├── 07-indexing-performance/
│   └── 08-advanced-sql/
└── projects/               # Later — not started yet
```

---

## Progress

### Modules

- [x] 0 — Setup & mental model
- [x] 1 — SQL fundamentals
- [x] 2 — Joins & set thinking
- [x] 3 — Writing data & integrity
- [x] 4 — Schema design & normalization
- [x] 5 — PostgreSQL types
- [x] 6 — Transactions & concurrency
- [x] 7 — Indexing & performance
- [ ] 8 — Advanced SQL
- [ ] 9 — Postgres product features
- [ ] 10 — Security & roles
- [ ] 11 — Operations lite
- [ ] 12 — SQL in applications

### Repo outcomes

- [ ] Core concepts noted under `notes/`
- [ ] Exercises completed under `exercises/`
- [ ] At least two mini-projects shipped under `projects/`
- [ ] Can explain ACID, isolation, indexes, and `EXPLAIN` without looking anything up
- [ ] Comfortable day-to-day in `psql` + one GUI

---

## Resources

Keep this list local to this topic; add as you find them.

### Canonical

- [PostgreSQL official docs](https://www.postgresql.org/docs/current/) — primary reference
- [PostgreSQL Tutorial (postgresqltutorial.com)](https://www.postgresqltutorial.com/) — structured SQL practice
- [Use The Index, Luke](https://use-the-index-luke.com/) — indexing & plans mindset
- [Postgres Guide](https://postgresguide.com/) — practical Postgres

### Deeper (optional)

- *SQL Performance Explained* (Markus Winand)
- *Designing Data-Intensive Applications* — storage/replication chapters (broader than Postgres)
- [PGSQL Phriday / Planet Postgres](https://planet.postgresql.org/) — community writing
- [explain.depesz.com](https://explain.depesz.com/) — paste `EXPLAIN` output

### Practice datasets (optional)

- Pagila / DVD rental sample
- Chinook
- Your own seeded domain from Module 4

---

_This repo is independent. Progress elsewhere does not block work here._
