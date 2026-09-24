# Connecting from Node.js

## Goal

Talk to the Compose Postgres from Node using the **`pg`** driver — the foundation under Prisma, Knex, Slonik, and many ORMs.

## Connection string

From `.env` (see `.env.example`):

```
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/learn
```

Parts: `postgresql://USER:PASSWORD@HOST:PORT/DATABASE`

## Install (scratch folder or later project)

You can keep experiments out of `projects/` for now — e.g. a throwaway folder — or run snippets from anywhere with `pg` installed:

```bash
npm init -y
npm install pg dotenv
```

## Minimal query (parameterized)

```js
import 'dotenv/config';
import pg from 'pg';

const pool = new pg.Pool({ connectionString: process.env.DATABASE_URL });

const { rows } = await pool.query(
  'SELECT id, first_name, department FROM employees WHERE department = $1',
  ['Engineering']
);

console.log(rows);
await pool.end();
```

**Always use `$1`, `$2`, … parameters** — never string-concatenate user input into SQL (SQL injection).

## Pool vs Client

| | When |
|--|------|
| **`Pool`** | Default for web apps — reuses connections across requests |
| **`Client`** | One-off scripts, or when you need a session for a transaction |

Express/Fastify: create **one pool** at startup, reuse it. Don’t `new Pool()` per request.

## Same DB, other Node tools (awareness)

| Tool | Role |
|------|------|
| `pg` | Raw SQL, full control |
| Prisma | Schema + client + migrations |
| Drizzle / Kysely | Type-safe SQL-ish |
| Knex | Query builder + migrations |

This curriculum teaches **SQL first**. Use ORMs later without treating them as magic.

## Smoke test without a project

```bash
docker compose exec postgres psql -U postgres -d learn -c \
  "SELECT id, first_name FROM employees LIMIT 3;"
```

If that works, Node on `localhost:5432` will too once `pg` is configured.

## Takeaway

`DATABASE_URL` → `pg.Pool` → parameterized `query()`. One pool per process. SQL injection defense = parameters, not escaping by hand.
