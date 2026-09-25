# Exercise: Naming and schemas

Read: `notes/04-schema-design/05-naming-and-schemas.md`

## Tasks

1. Rename these to conventional snake_case table/column names: `StudentEmail`, `CourseCredits`, `InstructorDept`.
2. Why prefer table name `users` over `user` in Postgres?
3. List the schemas you already have in this database (`\dn`). What is each for in this course?
4. Write a query that qualifies `raw_enrollments` with its schema name.
5. When would you create a new Postgres schema vs a new database?

## Stretch

`SET search_path TO design_lab, public;` then `SELECT count(*) FROM raw_enrollments;` — why does that work?

---

## Solutions

1. `student_email`, `course_credits`, `instructor_dept` (or on normalized tables: `email`, `credits`, `dept`).
2. `user` is a reserved role/keyword; unquoted `user` is painful.
3. Typically `public` (shared course tables), `write_lab` (M3), `design_lab` (M4), `types_lab` (M5), `tx_lab` (M6), `perf_lab` (M7) — plus system schemas.
4. `SELECT * FROM design_lab.raw_enrollments;`
5. New **schema**: same DB, shared roles/backup, namespace split. New **database**: stronger isolation (extra connections, migrations, backups).

Stretch: `search_path` makes unqualified names resolve in `design_lab` first.
