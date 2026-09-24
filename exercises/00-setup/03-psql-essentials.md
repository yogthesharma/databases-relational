# Exercise: psql essentials

Read: `notes/00-setup/03-psql-essentials.md`

## Tasks

Open interactive psql:

```bash
docker compose exec postgres psql -U postgres -d learn
```

Then:

1. List databases (`\l`). Which one are you using for this course?
2. List tables (`\dt`).
3. Describe `products` (`\d products`). How many columns? What’s the primary key?
4. Run `SELECT * FROM employees LIMIT 3;` then toggle `\x` and run it again. Which view is easier?
5. Turn on `\timing` and run `SELECT count(*) FROM products;`. Note the time.
6. Exit (`\q`).

## Stretch

From the host (non-interactive), run a query that returns only `sku` and `name` from `products` (5 rows).

---

## Solutions

1. `learn` (and `postgres`, `template0`, `template1` exist too).
2. `employees`, `products`.
3. Columns include `id`, `sku`, `name`, `category`, `price`, `stock_qty`, `is_discontinued`, `created_at`. PK = `id`.
4. Expanded (`\x`) is usually easier for many columns.
5. Timing varies; command works if you see `Time: … ms`.
6. Stretch:

```bash
docker compose exec postgres psql -U postgres -d learn -c \
  "SELECT sku, name FROM products LIMIT 5;"
```
