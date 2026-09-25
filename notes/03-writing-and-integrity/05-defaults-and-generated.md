# Defaults and generated columns

## DEFAULT

Value used when the column is omitted from INSERT:

```sql
stock       INTEGER NOT NULL DEFAULT 0
is_active   BOOLEAN NOT NULL DEFAULT TRUE
created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
```

```sql
INSERT INTO write_lab.items (sku, title, price)
VALUES ('WL-110', 'Eraser', 0.75);
-- stock=0, is_active=true, created_at=now()
```

`DEFAULT` is not applied if you explicitly insert `NULL` (and NOT NULL will then fail).

## Generated columns (Postgres)

Computed from other columns; maintained by Postgres:

```sql
price_cents INTEGER GENERATED ALWAYS AS ((price * 100)::integer) STORED
```

- You **don’t** set `price_cents` yourself on INSERT/UPDATE (omit the column).
- Writing a literal fails; `SET price_cents = DEFAULT` is allowed but pointless — change `price` instead.
- Change `price` → `price_cents` updates automatically.

```sql
UPDATE write_lab.items SET price = 12.50 WHERE sku = 'WL-001';
SELECT sku, price, price_cents FROM write_lab.items WHERE sku = 'WL-001';
```

`STORED` = physically saved. Postgres also has virtual generated columns in newer versions — STORED is the usual choice when you might index it.

## App vs DB defaults

| In DB | In Node |
|-------|---------|
| `DEFAULT now()` | Also fine as `new Date()` — but DB default helps raw SQL/admin |
| Generated cents | Avoid drift between JS `Math.round(price*100)` and SQL |
| Business rules (stock ≥ 0) | Still validate UX-side; **enforce** in CHECK |

## Takeaway

Defaults reduce boilerplate on INSERT. Generated columns keep derived fields consistent — don’t write them from the app.
