# Temporal types

## The cast

| Type | Meaning |
|------|---------|
| `DATE` | Calendar day (no time) |
| `TIME` | Time of day (rarely alone) |
| `TIMESTAMP` | Date+time **without** time zone |
| `TIMESTAMPTZ` | Date+time stored in UTC; displayed in session TZ |
| `INTERVAL` | Duration (`'2 days'`, `'01:30'`) |

**Prefer `TIMESTAMPTZ`** for “when did this happen?” in apps. `TIMESTAMP` without TZ silently lies across zones.

## Lab examples

```sql
SHOW timezone;  -- container default is often UTC

SELECT email, created_at, created_at AT TIME ZONE 'Asia/Kolkata' AS local_ist
FROM types_lab.customers;

SELECT id, placed_at, placed_at + INTERVAL '2 days' AS eta
FROM types_lab.orders;
```

`AT TIME ZONE` on `timestamptz` yields a `timestamp without time zone` in that zone — read the docs once; it’s easy to invert.

## Date vs timestamptz

- Birthday, fiscal day → `DATE`
- Order placed, login, `created_at` → `TIMESTAMPTZ`
- “Store wall-clock local time with no zone” → rare; usually a mistake

## Intervals

```sql
SELECT now() - placed_at AS age FROM types_lab.orders;

-- Lab data is March 2024 — use a fixed cutoff here (now() - 30 days returns nothing in 2026+)
SELECT * FROM types_lab.orders
WHERE placed_at >= TIMESTAMPTZ '2024-03-01';

-- Real apps usually write relative windows:
-- WHERE placed_at >= now() - INTERVAL '30 days'
```

## Node angle

Send ISO-8601 strings with offset (`2024-03-10T16:00:00Z`). Let Postgres store `timestamptz`. Don’t “serialize local time without zone” unless you really mean it.

## Takeaway

Events → `timestamptz`. Calendar days → `date`. Durations → `interval`. Avoid naked `timestamp` for app clocks.
