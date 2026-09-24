# Keys and relationships

## Why joins exist

In Module 1 you queried one table. Real apps split data across tables and **link them with keys**. A join is how SQL answers questions that span those tables in one round-trip — the alternative in Node is N+1 queries (`find employee`, then `find each order`).

## Primary key (PK)

Uniquely identifies a row. Ours: `employees.id`, `products.id`, `orders.id`.

## Foreign key (FK)

A column that **must match** a PK (or unique key) in another table (or the same table).

| FK | Points at | Meaning |
|----|-----------|---------|
| `employees.manager_id` | `employees.id` | Self-relationship (org chart) |
| `orders.employee_id` | `employees.id` | Who placed the order |
| `orders.product_id` | `products.id` | What was ordered |

There is **no FK** from `employees.department` → `departments_budget.department`. That join is a **text match** for teaching outer joins. Real apps usually use a `department_id` FK instead.

Postgres enforces declared FKs: you cannot insert an order for `employee_id = 999` if that employee doesn’t exist.

## Relationship shapes

| Shape | Example here |
|-------|----------------|
| **1:N** | One employee → many orders |
| **1:1** | (none in seed; e.g. employee ↔ profile) |
| **M:N** | (none yet; would need a bridge table) |
| **Self** | Employee → manager (same table) |

## Referential integrity

The DB refuses orphan FKs. That’s a feature: your Node validation can miss edge cases; constraints don’t.

```sql
-- Fails: no employee 999
-- INSERT INTO orders (employee_id, product_id, quantity, ordered_on, status)
-- VALUES (999, 1, 1, CURRENT_DATE, 'pending');
```

## Inspect in psql

```text
\d employees
\d orders
```

Look for `Foreign-key constraints`.

## Node angle

ORMs model this as relations (`orders.employee`, Prisma `include`). Under the hood it’s still joins (or extra queries). Knowing keys lets you spot missing indexes and accidental cartesian products later.

## Takeaway

PKs identify rows; FKs declare relationships; joins follow those links. Integrity belongs in the database, not only in Express middleware.
