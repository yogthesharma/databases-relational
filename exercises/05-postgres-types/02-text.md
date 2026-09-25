# Exercise: Text & collations

Read: `notes/05-postgres-types/02-text.md`

## Tasks

1. Prefer `TEXT` or `VARCHAR(255)` for `products.name` in Postgres, and why?
2. Find products whose name contains `lamp` case-insensitively.
3. Match SKUs `TP-001` through `TP-003` with a regex.
4. When is `VARCHAR(n)` actually useful?
5. Does `'a' = 'A'` under default comparison? How do you compare case-insensitively?

## Stretch

Order product names with `COLLATE "C"` and glance at the order — what does `"C"` mean roughly?

---

## Solutions

1. **`TEXT`** — same speed; no arbitrary 255 cap unless you want one.
2.

```sql
SELECT * FROM types_lab.products WHERE name ILIKE '%lamp%';
```

3.

```sql
SELECT * FROM types_lab.products WHERE sku ~ '^TP-00[1-3]$';
```

4. When the length limit is a **real** business rule enforced in the DB.
5. `'a' = 'A'` is false; use `ILIKE`, `LOWER(a) = LOWER(b)`, or a case-insensitive collation.

Stretch: `"C"` is the POSIX/`memcmp`-style collation (byte order) — useful for predictable machine sorts, not linguistic ones.
