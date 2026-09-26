-- Module 11: ops lab — tiny schema to practice dump / restore.
-- Safe to re-run: drops and recreates schema ops_lab.

DROP SCHEMA IF EXISTS ops_lab CASCADE;

CREATE SCHEMA ops_lab;

CREATE TABLE ops_lab.widgets (
  id         SERIAL PRIMARY KEY,
  name       TEXT        NOT NULL UNIQUE,
  qty        INTEGER     NOT NULL DEFAULT 0 CHECK (qty >= 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

INSERT INTO ops_lab.widgets (name, qty) VALUES
  ('alpha', 3),
  ('beta',  7),
  ('gamma', 1);
