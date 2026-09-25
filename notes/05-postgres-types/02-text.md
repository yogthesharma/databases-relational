# Text and collations

## `TEXT` vs `VARCHAR(n)`

In Postgres, `TEXT` and `VARCHAR` (without length) are the same performance-wise. Prefer:

| Choice | When |
|--------|------|
| `TEXT` | Default for strings |
| `VARCHAR(n)` | Only if you **want** a hard length limit as a constraint |
| `CHAR(n)` | Almost never — pads with spaces |

Length limits for UX (“username ≤ 32”) are often better as `CHECK (char_length(name) <= 32)` on `TEXT`, or validated in the app **and** DB.

## Operators you’ll use constantly

```sql
SELECT * FROM types_lab.products WHERE name ILIKE '%lamp%';  -- case-insensitive
SELECT * FROM types_lab.products WHERE sku ~ '^TP-00[1-3]$'; -- regex
```

## Collations (basics)

A **collation** decides sort/compare rules (case, accents, locale).

```sql
SELECT 'a' = 'A';                    -- false under typical default collations (case-sensitive)
SELECT 'a' ILIKE 'A';                 -- true (ILIKE ignores case)

SELECT name FROM types_lab.products ORDER BY name COLLATE "C";
```

This DB’s collation is often `en_US.utf8` (not `"C"`). Equality is still case-sensitive unless you use `ILIKE`, `LOWER()`, or a CI collation. Most apps keep the DB default and reach for `ILIKE` / `LOWER()` when needed — changing DB collation later is painful.

## Takeaway

Default to `TEXT`. Use length limits as real constraints, not cargo-cult `VARCHAR(255)`. Know `ILIKE` vs collation for case.
