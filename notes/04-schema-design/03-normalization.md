# Normalization (1NF → 3NF)

Normalization removes repeated groups and bad dependencies so each fact lives in one place.

Use `design_lab.raw_enrollments` as the “before” picture.

## 1NF — atomic values, no repeating groups

- One value per cell (not “Asha, Deepa” in one column)
- No arrays-of-columns like `course1`, `course2` (use rows / child tables)

`raw_enrollments` is already row-shaped (OK for 1NF-ish) but still packs many entities per row.

## 2NF — no partial dependency on a composite key

If the PK is composite, non-key attributes must depend on the **whole** key, not part of it.

Classic smell: enrollment key `(student_id, course_id)` but `student_email` stored on enrollment → email depends only on student.

**Fix:** put student attributes on `students`.

## 3NF — no transitive dependency

Non-key attributes shouldn’t depend on other non-key attributes.

Smell: on the flat row, `instructor_email` → `instructor_dept` while email isn’t a key of that row (dept rides along via instructor). Same idea if course attributes embed instructor fields.

**Fix:** `instructors` table; `courses` references `instructor_id`.

## Target shape for the lab

```text
students (id, email, full_name, phone)
instructors (id, email, full_name, dept)
courses (id, code, title, credits, instructor_id → instructors)
enrollments (id, student_id → students, course_id → courses, enrolled_on, grade)
             UNIQUE (student_id, course_id)
```

That’s the usual 3NF outcome for this spreadsheet.

## How to migrate data (idea)

1. Create normalized tables  
2. `INSERT … SELECT DISTINCT` students / instructors / courses  
3. Insert enrollments by joining on natural keys (email, course code)  
4. Keep `raw_enrollments` as archive or drop later  

## Takeaway

1NF: atomic rows. 2NF: full composite key. 3NF: no transitive deps. Separate entities; put relationship attributes on the bridge.
