#!/usr/bin/env bash
# 07 — Checkpoint: dump → drop → restore → verify
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DUMP="${TMPDIR:-/tmp}/ops_lab.checkpoint.dump.sql"

cd "$ROOT"
docker compose exec -T postgres psql -U postgres -d learn < docker/init/11-module11-ops-lab.sql
docker compose exec -T postgres pg_dump -U postgres -d learn -n ops_lab > "$DUMP"
docker compose exec -T postgres psql -U postgres -d learn -c 'DROP SCHEMA ops_lab CASCADE;'
docker compose exec -T postgres psql -U postgres -d learn < "$DUMP"
docker compose exec -T postgres psql -U postgres -d learn -c \
  "SELECT name, qty FROM ops_lab.widgets ORDER BY name;"
echo "OK — ops_lab restored from $DUMP"
