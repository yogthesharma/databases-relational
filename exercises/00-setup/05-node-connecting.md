# Exercise: Node connecting

Read: `notes/00-setup/05-node-connecting.md`

You can do this outside `projects/` (throwaway folder is fine). Goal is the connection pattern, not a polished app.

## Tasks

1. Confirm DB from shell first:

```bash
docker compose exec postgres psql -U postgres -d learn -c \
  "SELECT count(*) AS n FROM employees;"
```

2. In a scratch directory (e.g. `/tmp/pg-smoke` or anywhere you like **except** committing junk into this repo unless you want to):

```bash
npm init -y
npm install pg dotenv
```

3. Copy `DATABASE_URL` from the repo `.env`.
4. Write a small ESM or CJS script that:
   - Creates a `Pool`
   - Runs `SELECT id, first_name, department FROM employees WHERE is_active = $1`
   - Passes `[true]` as parameters
   - Prints row count
   - Calls `pool.end()`
5. Explain in one sentence why `$1` beats string concatenation for `department` filters from HTTP query params.

## Stretch

Use the same pool to run two queries in sequence: count of Engineering employees, then count of products with `stock_qty = 0`.

---

## Solutions

Example script (ESM — add `"type": "module"` in `package.json`). Export `DATABASE_URL` or copy the repo `.env` into the scratch folder:

```js
import 'dotenv/config';
import pg from 'pg';

async function main() {
  const pool = new pg.Pool({ connectionString: process.env.DATABASE_URL });

  const { rows } = await pool.query(
    'SELECT id, first_name, department FROM employees WHERE is_active = $1',
    [true]
  );

  console.log('rows:', rows.length);
  await pool.end();
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
```

5. Parameters keep user input out of the SQL string parser → prevents SQL injection.

Stretch shape:

```js
const eng = await pool.query(
  `SELECT count(*)::int AS n FROM employees WHERE department = $1`,
  ['Engineering']
);
const oos = await pool.query(
  `SELECT count(*)::int AS n FROM products WHERE stock_qty = 0`
);
```
