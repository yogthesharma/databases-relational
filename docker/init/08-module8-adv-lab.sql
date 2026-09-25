-- Module 8: advanced SQL lab — org tree + sales for windows / recursion / LATERAL.
-- Safe to re-run: drops and recreates schema adv_lab.

DROP SCHEMA IF EXISTS adv_lab CASCADE;

CREATE SCHEMA adv_lab;

CREATE TABLE adv_lab.employees (
  id          SERIAL PRIMARY KEY,
  name        TEXT    NOT NULL,
  manager_id  INTEGER REFERENCES adv_lab.employees (id),
  department  TEXT    NOT NULL
);

CREATE TABLE adv_lab.sales (
  id           SERIAL PRIMARY KEY,
  employee_id  INTEGER        NOT NULL REFERENCES adv_lab.employees (id),
  region       TEXT           NOT NULL,
  sold_on      DATE           NOT NULL,
  amount       NUMERIC(12, 2) NOT NULL CHECK (amount > 0)
);

-- Org chart (CEO → VPs → ICs)
INSERT INTO adv_lab.employees (id, name, manager_id, department) VALUES
  (1, 'Asha',  NULL, 'Exec'),
  (2, 'Ben',   1,    'Eng'),
  (3, 'Chen',  1,    'Sales'),
  (4, 'Deepa', 2,    'Eng'),
  (5, 'Hugo',  2,    'Eng'),
  (6, 'Lina',  3,    'Sales'),
  (7, 'Maya',  3,    'Sales'),
  (8, 'Omar',  4,    'Eng');

SELECT setval(pg_get_serial_sequence('adv_lab.employees', 'id'), (SELECT max(id) FROM adv_lab.employees));

INSERT INTO adv_lab.sales (employee_id, region, sold_on, amount) VALUES
  (6, 'West', '2024-01-05', 120.00),
  (6, 'West', '2024-01-12',  80.00),
  (6, 'East', '2024-01-20', 200.00),
  (7, 'West', '2024-01-08', 150.00),
  (7, 'West', '2024-01-18',  90.00),
  (7, 'East', '2024-02-01', 110.00),
  (3, 'East', '2024-01-15', 300.00),
  (3, 'West', '2024-02-05', 250.00),
  (4, 'West', '2024-01-10',  40.00),
  (4, 'West', '2024-02-02',  55.00),
  (5, 'East', '2024-01-22',  70.00),
  (5, 'East', '2024-02-08',  65.00),
  (8, 'West', '2024-01-25',  30.00),
  (8, 'East', '2024-02-10',  45.00),
  (6, 'West', '2024-02-12', 175.00),
  (7, 'East', '2024-02-14', 220.00),
  (3, 'East', '2024-02-20', 180.00),
  (4, 'East', '2024-02-22',  95.00),
  (5, 'West', '2024-02-25',  60.00),
  (8, 'West', '2024-02-28',  50.00);
