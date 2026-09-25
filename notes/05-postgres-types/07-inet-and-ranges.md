# inet, ranges, and choosing types

## `INET` / `CIDR`

```sql
SELECT email, signup_ip FROM types_lab.customers;
SELECT email FROM types_lab.customers
WHERE signup_ip << '203.0.113.0/24'::cidr;   -- contained in subnet
```

Store IPs as `INET`, not text — validation + operators (`<<`, `>>`, family checks) come free.

## Ranges (overview)

Postgres range types: `int4range`, `tstzrange`, `daterange`, …

```sql
SELECT id, ship_window,
       lower(ship_window), upper(ship_window)
FROM types_lab.orders
WHERE ship_window IS NOT NULL;

-- Does this instant fall in the window?
SELECT id FROM types_lab.orders
WHERE ship_window @> '2024-03-12 12:00:00+00'::timestamptz;
```

Bounds use `[)` / `[]` inclusivity. Great for bookings, validity windows, inventory lots. Deep indexing (`GiST`) can wait until you need it.

## Checkpoint mindset — pick types on purpose

For each column ask:

1. Exact or approximate?  
2. Need zone-aware time?  
3. Fixed vocabulary or open text?  
4. Queried shape → column; leftover bag → `JSONB`?  
5. Multi-value small list → array; real entity → table?

Example sketch for a “library checkout” mini-app:

| Column | Type | Why |
|--------|------|-----|
| `books.id` | `UUID` or `SERIAL` | Surrogate PK |
| `isbn` | `TEXT` + `UNIQUE` | Natural key |
| `fine_cents` | `INTEGER` | Exact money as cents |
| `due_at` | `TIMESTAMPTZ` | Event in time |
| `tags` | `TEXT[]` or table | Small list vs rich metadata |
| `status` | `ENUM` or lookup | Tiny frozen vs evolving |
| `pickup_ip` | `INET` | Client address |
| `meta` | `JSONB` | Rare extras |

## Takeaway

`INET` for IPs; ranges for windows. The real skill is justifying every column’s type — that’s this module’s checkpoint.
