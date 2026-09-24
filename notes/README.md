# Notes

Concept write-ups. Mirror the curriculum modules. Each concept file has a matching exercise under `exercises/` with the **same relative path and filename**.

## Layout

```
notes/
├── 00-setup/
│   ├── 01-relational-mental-model.md
│   ├── 02-docker-postgres.md
│   └── ...
└── 01-sql-fundamentals/
    ├── 01-select-from.md
    └── ...
```

## How to use

1. Read the note for a concept.
2. Do the matching file in `exercises/`.
3. Run SQL against the Docker Postgres (`docker compose up -d`).

Stack context for this repo: **Node.js full-stack** (connection strings, `pg`, parameterized queries). SQL itself is language-agnostic.
