# Exercise: Entities and relationships

Read: `notes/04-schema-design/01-entities-and-relationships.md`

```sql
SELECT * FROM design_lab.raw_enrollments;
```

## Tasks

1. List the **entities** you see packed into `raw_enrollments`.
2. For each, list 2–3 **attributes**.
3. What shape is Student ↔ Course? What table do you need for it?
4. What shape is Instructor ↔ Course (assuming one instructor per course in this data)?
5. Which columns are attributes of the **enrollment relationship** (not of student or course alone)?

## Stretch

Sketch (text) an ER list: boxes for entities and lines labeled 1:N / M:N.

---

## Solutions

1. Student, Course, Instructor, (Enrollment as relationship entity).
2. Student: name, email, phone. Course: code, title, credits. Instructor: name, email, dept. Enrollment: enrolled_on, grade.
3. **M:N** → bridge table `enrollments`.
4. **1:N** (one instructor, many courses) in this dataset.
5. `enrolled_on`, `grade`.

Stretch: Students —M:N— Courses; Instructors —1:N— Courses; Enrollment holds the M:N + grade/date.
