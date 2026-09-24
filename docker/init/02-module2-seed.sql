-- Module 2: related tables for multi-table joins.
-- Safe to re-run (IF NOT EXISTS / guarded inserts).

CREATE TABLE IF NOT EXISTS orders (
  id           SERIAL PRIMARY KEY,
  employee_id  INTEGER NOT NULL REFERENCES employees (id),
  product_id   INTEGER NOT NULL REFERENCES products (id),
  quantity     INTEGER NOT NULL CHECK (quantity > 0),
  ordered_on   DATE    NOT NULL,
  status       TEXT    NOT NULL CHECK (status IN ('pending', 'shipped', 'cancelled'))
);

CREATE TABLE IF NOT EXISTS departments_budget (
  department TEXT PRIMARY KEY,
  budget     NUMERIC(12, 2) NOT NULL CHECK (budget > 0)
);

INSERT INTO departments_budget (department, budget)
VALUES
  ('Engineering', 900000),
  ('Product',     420000),
  ('Sales',       510000),
  ('HR',          120000),
  ('Marketing',   200000)   -- no employees yet — useful for outer joins
ON CONFLICT (department) DO NOTHING;

INSERT INTO orders (employee_id, product_id, quantity, ordered_on, status)
SELECT * FROM (VALUES
  (8,  1, 2, DATE '2024-01-10', 'shipped'),
  (8,  4, 5, DATE '2024-01-12', 'shipped'),
  (9,  2, 1, DATE '2024-02-03', 'shipped'),
  (9,  6, 2, DATE '2024-02-15', 'pending'),
  (10, 5, 10, DATE '2024-03-01', 'shipped'),
  (10, 8, 1, DATE '2024-03-04', 'cancelled'),
  (14, 3, 1, DATE '2024-03-20', 'pending'),
  (2,  13, 4, DATE '2024-04-01', 'shipped'),
  (3,  7, 1, DATE '2024-04-11', 'shipped'),
  (4,  11, 2, DATE '2024-04-18', 'pending'),
  (15, 12, 1, DATE '2024-05-02', 'shipped'),
  (8,  14, 3, DATE '2024-05-09', 'shipped')
) AS v(employee_id, product_id, quantity, ordered_on, status)
WHERE NOT EXISTS (SELECT 1 FROM orders LIMIT 1);
