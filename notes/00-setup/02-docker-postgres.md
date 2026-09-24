# Docker Postgres (not a system install)

## Goal

Run PostgreSQL **only in Docker** via Compose in this repo. No `dnf`/`apt` Postgres on the host required. Data lives in a Docker volume, not scattered in system paths you manage by hand.

## Files in this repo

| File | Role |
|------|------|
| `docker-compose.yml` | Defines the `postgres` service |
| `.env.example` | Copy to `.env` for credentials / `DATABASE_URL` |
| `docker/init/*.sql` | Runs **once** on first boot (empty volume) — schema + seed |

## First-time setup

From the **repo root**:

```bash
cp .env.example .env
docker compose up -d
docker compose ps
```

Wait until healthy, then:

```bash
docker compose exec postgres pg_isready -U postgres -d learn
docker compose exec postgres psql -U postgres -d learn -c 'SELECT version();'
```

You should see `accepting connections`, then PostgreSQL 16.x.

## Useful commands

```bash
# Start / stop
docker compose up -d
docker compose down          # stop & remove container; keeps volume
docker compose down -v       # ALSO deletes data volume (full reset)

# Logs
docker compose logs -f postgres

# Open psql inside the container
docker compose exec postgres psql -U postgres -d learn
```

## Connection from the host (Node)

Compose maps `5432:5432`. From Node on your machine:

```
postgresql://postgres:postgres@localhost:5432/learn
```

(Same as `DATABASE_URL` in `.env.example`.)

## Init scripts caveat

Files in `docker/init` run **only when the data volume is first created**. If you change the seed SQL later:

```bash
docker compose down -v
docker compose up -d
```

That wipes the DB and reloads init scripts.

## Takeaway

Postgres for this curriculum = `docker compose up -d` in this repo. Prefer container `psql` or host tools pointed at `localhost:5432` — not a OS-packaged server.
