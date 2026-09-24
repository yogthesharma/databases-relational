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

`LIKE` is case-sensitive in Postgres; `ILIKE` is not. Leading `%` prevents a plain B-tree index from helping (Module 7 / `pg_trgm` later).

## Combining

```sql
SELECT sku, name, category, stock_qty
FROM products
WHERE category IN ('Laptops', 'Displays')
  AND stock_qty > 0
  AND name ILIKE '%monitor%' OR name ILIKE '%notebook%';  -- careful with AND/OR precedence!
```

Use parentheses:

```sql
WHERE category IN ('Laptops', 'Displays')
  AND stock_qty > 0
  AND (name ILIKE '%monitor%' OR name ILIKE '%notebook%')
```

## Takeaway

`IN`, `BETWEEN`, `LIKE`/`ILIKE` cover most filters. Parenthesize mixed `AND`/`OR`. Prefer `ILIKE` for user search boxes unless you need case-sensitive match.
