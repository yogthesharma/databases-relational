# Keys

## Candidate key

Any minimal set of columns that uniquely identifies a row. A table can have several candidates; you pick one as primary.

## Primary key (PK)

The chosen identifier. Every table should have one.

## Surrogate vs natural

| | Surrogate | Natural |
|--|-----------|---------|
| Example | `id SERIAL` / `UUID` | `email`, `course_code`, `sku` |
| Pros | Stable, opaque, easy FKs | Meaningful, sometimes no join to “look up code” |
| Cons | Extra column; not human-meaningful | Can change (email change, code rename); wider FKs |

**Practice in apps:** surrogate PK (`id`) + **UNIQUE** natural keys (`email`, `course_code`) for lookups and upserts.

```sql
CREATE TABLE design_lab.students (
  id         SERIAL PRIMARY KEY,           -- surrogate
  email      TEXT NOT NULL UNIQUE,         -- natural candidate
  full_name  TEXT NOT NULL,
  phone      TEXT
);
```

## Foreign key

Points at a PK/unique key elsewhere. Documents the relationship and enforces it.

## Composite keys

Sometimes the PK is multiple columns (e.g. `(student_id, course_id)` on enrollments). Surrogate `enrollments.id` is also fine; still put `UNIQUE (student_id, course_id)` so a student can’t enroll twice.

## Takeaway

Prefer surrogate PKs + unique natural keys. FKs enforce relationships. Uniqueness rules belong in the database.
