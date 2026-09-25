# UPDATE, DELETE, TRUNCATE

## UPDATE

Change existing rows. **Always** scope with `WHERE` unless you truly mean every row.

```sql
UPDATE write_lab.items
SET price = 8.99, updated_at = now()
WHERE sku = 'WL-001';
```

Expressions:

```sql
UPDATE write_lab.items
SET stock = stock - 1
WHERE id = 1 AND stock > 0;
```

## DELETE

Remove rows that match `WHERE`:

```sql
DELETE FROM write_lab.item_notes
WHERE item_id = 3;
```

FK behavior matters: deleting an `items` row with `ON DELETE CASCADE` children removes notes too (constraints note).

## TRUNCATE

Empty a table fast (removes all rows; no `WHERE`):

```sql
-- Lab only — wipes all rows
TRUNCATE write_lab.item_notes;
```

Identity/serial columns: by default Postgres **continues** the sequence (`CONTINUE IDENTITY`). To reset ids back to 1:

```sql
TRUNCATE write_lab.item_notes RESTART IDENTITY;
```

| | DELETE | TRUNCATE |
|--|--------|----------|
| WHERE filter | Yes | No (whole table / listed tables) |
| Speed (big table) | Slower | Faster |
| Triggers | Row triggers fire | Not the same as per-row DELETE |
| Transaction | Yes | Yes (in Postgres) |
| Serial/identity | Unchanged | Continues unless `RESTART IDENTITY` |

Day-to-day app code: **DELETE** with WHERE. **TRUNCATE** for admin/reset/test labs.

## The footgun

```sql
-- NEVER in production without WHERE (unless intentional)
UPDATE write_lab.items SET price = 0;
DELETE FROM write_lab.items;
```

In `psql`, some people use safe tricks; in apps, require IDs from the request and parameterize.

## Node

```js
await client.query('BEGIN');
const r = await client.query(
  `UPDATE write_lab.items SET stock = stock - $1
   WHERE id = $2 AND stock >= $1
   RETURNING id, stock`,
  [qty, id]
);
if (r.rowCount === 0) {
  await client.query('ROLLBACK');
  throw new Error('insufficient stock');
}
await client.query('COMMIT');
```

(Transactions properly in Module 6 — pattern preview.)

## Takeaway

UPDATE/DELETE need a precise WHERE. Prefer DELETE in apps; TRUNCATE for reset. Check `rowCount` when a write must affect exactly one row.
