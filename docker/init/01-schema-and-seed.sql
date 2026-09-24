-- Learning schema for Modules 0–1 (and later).
-- Loaded automatically on first `docker compose up` (empty volume only).

CREATE TABLE employees (
  id          SERIAL PRIMARY KEY,
  first_name  TEXT        NOT NULL,
  last_name   TEXT        NOT NULL,
  email       TEXT        UNIQUE NOT NULL,
  department  TEXT        NOT NULL,
  job_title   TEXT        NOT NULL,
  salary      NUMERIC(10, 2) NOT NULL CHECK (salary > 0),
  hired_on    DATE        NOT NULL,
  is_active   BOOLEAN     NOT NULL DEFAULT TRUE,
  manager_id  INTEGER     REFERENCES employees (id)
);

CREATE TABLE products (
  id            SERIAL PRIMARY KEY,
  sku           TEXT           UNIQUE NOT NULL,
  name          TEXT           NOT NULL,
  category      TEXT           NOT NULL,
  price         NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
  stock_qty     INTEGER        NOT NULL DEFAULT 0 CHECK (stock_qty >= 0),
  is_discontinued BOOLEAN      NOT NULL DEFAULT FALSE,
  created_at    TIMESTAMPTZ    NOT NULL DEFAULT NOW()
);

INSERT INTO employees
  (first_name, last_name, email, department, job_title, salary, hired_on, is_active, manager_id)
VALUES
  ('Asha',   'Patel',   'asha.patel@example.com',   'Engineering', 'Engineering Manager', 145000, '2019-03-12', TRUE,  NULL),
  ('Ben',    'Okoye',   'ben.okoye@example.com',    'Engineering', 'Senior Backend',      128000, '2020-07-01', TRUE,  1),
  ('Chen',   'Wu',      'chen.wu@example.com',      'Engineering', 'Full Stack',           112000, '2021-01-18', TRUE,  1),
  ('Deepa',  'Singh',   'deepa.singh@example.com',  'Engineering', 'Frontend',             98000,  '2022-05-09', TRUE,  1),
  ('Elena',  'Rossi',   'elena.rossi@example.com',  'Product',     'Product Manager',      132000, '2018-11-20', TRUE,  NULL),
  ('Farid',  'Hassan',  'farid.hassan@example.com', 'Product',     'Product Designer',     105000, '2021-09-14', TRUE,  5),
  ('Grace',  'Kim',     'grace.kim@example.com',    'Product',     'Product Analyst',      92000,  '2023-02-27', TRUE,  5),
  ('Hugo',   'Martinez','hugo.martinez@example.com','Sales',       'Sales Lead',           110000, '2017-06-03', TRUE,  NULL),
  ('Imani',  'Diallo',  'imani.diallo@example.com', 'Sales',       'Account Executive',    88000,  '2022-10-11', TRUE,  8),
  ('Jules',  'Nguyen',  'jules.nguyen@example.com', 'Sales',       'Account Executive',    86000,  '2023-04-02', TRUE,  8),
  ('Kai',    'Berg',    'kai.berg@example.com',     'Engineering', 'DevOps',               118000, '2020-12-01', FALSE, 1),
  ('Lina',   'Costa',   'lina.costa@example.com',   'HR',          'People Partner',       78000,  '2021-08-16', TRUE,  NULL),
  ('Maya',   'Ibrahim', 'maya.ibrahim@example.com', 'Engineering', 'Intern',               45000,  '2024-06-01', TRUE,  2),
  ('Noah',   'Silva',   'noah.silva@example.com',   'Sales',       'SDR',                  62000,  '2024-01-15', TRUE,  8),
  ('Omar',   'Khan',    'omar.khan@example.com',    'Engineering', 'Backend',              108000, '2022-03-21', TRUE,  1);

INSERT INTO products (sku, name, category, price, stock_qty, is_discontinued) VALUES
  ('NB-14',  'Notebook 14"',        'Laptops',    899.00,  24, FALSE),
  ('NB-16',  'Notebook 16"',        'Laptops',   1299.00,  12, FALSE),
  ('MB-AIR', 'Ultrabook Air',       'Laptops',   1499.00,   8, FALSE),
  ('KB-MEC', 'Mechanical Keyboard', 'Peripherals',129.00,  80, FALSE),
  ('MS-WL',  'Wireless Mouse',      'Peripherals', 49.00, 150, FALSE),
  ('HD-27',  'Monitor 27"',         'Displays',   349.00,  35, FALSE),
  ('HD-32',  'Monitor 32"',         'Displays',   499.00,  18, FALSE),
  ('USB-C',  'USB-C Hub',           'Peripherals', 79.00,   0, FALSE),
  ('BAG-15', 'Laptop Bag 15"',      'Accessories', 59.00,  60, FALSE),
  ('OLD-13', 'Notebook 13" Legacy', 'Laptops',    699.00,   3, TRUE),
  ('CAM-HD', 'Webcam HD',           'Peripherals', 89.00,  40, FALSE),
  ('DOCK',   'Thunderbolt Dock',    'Peripherals',249.00,  15, FALSE),
  ('SSD-1T', 'SSD 1TB',             'Storage',    119.00,  55, FALSE),
  ('SSD-2T', 'SSD 2TB',             'Storage',    199.00,  22, FALSE),
  ('NULL-T', 'Clearance Cable',     'Accessories',  0.00, 200, TRUE);
