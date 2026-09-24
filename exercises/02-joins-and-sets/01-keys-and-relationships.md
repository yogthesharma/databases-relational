# Exercise: Keys and relationships

Read: `notes/02-joins-and-sets/01-keys-and-relationships.md`

Apply seed first if needed (see module exercises README).

## Tasks

1. In `psql`, describe `orders` (`\d orders`). List its foreign keys and what they reference.
2. What relationship shape is `orders.employee_id` → `employees.id`? (1:1, 1:N, M:N?)
3. What shape is `employees.manager_id` → `employees.id`?
4. Why does `departments_budget` include **Marketing** even though no employee has that department?
5. Predict: will this insert succeed or fail? Why? (Don’t leave it in the DB if you try it — `ROLLBACK`.)

```sql
BEGIN;
INSERT INTO orders (employee_id, product_id, quantity, ordered_on, status)
VALUES (1, 999, 1, CURRENT_DATE, 'pending');
ROLLBACK;
```

---

## Solutions

1. `employee_id` → `employees(id)`; `product_id` → `products(id)`.
2. **1:N** — one employee, many orders.
3. **Self 1:N** — one manager, many reports (optional manager).
4. So you can practice **outer joins** (department with budget but no people).
5. **Fails** — `product_id = 999` violates FK to `products` (unless 999 exists, which it doesn’t).
