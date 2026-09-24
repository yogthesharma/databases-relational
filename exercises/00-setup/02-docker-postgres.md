# Exercise: Docker Postgres

Read: `notes/00-setup/02-docker-postgres.md`

## Tasks

From the **repo root**:

1. Copy env file: `cp .env.example .env`
2. Start the stack: `docker compose up -d`
3. Confirm healthy: `docker compose ps` (postgres should be up/healthy)
4. Print the server version with a one-shot query.
5. List tables in `learn` (hint: `\dt` via `psql`).
6. Answer: What does `docker compose down -v` do that `docker compose down` does not?

## Commands to use

Prefer:

```bash
docker compose exec postgres psql -U postgres -d learn -c '...'
```

## Stretch

Change nothing in Compose yet — just open an interactive `psql` session and exit with `\q`.

---

## Solutions

4. Something like:

```bash
docker compose exec postgres psql -U postgres -d learn -c 'SELECT version();'
```

5.

```bash
docker compose exec postgres psql -U postgres -d learn -c '\dt'
```

You should see `employees` and `products`.

6. `-v` removes named volumes → **deletes database data** and causes init scripts to run again on next `up`. Plain `down` keeps the volume.
