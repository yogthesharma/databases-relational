-- Module 4: design lab — messy "spreadsheet" data to normalize.
-- Safe to re-run: drops and recreates schema design_lab.

DROP SCHEMA IF EXISTS design_lab CASCADE;

CREATE SCHEMA design_lab;

-- Intentionally denormalized / spreadsheet-shaped (do NOT treat as good design).
CREATE TABLE design_lab.raw_enrollments (
  id               SERIAL PRIMARY KEY,
  student_name     TEXT NOT NULL,
  student_email    TEXT NOT NULL,
  student_phone    TEXT,
  course_code      TEXT NOT NULL,
  course_title     TEXT NOT NULL,
  course_credits   INTEGER NOT NULL,
  instructor_name  TEXT NOT NULL,
  instructor_email TEXT NOT NULL,
  instructor_dept  TEXT NOT NULL,
  enrolled_on      DATE NOT NULL,
  grade            TEXT
);

INSERT INTO design_lab.raw_enrollments
  (student_name, student_email, student_phone, course_code, course_title, course_credits,
   instructor_name, instructor_email, instructor_dept, enrolled_on, grade)
VALUES
  ('Asha Patel',  'asha@example.com',  '555-0101', 'CS101', 'Intro to CS',     3, 'Ben Okoye', 'ben@uni.edu', 'CS',   '2024-01-10', 'A'),
  ('Asha Patel',  'asha@example.com',  '555-0101', 'CS201', 'Data Structures', 4, 'Chen Wu',  'chen@uni.edu','CS',   '2024-01-10', 'B+'),
  ('Deepa Singh', 'deepa@example.com', '555-0102', 'CS101', 'Intro to CS',     3, 'Ben Okoye', 'ben@uni.edu', 'CS',   '2024-01-12', 'A-'),
  ('Deepa Singh', 'deepa@example.com', '555-0102', 'MATH90','College Algebra',  3, 'Lina Costa','lina@uni.edu','Math', '2024-01-12', NULL),
  ('Hugo Martin', 'hugo@example.com',  NULL,       'CS101', 'Intro to CS',     3, 'Ben Okoye', 'ben@uni.edu', 'CS',   '2024-01-15', 'B'),
  ('Hugo Martin', 'hugo@example.com',  NULL,       'CS201', 'Data Structures', 4, 'Chen Wu',  'chen@uni.edu','CS',   '2024-01-15', 'A'),
  ('Maya Ibrahim','maya@example.com',  '555-0103', 'MATH90','College Algebra',  3, 'Lina Costa','lina@uni.edu','Math', '2024-02-01', 'B+'),
  ('Maya Ibrahim','maya@example.com',  '555-0103', 'CS101', 'Intro to CS',     3, 'Ben Okoye', 'ben@uni.edu', 'CS',   '2024-02-01', NULL);

-- Workspace for YOUR normalized tables (starts empty aside from raw_enrollments).
-- Exercises will CREATE tables here (students, courses, instructors, enrollments, …).
