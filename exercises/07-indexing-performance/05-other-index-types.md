# Exercise: Other index types

Read: `notes/07-indexing-performance/05-other-index-types.md`

## Tasks

1. Match type → use: GIN, BRIN, GiST, B-tree (one line each).
2. Why is Hash rarely chosen over B-tree for a normal `status` column?
3. Which type often backs `JSONB @>` and array containment?
4. Which type fits a multi-terabyte append-only time-series fact table keyed by `created_at`?
5. For this course’s Node APIs, which index type should you create first by default?

## Stretch

Name the module that goes deeper on GIN + JSONB/FTS.

---

## Solutions

1. **B-tree** equality/ranges/sort; **GIN** jsonb/arrays/FTS; **GiST** ranges/geo/exclusions; **BRIN** huge ordered append-only.
2. Hash only helps `=`, can’t do ranges/`ORDER BY`; B-tree covers more.
3. **GIN**.
4. **BRIN** (often).
5. **B-tree**.

Stretch: Module 9.
