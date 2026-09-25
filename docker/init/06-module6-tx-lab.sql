-- Module 6: transaction / concurrency lab.
-- Safe to re-run: drops and recreates schema tx_lab.

DROP SCHEMA IF EXISTS tx_lab CASCADE;

CREATE SCHEMA tx_lab;

CREATE TABLE tx_lab.accounts (
  id       SERIAL PRIMARY KEY,
  name     TEXT            NOT NULL UNIQUE,
  balance  NUMERIC(12, 2)  NOT NULL CHECK (balance >= 0)
);

CREATE TABLE tx_lab.transfers (
  id               SERIAL PRIMARY KEY,
  from_account_id  INTEGER        NOT NULL REFERENCES tx_lab.accounts (id),
  to_account_id    INTEGER        NOT NULL REFERENCES tx_lab.accounts (id),
  amount           NUMERIC(12, 2) NOT NULL CHECK (amount > 0),
  idempotency_key  TEXT           UNIQUE,
  created_at       TIMESTAMPTZ    NOT NULL DEFAULT now(),
  CHECK (from_account_id <> to_account_id)
);

CREATE TABLE tx_lab.products (
  id     SERIAL PRIMARY KEY,
  sku    TEXT    NOT NULL UNIQUE,
  stock  INTEGER NOT NULL CHECK (stock >= 0)
);

INSERT INTO tx_lab.accounts (name, balance) VALUES
  ('alice', 100.00),
  ('bob',    50.00),
  ('carol',  25.00);

INSERT INTO tx_lab.products (sku, stock) VALUES
  ('WIDGET', 10),
  ('GADGET',  3);
