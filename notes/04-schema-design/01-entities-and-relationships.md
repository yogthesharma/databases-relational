# Entities and relationships

## Schema design is the product of modeling

Before writing clever SQL, decide **what things exist** and **how they relate**. Bad models force ugly queries forever; good models make joins obvious.

## Vocabulary

| Term | Meaning | Enrollment example |
|------|---------|-------------------|
| **Entity** | A real-world thing you store | Student, Course, Instructor |
| **Attribute** | A property of an entity | email, course_code, credits |
| **Relationship** | How entities connect | Student enrolls in Course |

## Relationship shapes (again, for design)

| Shape | Meaning | Example |
|-------|---------|---------|
| **1:1** | One row ↔ one row | User ↔ UserProfile |
| **1:N** | One parent, many children | Instructor → many Courses |
| **M:N** | Many ↔ many | Students ↔ Courses (via **enrollment** bridge) |

M:N almost always becomes a **bridge table** with two FKs (and often its own attributes like `grade`, `enrolled_on`).

## Look at the mess

```sql
SELECT * FROM design_lab.raw_enrollments LIMIT 5;
```

One row mixes student + course + instructor + enrollment. That’s a spreadsheet, not a schema. Spot:

- Same student repeated with the same email/phone
- Same course repeated with the same title/credits
- Same instructor repeated with the same dept
- Grade/enrolled_on belong to the **enrollment**, not the student alone

## Node angle

Prisma/Drizzle models ≈ entities; relations ≈ FKs/joins. If the Prisma schema is confused, the SQL schema usually was first.

## Takeaway

Name entities, attributes, and relationship shapes before creating tables. M:N → bridge table.
