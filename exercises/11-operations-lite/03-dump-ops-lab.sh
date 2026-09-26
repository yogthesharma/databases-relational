#!/usr/bin/env bash
# 03 — Dump ops_lab to a SQL file
set -euo pipefail
OUT="${1:-/tmp/ops_lab.dump.sql}"
docker compose exec -T postgres pg_dump -U postgres -d learn -n ops_lab > "$OUT"
echo "Wrote $OUT"
wc -l "$OUT"
head -n 20 "$OUT"
