# Exercise: BCNF & denormalization

Read: `notes/04-schema-design/04-bcnf-and-denormalization.md`

## Tasks

1. In one sentence: when would you care about BCNF beyond 3NF in an app schema?
2. Give one **good** reason to denormalize (snapshot or cache) for a course platform.
3. Give one **bad** accidental denormalization from `raw_enrollments`.
4. If you add `courses.enrollment_count`, what must stay true when someone enrolls?
5. Order line items often store `unit_price` even though `products.price` exists — snapshot or cache? Why?

## Stretch

Propose a denormalized column you’d accept on `enrollments` and one you’d reject.

---

## Solutions

1. When overlapping candidate keys create anomalies 3NF doesn’t catch — uncommon in simple CRUD; learn the name, don’t obsess yet.
2. e.g. cache `enrollment_count` on courses for a hot catalog page; or snapshot instructor name on a printed transcript.
3. Repeating `instructor_dept` on every enrollment row — update anomalies if dept renames.
4. The same transaction (or reliable job) that inserts `enrollments` must bump (or recompute) `enrollment_count`.
5. **Snapshot** — historical price paid must not change when the product price changes later.

Stretch (examples): accept `course_code` snapshot on a certificate row; reject copying `student_phone` onto every enrollment without a sync story.
