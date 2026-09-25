# Naming and schemas

## Table / column naming (boring = good)

Common Node/Postgres conventions:

| Thing | Convention | Examples |
|-------|------------|----------|
| Tables | plural, snake_case | `students`, `enrollments` |
| Columns | snake_case | `created_at`, `instructor_id` |
| PKs | `id` | |
| FKs | `<table_singular>_id` | `student_id`, `course_id` |
| Booleans | `is_` / `has_` | `is_active` |
| Timestamps | `*_at` (or `*_on` for dates) | `created_at`, `enrolled_on` |

Avoid reserved words as names (`user`, `order`) or quote them forever — prefer `users`, `orders`.

## Postgres schemas

A **schema** is a namespace inside a database (not the same as “schema design”).

| Schema | Role in this repo |
|--------|-------------------|
| `public` | Default; `employees`, `products`, `orders` |
| `write_lab` | Module 3 write practice |
| `design_lab` | Module 4 design practice |
| `types_lab` | Module 5 types practice |
| `tx_lab` | Module 6 transactions / concurrency |

```sql
CREATE SCHEMA IF NOT EXISTS app;
SET search_path TO app, public;
```

Apps often use one schema per bounded context (`app`, `billing`) or stick to `public` until you need isolation.

## Qualifying names

```sql
SELECT * FROM design_lab.raw_enrollments;
```

## Takeaway

Consistent snake_case + clear FK names. Use Postgres schemas to separate labs/domains without new databases.
