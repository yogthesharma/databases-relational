# Exercise: Modeling patterns

Read: `notes/04-schema-design/07-modeling-patterns.md`

## Tasks

1. Add soft-delete to `design_lab.students`: a `deleted_at` column. What’s the default for live rows?
2. Why does soft delete make a plain `UNIQUE (email)` trickier?
3. Enum vs lookup: would you store enrollment `status` (`active`/`dropped`/`completed`) as ENUM or table? Justify briefly.
4. Write a 1:1 `student_profiles` table keyed by `student_id`.
5. List audit columns you’d put on `enrollments` for an API that must show “when it was created.”

## Stretch

Partial unique index idea (preview): unique email among rows where `deleted_at IS NULL` — write the `CREATE UNIQUE INDEX` sketch (yes, Module 7 will go deeper).

---

## Solutions

1.

```sql
ALTER TABLE design_lab.students
  ADD COLUMN deleted_at TIMESTAMPTZ;
-- live rows: deleted_at IS NULL
```

2. Deleted users still hold the email in a plain `UNIQUE` column, blocking re-registration — drop that constraint and use a partial unique on live rows (or rename emails on delete).
3. Either works; **ENUM** if the set is tiny and frozen; **lookup table** if you expect more statuses or metadata. Many apps start with TEXT + CHECK.
4.

```sql
CREATE TABLE design_lab.student_profiles (
  student_id INTEGER PRIMARY KEY
    REFERENCES design_lab.students (id),
  bio TEXT
);
```

5. At least `created_at TIMESTAMPTZ NOT NULL DEFAULT now()`; often `updated_at` too.

Stretch:

```sql
-- Plain UNIQUE still blocks soft-deleted emails — drop it, then partial unique:
ALTER TABLE design_lab.students DROP CONSTRAINT students_email_key;

CREATE UNIQUE INDEX students_email_live_uidx
  ON design_lab.students (email)
  WHERE deleted_at IS NULL;
```
