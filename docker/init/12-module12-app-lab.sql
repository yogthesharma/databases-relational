-- Module 12: app lab — accounts for a tiny transactional transfer demo.
-- Safe to re-run: drops and recreates schema app_lab.

DROP SCHEMA IF EXISTS app_lab CASCADE;

CREATE SCHEMA app_lab;

CREATE TABLE app_lab.accounts (
  id       SERIAL PRIMARY KEY,
  name     TEXT           NOT NULL UNIQUE,
  balance  NUMERIC(12, 2) NOT NULL CHECK (balance >= 0)
);

INSERT INTO app_lab.accounts (name, balance) VALUES
  ('alice', 100.00),
  ('bob',    50.00);
