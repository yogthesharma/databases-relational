# Exercise: Enums & domains

Read: `notes/05-postgres-types/05-enums-and-domains.md`

## Tasks

1. List all allowed `order_status` values (`enum_range`).
2. Select orders with status `shipped`.
3. Try inserting an order with status `'refunded'` — what happens?
4. What domain backs `products.price`? Try `price = -0.01` on an update.
5. Enum vs lookup table: when would you store order status as a table instead?

## Stretch

Add a new enum value `refunded` with `ALTER TYPE ... ADD VALUE` (then reset the lab when done).

---

## Solutions

1.

```sql
SELECT enum_range(NULL::types_lab.order_status);
```

2.

```sql
SELECT id, status, total FROM types_lab.orders WHERE status = 'shipped';
```

3. Error — invalid input value for enum.
4. `types_lab.money_amount`. Update fails CHECK on the domain.

```sql
UPDATE types_lab.products SET price = -0.01 WHERE sku = 'TP-001';
```

5. When statuses need labels, sort order, permissions, or change often without migrations.

Stretch:

```sql
ALTER TYPE types_lab.order_status ADD VALUE 'refunded';
-- Reset lab afterward to undo.
```
