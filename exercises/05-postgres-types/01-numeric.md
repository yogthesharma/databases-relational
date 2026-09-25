# Exercise: Numeric types

Read: `notes/05-postgres-types/01-numeric.md`

## Tasks

1. Why is `DOUBLE PRECISION` a bad type for `products.price`?
2. Show the classic float surprise: what does `SELECT 0.1::float8 + 0.2::float8;` return vs numeric?
3. Query `types_lab.products` and show `pg_typeof(price)` and `pg_typeof(weight_kg)`.
4. Sum all product prices with `SUM(price)` — what type is the result (`pg_typeof`)?
5. Insert a product with `price = -1` — what happens and why?

## Stretch

Express $19.95 as integer cents in a `SELECT` from the Travel Adapter row.

---

## Solutions

1. Binary float can’t represent most decimals exactly → money drift / rounding bugs.
2. Float ≈ `0.30000000000000004`; `0.1::numeric + 0.2::numeric` → `0.3`.
3.

```sql
SELECT sku, pg_typeof(price), pg_typeof(weight_kg) FROM types_lab.products;
```

4.

```sql
SELECT sum(price), pg_typeof(sum(price)) FROM types_lab.products;
-- numeric
```

5. Domain/check rejects it (`money_amount` requires `>= 0`) — error.

```sql
INSERT INTO types_lab.products (sku, name, price)
VALUES ('BAD', 'Nope', -1);
```


Stretch:

```sql
SELECT sku, (price * 100)::integer AS cents
FROM types_lab.products WHERE sku = 'TP-004';
```
