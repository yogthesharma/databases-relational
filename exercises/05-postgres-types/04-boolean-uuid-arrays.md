# Exercise: Boolean, UUID, arrays

Read: `notes/05-postgres-types/04-boolean-uuid-arrays.md`

## Tasks

1. Select only active products using a boolean predicate (no `= TRUE` required).
2. What type is `customers.id`? Insert a customer **without** supplying `id` and confirm one was generated.
3. Find products tagged `usb` (`ANY` or `@>`).
4. When would you replace `tags TEXT[]` with a `product_tags` bridge table?
5. Soft-deactivate `TP-002` (`is_active = false`) and show active products only.

## Stretch

Return `sku` and the first array element of `tags`.

---

## Solutions

1.

```sql
SELECT sku, name FROM types_lab.products WHERE is_active;
```

2. `UUID`. 

```sql
INSERT INTO types_lab.customers (email, full_name)
VALUES ('maya@example.com', 'Maya Ibrahim')
RETURNING id, email;
```

3.

```sql
SELECT sku, tags FROM types_lab.products WHERE 'usb' = ANY (tags);
-- or: WHERE tags @> ARRAY['usb'];
```

4. When tags need metadata, FKs, popularity queries, or many-to-many reuse across entities.
5.

```sql
UPDATE types_lab.products SET is_active = FALSE WHERE sku = 'TP-002';
SELECT sku FROM types_lab.products WHERE is_active;
```

Stretch:

```sql
SELECT sku, tags[1] AS first_tag FROM types_lab.products;
```
