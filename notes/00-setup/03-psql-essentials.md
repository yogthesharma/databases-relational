# psql essentials

`psql` is the official Postgres CLI. As a Node developer you’ll still use it constantly: inspect schema, debug a Prisma query, run one-off fixes, read `EXPLAIN`.

## Open a session

```bash
docker compose exec postgres psql -U postgres -d learn
```

Prompt looks like: `learn=#`

## Meta-commands (not SQL)

| Command | What it does |
|---------|----------------|
| `\l` | List databases |
| `\c learn` | Connect to database `learn` |
| `\dt` | List tables in current schema |
| `\d employees` | Describe table (columns, indexes, FKs) |
| `\dn` | List schemas |
| `\du` | List roles |
| `\x` | Toggle expanded display (great for wide rows) |
| `\timing` | Show query duration |
| `\e` | Edit last query in `$EDITOR` |
| `\q` | Quit |
| `\?` | Help for meta-commands |
| `\h SELECT` | Help for SQL `SELECT` |

## Run SQL

```sql
SELECT 1;
SELECT * FROM employees LIMIT 5;
```

Multi-line is fine; end with `;`.

## One-shot from the shell

```bash
docker compose exec postgres psql -U postgres -d learn -c '\dt'
docker compose exec postgres psql -U postgres -d learn -c 'SELECT count(*) FROM products;'
```

## Tips for Node workflows

- When an API returns wrong data, reproduce the query in `psql` first.
- `\x on` then `SELECT * FROM employees WHERE id = 1;` is easier to read than wide tables.
- Turn on `\timing` when you start caring about performance (Module 7).

## Takeaway

Memorize `\dt`, `\d`, `\x`, `\timing`, `\q`. Everything else you can look up with `\?`.
