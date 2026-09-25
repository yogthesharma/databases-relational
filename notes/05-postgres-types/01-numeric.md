# Numeric types

## Pick by meaning, not habit

| Type | Use when | Watch out |
|------|----------|-----------|
| `INTEGER` / `BIGINT` | Counts, IDs, whole quantities | Overflow (rare with `BIGINT`) |
| `NUMERIC(p,s)` / `DECIMAL` | Money, exact decimals | Slightly slower; specify scale |
| `REAL` / `DOUBLE PRECISION` | Science, sensors, approximate math | **Not money** — binary float drift |
| `SMALLINT` | Tiny bounded ints | Easy to outgrow |

`NUMERIC` and `DECIMAL` are the same in Postgres.

## Money pitfall

```sql
-- Float looks fine until it doesn't:
SELECT 0.1::double precision + 0.2::double precision;
-- 0.30000000000000004

SELECT 0.1::numeric + 0.2::numeric;
-- 0.3
```

Store currency as `NUMERIC(12,2)` (or integer **cents**). Avoid `money` type (locale-sensitive, awkward). Never accumulate prices in `float`/`double` in SQL or JS and expect pennies to match.

## In the lab

```sql
SELECT sku, price, pg_typeof(price) FROM types_lab.products;
-- pg_typeof shows the domain name (types_lab.money_amount), which is still NUMERIC underneath

-- weight_kg is DOUBLE PRECISION on purpose (approximate mass is fine)
SELECT sku, weight_kg FROM types_lab.products WHERE weight_kg IS NOT NULL;
```

## Node angle

`pg` returns `NUMERIC` as a **string** by default (so JS doesn’t lose precision). Parse with a decimal library or keep cents as integers in the app.

## Takeaway

Counts → integers. Money / exact decimals → `NUMERIC`. Floats only when approximation is OK.
