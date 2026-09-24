# Relational mental model

## Why this matters (Node full-stack)

Your API and UI talk about **resources** (users, orders, posts). Postgres stores those as **tables of rows**. Every Express/Fastify/Next route that “gets data” eventually becomes SQL (or an ORM that generates SQL). If the mental model is wrong, you get N+1 queries, broken joins, and inconsistent writes.

## Core ideas

| Idea | Meaning |
|------|---------|
| **Relation / table** | A named set of rows with a fixed set of columns |
| **Row / tuple** | One record (one employee, one product) |
| **Column / attribute** | A typed field (`salary NUMERIC`, `email TEXT`) |
| **Schema (design)** | Structure: tables, columns, types, constraints |
| **Schema (Postgres)** | A namespace inside a DB (default: `public`) — later modules |
| **Database** | A named container of schemas/tables (we use `learn`) |
| **Primary key** | Uniquely identifies a row (`employees.id`) |
| **Foreign key** | A column that points at another row’s key (`manager_id → employees.id`) |

Relational = data is stored so that **relationships are explicit** (keys), and you **query with SQL** instead of loading nested JSON blobs by default.

## Relational vs documents (quick)

| Relational (Postgres) | Document (e.g. Mongo) |
|----------------------|------------------------|
| Fixed columns + types | Flexible documents |
| Joins are first-class | Embed or application-side join |
| Strong constraints | Often validated in app |
| Great for multi-row consistency | Great for flexible/nested payloads |

Postgres also has **JSONB** (later module) when you need document-ish flexibility *inside* a relational core — common in Node apps.

## How a request becomes SQL

```
Browser → Next/Express route → pg / Prisma / Drizzle → PostgreSQL → rows → JSON response
```

You still need to understand tables and SQL even if you use Prisma: the ORM maps models → tables and queries → SQL.

## In this repo

After Docker starts, you already have:

- `employees` — people, departments, salaries, managers
- `products` — catalog with price/stock

Inspect them with `\dt` and `\d employees` in `psql` (next notes).

## Takeaway

Think in **tables + keys + queries**, not “one big nested object.” Your Node layer serializes rows to JSON; Postgres owns integrity and set-based reads/writes.
