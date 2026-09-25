# Exercise: Keys

Read: `notes/04-schema-design/02-keys.md`

## Tasks

1. What is a good **natural** unique key for students in this data? For courses?
2. Why might `student_name` be a bad primary key?
3. Write `CREATE TABLE` for `design_lab.students` with surrogate `id` PK and unique `email`.
4. For `enrollments`, how do you prevent the same student from enrolling in the same course twice?
5. Surrogate vs natural: which do you use as the FK target from `enrollments` to `students`, and why?

## Stretch

Create `design_lab.courses` with `id`, unique `code`, `title`, `credits` (instructor FK comes in the next exercises).

---

## Solutions

1. Students: `student_email` / `email`. Courses: `course_code` / `code`.
2. Names collide and change; not unique.
3.

```sql
CREATE TABLE design_lab.students (
  id         SERIAL PRIMARY KEY,
  email      TEXT NOT NULL UNIQUE,
  full_name  TEXT NOT NULL,
  phone      TEXT
);
```

4. `UNIQUE (student_id, course_id)` (and/or composite PK).
5. FK to surrogate `students.id` — stable; email can change without updating every enrollment row if you also keep email unique on students.

Stretch:

```sql
CREATE TABLE design_lab.courses (
  id       SERIAL PRIMARY KEY,
  code     TEXT NOT NULL UNIQUE,
  title    TEXT NOT NULL,
  credits  INTEGER NOT NULL CHECK (credits > 0)
);
```
