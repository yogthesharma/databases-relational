# Exercises

Practice problems. Every file here matches a note under `notes/` with the **same relative path and filename**.

## Layout

```
exercises/
├── 00-setup/
│   ├── 01-relational-mental-model.md
│   └── ...
└── 01-sql-fundamentals/
    ├── 01-select-from.md
    └── ...
```

## How to use

1. Start Postgres: `docker compose up -d` (from repo root).
2. Connect: `docker compose exec postgres psql -U postgres -d learn`
3. Read the matching note first, then solve here.
4. Check answers only after you try — solutions are at the bottom of each exercise file (collapsed behind a heading).

Seeded tables for early modules: `employees`, `products` (see `docker/init/`).

Stack context: **Node.js full-stack** — a few exercises ask for a tiny `pg` snippet; most are pure SQL.
