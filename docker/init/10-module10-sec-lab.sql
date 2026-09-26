-- Module 10: security lab — app schema + least-privilege roles.
-- Safe to re-run: drops schema and recreates grants on lab roles.

DROP SCHEMA IF EXISTS sec_lab CASCADE;

-- Lab roles (NOLOGIN: use SET ROLE from postgres while learning)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'sec_app') THEN
    CREATE ROLE sec_app NOLOGIN;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'sec_readonly') THEN
    CREATE ROLE sec_readonly NOLOGIN;
  END IF;
END $$;

-- Clear prior grants on these roles (objects may be gone already)
REVOKE ALL ON DATABASE learn FROM sec_app, sec_readonly;
REVOKE ALL ON SCHEMA public FROM sec_app, sec_readonly;

CREATE SCHEMA sec_lab AUTHORIZATION postgres;

CREATE TABLE sec_lab.customers (
  id         SERIAL PRIMARY KEY,
  email      TEXT NOT NULL UNIQUE,
  full_name  TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE sec_lab.orders (
  id           SERIAL PRIMARY KEY,
  customer_id  INTEGER        NOT NULL REFERENCES sec_lab.customers (id),
  total        NUMERIC(12, 2) NOT NULL CHECK (total >= 0),
  status       TEXT           NOT NULL DEFAULT 'pending',
  created_at   TIMESTAMPTZ    NOT NULL DEFAULT now()
);

INSERT INTO sec_lab.customers (email, full_name) VALUES
  ('asha@example.com', 'Asha Patel'),
  ('ben@example.com',  'Ben Okoye');

INSERT INTO sec_lab.orders (customer_id, total, status) VALUES
  (1, 42.50, 'paid'),
  (1, 10.00, 'pending'),
  (2, 99.00, 'paid');

-- Schema access
GRANT USAGE ON SCHEMA sec_lab TO sec_app, sec_readonly;

-- App role: DML only (no DDL)
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA sec_lab TO sec_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA sec_lab TO sec_app;

-- Readonly role: SELECT only
GRANT SELECT ON ALL TABLES IN SCHEMA sec_lab TO sec_readonly;

-- Future tables in this schema (for this learning DB session owner)
ALTER DEFAULT PRIVILEGES IN SCHEMA sec_lab
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO sec_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA sec_lab
  GRANT USAGE, SELECT ON SEQUENCES TO sec_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA sec_lab
  GRANT SELECT ON TABLES TO sec_readonly;

-- Explicitly no rights on other course schemas (if present)
DO $$
DECLARE s text;
BEGIN
  FOREACH s IN ARRAY ARRAY[
    'write_lab', 'design_lab', 'types_lab', 'tx_lab',
    'perf_lab', 'adv_lab', 'feat_lab'
  ]
  LOOP
    IF EXISTS (SELECT 1 FROM pg_namespace WHERE nspname = s) THEN
      EXECUTE format('REVOKE ALL ON SCHEMA %I FROM sec_app, sec_readonly', s);
    END IF;
  END LOOP;
END $$;
