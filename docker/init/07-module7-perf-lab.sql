-- Module 7: performance lab — enough rows for planner choices to matter.
-- Safe to re-run: drops and recreates schema perf_lab.

DROP SCHEMA IF EXISTS perf_lab CASCADE;

CREATE SCHEMA perf_lab;

CREATE TABLE perf_lab.users (
  id          SERIAL PRIMARY KEY,
  email       TEXT        NOT NULL UNIQUE,
  country     TEXT        NOT NULL,
  is_active   BOOLEAN     NOT NULL DEFAULT TRUE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE perf_lab.orders (
  id           BIGSERIAL PRIMARY KEY,
  user_id      INTEGER        NOT NULL REFERENCES perf_lab.users (id),
  status       TEXT           NOT NULL,
  total        NUMERIC(12, 2) NOT NULL CHECK (total >= 0),
  created_at   TIMESTAMPTZ    NOT NULL,
  note         TEXT
);

-- 5_000 users
INSERT INTO perf_lab.users (email, country, is_active, created_at)
SELECT
  'user' || g || '@example.com',
  (ARRAY['US', 'IN', 'DE', 'BR', 'JP'])[1 + (g % 5)],
  (g % 10) <> 0,  -- ~90% active
  TIMESTAMPTZ '2023-01-01' + ((g % 700) || ' days')::interval
FROM generate_series(1, 5000) AS g;

-- 50_000 orders (~10 per user on average)
INSERT INTO perf_lab.orders (user_id, status, total, created_at, note)
SELECT
  1 + ((g - 1) % 5000),
  (ARRAY['pending', 'paid', 'shipped', 'cancelled'])[1 + (g % 4)],
  round((random() * 200 + 5)::numeric, 2),
  TIMESTAMPTZ '2023-01-01' + ((g % 800) || ' days')::interval
    + ((g % 86400) || ' seconds')::interval,
  CASE WHEN g % 20 = 0 THEN 'vip' ELSE NULL END
FROM generate_series(1, 50000) AS g;

ANALYZE perf_lab.users;
ANALYZE perf_lab.orders;

-- Intentionally NO secondary indexes on orders yet (except PK / FK none).
-- Exercises add indexes; reset drops them with the schema.
