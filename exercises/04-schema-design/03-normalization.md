# Exercise: Normalization

Read: `notes/04-schema-design/03-normalization.md`

Reset the lab first if you already created tables. Goal: build a 3NF schema and load it from `raw_enrollments`.

## Tasks

1. Name one **2NF** smell in storing `student_email` on every enrollment row.
2. Name one **3NF** smell involving instructor department.
3. Create normalized tables in `design_lab`:
   - `students`
   - `instructors`
   - `courses` (FK to instructors)
   - `enrollments` (FKs + `UNIQUE (student_id, course_id)`)
4. Populate them from `raw_enrollments` with `INSERT … SELECT DISTINCT` / joins.
5. Prove it: count enrollments; list each student’s email with course codes (join query).

## Stretch

Find a student with a NULL grade and show their name + course title via joins (no raw table).

---

## Solutions

1. Email depends only on the student, not on `(student, course)` — partial dependency if that were the key.
2. `instructor_dept` depends on instructor (via email), not on the enrollment key — transitive dependency on the flat row.

3–4. Reference solution:

```sql
CREATE TABLE design_lab.students (
  id         SERIAL PRIMARY KEY,
  email      TEXT NOT NULL UNIQUE,
  full_name  TEXT NOT NULL,
  phone      TEXT
);

CREATE TABLE design_lab.instructors (
  id         SERIAL PRIMARY KEY,
  email      TEXT NOT NULL UNIQUE,
  full_name  TEXT NOT NULL,
  dept       TEXT NOT NULL
);

CREATE TABLE design_lab.courses (
  id             SERIAL PRIMARY KEY,
  code           TEXT NOT NULL UNIQUE,
  title          TEXT NOT NULL,
  credits        INTEGER NOT NULL CHECK (credits > 0),
  instructor_id  INTEGER NOT NULL REFERENCES design_lab.instructors (id)
);

CREATE TABLE design_lab.enrollments (
  id           SERIAL PRIMARY KEY,
  student_id   INTEGER NOT NULL REFERENCES design_lab.students (id),
  course_id    INTEGER NOT NULL REFERENCES design_lab.courses (id),
  enrolled_on  DATE NOT NULL,
  grade        TEXT,
  UNIQUE (student_id, course_id)
);

INSERT INTO design_lab.students (email, full_name, phone)
SELECT DISTINCT student_email, student_name, student_phone
FROM design_lab.raw_enrollments;

INSERT INTO design_lab.instructors (email, full_name, dept)
SELECT DISTINCT instructor_email, instructor_name, instructor_dept
FROM design_lab.raw_enrollments;

INSERT INTO design_lab.courses (code, title, credits, instructor_id)
SELECT DISTINCT r.course_code, r.course_title, r.course_credits, i.id
FROM design_lab.raw_enrollments r
JOIN design_lab.instructors i ON i.email = r.instructor_email;

INSERT INTO design_lab.enrollments (student_id, course_id, enrolled_on, grade)
SELECT s.id, c.id, r.enrolled_on, r.grade
FROM design_lab.raw_enrollments r
JOIN design_lab.students s ON s.email = r.student_email
JOIN design_lab.courses c ON c.code = r.course_code;
```

5.

```sql
SELECT count(*) FROM design_lab.enrollments;  -- 8

SELECT s.email, c.code, e.grade
FROM design_lab.enrollments e
JOIN design_lab.students s ON s.id = e.student_id
JOIN design_lab.courses c ON c.id = e.course_id
ORDER BY s.email, c.code;
```

Stretch:

```sql
SELECT s.full_name, c.title
FROM design_lab.enrollments e
JOIN design_lab.students s ON s.id = e.student_id
JOIN design_lab.courses c ON c.id = e.course_id
WHERE e.grade IS NULL;
```
