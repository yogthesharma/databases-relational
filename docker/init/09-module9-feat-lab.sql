-- Module 9: product features lab — JSONB, FTS, views, triggers, RLS sandbox.
-- Safe to re-run: drops and recreates schema feat_lab.

DROP SCHEMA IF EXISTS feat_lab CASCADE;

CREATE SCHEMA feat_lab;

CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE feat_lab.articles (
  id             SERIAL PRIMARY KEY,
  slug           TEXT        NOT NULL UNIQUE,
  title          TEXT        NOT NULL,
  body           TEXT        NOT NULL,
  attrs          JSONB       NOT NULL DEFAULT '{}'::jsonb,
  search_vector  tsvector,
  is_published   BOOLEAN     NOT NULL DEFAULT FALSE,
  author_key     TEXT        NOT NULL DEFAULT 'public',
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at     TIMESTAMPTZ
);

CREATE INDEX articles_attrs_gin ON feat_lab.articles USING gin (attrs);
CREATE INDEX articles_search_gin ON feat_lab.articles USING gin (search_vector);
CREATE INDEX articles_title_trgm ON feat_lab.articles USING gin (title gin_trgm_ops);

CREATE OR REPLACE FUNCTION feat_lab.articles_search_trigger()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.search_vector :=
    setweight(to_tsvector('english', coalesce(NEW.title, '')), 'A') ||
    setweight(to_tsvector('english', coalesce(NEW.body, '')), 'B');
  NEW.updated_at := now();
  RETURN NEW;
END;
$$;

CREATE TRIGGER articles_search_vector_tg
  BEFORE INSERT OR UPDATE OF title, body ON feat_lab.articles
  FOR EACH ROW
  EXECUTE FUNCTION feat_lab.articles_search_trigger();

INSERT INTO feat_lab.articles (slug, title, body, attrs, is_published, author_key) VALUES
  ('postgres-jsonb', 'Postgres JSONB tips',
   'Learn JSONB operators containment and GIN indexes for product catalogs.',
   '{"tags":["postgres","jsonb"],"level":"intermediate","likes":12}'::jsonb,
   TRUE, 'asha'),
  ('full-text-search', 'Full-text search in Postgres',
   'Use tsvector and tsquery with ranking for blog search without Elasticsearch.',
   '{"tags":["postgres","fts","search"],"level":"advanced","likes":20}'::jsonb,
   TRUE, 'ben'),
  ('views-matviews', 'Views and materialized views',
   'Views are stored queries; materialized views store results you REFRESH.',
   '{"tags":["postgres","views"],"level":"beginner","likes":8}'::jsonb,
   TRUE, 'asha'),
  ('draft-rls', 'Draft: row level security notes',
   'RLS policies filter which rows each role can see.',
   '{"tags":["security","rls"],"level":"advanced","likes":0}'::jsonb,
   FALSE, 'chen');

-- Trigger fills search_vector + updated_at on INSERT/UPDATE of title/body.
CREATE OR REPLACE VIEW feat_lab.published_articles AS
SELECT id, slug, title, attrs, created_at
FROM feat_lab.articles
WHERE is_published;

-- Tag popularity (materialized)
CREATE MATERIALIZED VIEW feat_lab.tag_stats AS
SELECT tag, count(*) AS article_count
FROM feat_lab.articles a
CROSS JOIN LATERAL jsonb_array_elements_text(a.attrs->'tags') AS tag
WHERE a.is_published
GROUP BY tag;

CREATE UNIQUE INDEX tag_stats_tag_uidx ON feat_lab.tag_stats (tag);

-- Simple SQL function
CREATE OR REPLACE FUNCTION feat_lab.article_likes(p_id INTEGER)
RETURNS INTEGER
LANGUAGE sql
STABLE
AS $$
  SELECT coalesce((attrs->>'likes')::integer, 0)
  FROM feat_lab.articles
  WHERE id = p_id;
$$;

-- RLS sandbox (policies use session setting app.user_key)
ALTER TABLE feat_lab.articles ENABLE ROW LEVEL SECURITY;

CREATE POLICY articles_select_published_or_own ON feat_lab.articles
  FOR SELECT
  USING (
    is_published
    OR author_key = current_setting('app.user_key', true)
  );

-- Table owner bypasses RLS by default; exercises use SET ROLE / FORCE as needed.
-- Keep a note role for demos:
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'feat_reader') THEN
    CREATE ROLE feat_reader NOLOGIN;
  END IF;
END $$;

GRANT USAGE ON SCHEMA feat_lab TO feat_reader;
GRANT SELECT ON feat_lab.articles TO feat_reader;
GRANT SELECT ON feat_lab.published_articles TO feat_reader;
GRANT SELECT ON feat_lab.tag_stats TO feat_reader;

-- Owner uses FORCE RLS in exercises when demonstrating policies on self.
