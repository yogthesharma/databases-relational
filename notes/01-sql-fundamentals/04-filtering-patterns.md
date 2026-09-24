# Filtering patterns

Beyond simple comparisons.

## IN / NOT IN

```sql
SELECT first_name, department
FROM employees
WHERE department IN ('Engineering', 'Product');
```

`NOT IN` + NULLs in the list is a footgun — prefer `NOT EXISTS` later, or keep lists non-null.

## BETWEEN

Inclusive on both ends:

```sql
SELECT name, price FROM products
WHERE price BETWEEN 50 AND 150;
```

## LIKE / ILIKE (pattern match)

| Pattern | Meaning |
|---------|---------|
| `%` | Any sequence of characters |
| `_` | Exactly one character |

```sql
SELECT email FROM employees WHERE email LIKE '%@example.com';
SELECT name FROM products WHERE name ILIKE '%notebook%';  -- case-insensitive
```

`LIKE` is case-sensitive in Postgres; `ILIKE` is not. **`ILIKE` is Postgres-specific** (standard SQL has `LIKE` only — other DBs differ). Leading `%` prevents a plain B-tree index from helping (Module 7 / `pg_trgm` later).

## Combining — always parenthesize mixed AND/OR

`AND` binds tighter than `OR`. Without parentheses, this is **wrong** for “Laptops/Displays in stock matching notebook *or* mouse”:

```sql
-- BAD: parses as
-- (category IN (...) AND stock_qty > 0 AND name ILIKE '%notebook%')
-- OR name ILIKE '%mouse%'
-- → Wireless Mouse (Peripherals) sneaks in!
SELECT name, category
FROM products
WHERE category IN ('Laptops', 'Displays')
  AND stock_qty > 0
  AND name ILIKE '%notebook%' OR name ILIKE '%mouse%';
```

Correct:

```sql
SELECT name, category
FROM products
WHERE category IN ('Laptops', 'Displays')
  AND stock_qty > 0
  AND (name ILIKE '%notebook%' OR name ILIKE '%mouse%');
```

## Takeaway

`IN`, `BETWEEN`, `LIKE`/`ILIKE` cover most filters. Parenthesize mixed `AND`/`OR`. Prefer `ILIKE` for user search boxes in Postgres unless you need case-sensitive match.
