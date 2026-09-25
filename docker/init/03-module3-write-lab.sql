-- Module 3: isolated write lab (does not replace employees/products/orders).
-- Safe to re-run: drops and recreates schema write_lab.

DROP SCHEMA IF EXISTS write_lab CASCADE;

CREATE SCHEMA write_lab;

CREATE TABLE write_lab.tags (
  id   SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE write_lab.items (
  id          SERIAL PRIMARY KEY,
  sku         TEXT           NOT NULL UNIQUE,
  title       TEXT           NOT NULL,
  price       NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
  stock       INTEGER        NOT NULL DEFAULT 0 CHECK (stock >= 0),
  tag_id      INTEGER        REFERENCES write_lab.tags (id) ON DELETE SET NULL,
  is_active   BOOLEAN        NOT NULL DEFAULT TRUE,
  created_at  TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ,
  price_cents INTEGER        GENERATED ALWAYS AS ((price * 100)::integer) STORED
);

CREATE TABLE write_lab.item_notes (
  id      SERIAL PRIMARY KEY,
  item_id INTEGER NOT NULL REFERENCES write_lab.items (id) ON DELETE CASCADE,
  body    TEXT    NOT NULL
);

INSERT INTO write_lab.tags (name) VALUES
  ('electronics'),
  ('office'),
  ('clearance');

INSERT INTO write_lab.items (sku, title, price, stock, tag_id) VALUES
  ('WL-001', 'USB Cable',     9.99,  40, 1),
  ('WL-002', 'Notebook Pack', 4.50, 100, 2),
  ('WL-003', 'Desk Lamp',    29.00,  15, 2),
  ('WL-004', 'Old Mouse',     5.00,   3, 3);

INSERT INTO write_lab.item_notes (item_id, body) VALUES
  (1, 'Ships in 2 days'),
  (1, 'Also sold in black'),
  (3, 'LED bulb included');
