-- Module 5: types lab — sample catalog + orders using Postgres types.
-- Safe to re-run: drops and recreates schema types_lab.

DROP SCHEMA IF EXISTS types_lab CASCADE;

CREATE SCHEMA types_lab;

CREATE DOMAIN types_lab.money_amount AS NUMERIC(12, 2)
  CHECK (VALUE >= 0);

CREATE TYPE types_lab.order_status AS ENUM (
  'pending',
  'paid',
  'shipped',
  'cancelled'
);

CREATE TABLE types_lab.products (
  id          SERIAL PRIMARY KEY,
  sku         TEXT NOT NULL UNIQUE,
  name        TEXT NOT NULL,
  price       types_lab.money_amount NOT NULL,
  weight_kg   DOUBLE PRECISION,
  tags        TEXT[] NOT NULL DEFAULT '{}',
  attrs       JSONB NOT NULL DEFAULT '{}',
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE types_lab.customers (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email       TEXT NOT NULL UNIQUE,
  full_name   TEXT NOT NULL,
  signup_ip   INET,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE types_lab.orders (
  id            SERIAL PRIMARY KEY,
  customer_id   UUID NOT NULL REFERENCES types_lab.customers (id),
  status        types_lab.order_status NOT NULL DEFAULT 'pending',
  total         types_lab.money_amount NOT NULL,
  placed_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  ship_window   TSTZRANGE
);

INSERT INTO types_lab.products (sku, name, price, weight_kg, tags, attrs) VALUES
  ('TP-001', 'USB-C Cable',     9.99,  0.05, ARRAY['cable', 'usb'], '{"color":"black","warranty_months":12}'::jsonb),
  ('TP-002', 'Notebook Pack',   4.50,  0.30, ARRAY['paper'],        '{"pages":200}'::jsonb),
  ('TP-003', 'Desk Lamp',      29.00,  1.20, ARRAY['desk','led'],   '{"color":"white","dimmable":true}'::jsonb),
  ('TP-004', 'Travel Adapter', 19.95,  0.15, ARRAY['travel','usb'], '{"regions":["US","EU","UK"]}'::jsonb);

INSERT INTO types_lab.customers (email, full_name, signup_ip, created_at) VALUES
  ('asha@example.com',  'Asha Patel',   '203.0.113.10', '2024-01-05 10:00:00+00'),
  ('deepa@example.com', 'Deepa Singh',  '198.51.100.22','2024-02-12 14:30:00+00'),
  ('hugo@example.com',  'Hugo Martin',  '2001:db8::1',  '2024-03-01 09:15:00+00');

INSERT INTO types_lab.orders (customer_id, status, total, placed_at, ship_window)
SELECT c.id, 'paid'::types_lab.order_status, 14.49,
       '2024-03-10 16:00:00+00',
       tstzrange('2024-03-12 00:00:00+00', '2024-03-15 00:00:00+00', '[)')
FROM types_lab.customers c WHERE c.email = 'asha@example.com';

INSERT INTO types_lab.orders (customer_id, status, total, placed_at, ship_window)
SELECT c.id, 'shipped'::types_lab.order_status, 29.00,
       '2024-03-11 11:00:00+00',
       tstzrange('2024-03-12 08:00:00+00', '2024-03-13 18:00:00+00', '[)')
FROM types_lab.customers c WHERE c.email = 'deepa@example.com';

INSERT INTO types_lab.orders (customer_id, status, total, placed_at)
SELECT c.id, 'pending'::types_lab.order_status, 19.95,
       '2024-03-14 08:45:00+00'
FROM types_lab.customers c WHERE c.email = 'hugo@example.com';
