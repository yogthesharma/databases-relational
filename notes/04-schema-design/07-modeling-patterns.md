# Modeling patterns

## Soft deletes

```sql
deleted_at TIMESTAMPTZ  -- NULL = live
-- or is_deleted BOOLEAN NOT NULL DEFAULT FALSE
```

Pros: recoverability, audit. Cons: every query needs `WHERE deleted_at IS NULL`; a plain `UNIQUE (email)` still blocks re-registration after soft delete — **replace** it with a partial unique index on live rows (`WHERE deleted_at IS NULL`), don’t just add one alongside.

## Audit columns

```sql
created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
updated_at TIMESTAMPTZ,
created_by INTEGER REFERENCES users(id)  -- optional
```

Set `updated_at` in app code or a trigger (Module 9 territory).

## Enum vs lookup table

| | Postgres `ENUM` | Lookup table |
|--|-----------------|--------------|
| Values | Fixed in type | Rows you can INSERT |
| Changing values | Awkward (`ALTER TYPE`) | Easy |
| Extra attributes | No | Yes (label, sort_order) |
| Best for | Tiny stable sets (`pending/shipped`) | Lists that grow / need metadata |

Grades like `A`, `B+` can be `TEXT + CHECK`, enum, or `grades` lookup — for the lab, `TEXT` is fine.

## 1:1 pattern

```sql
CREATE TABLE design_lab.student_profiles (
  student_id INTEGER PRIMARY KEY REFERENCES design_lab.students(id),
  bio TEXT
);
```

PK = FK → forces one profile per student.

## M:N reminder

Bridge table with two FKs + payload columns (`enrolled_on`, `grade`).

## Takeaway

Soft delete and audit columns are app-wide conventions — pick them early. Prefer lookup tables when values change; enums for tiny frozen sets.
