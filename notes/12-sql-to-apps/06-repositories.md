# Repositories / data access

## Goal

Keep SQL **findable and reviewable** — not sprinkled as string soup in route handlers.

```text
routes → service → repository (SQL) → Postgres
```

A tiny “repository” can be one module exporting `transfer(from, to, amount)`.

## Habits

- One place owns each query  
- Parameterized only  
- Return plain data (rows), not leaky clients  
- Log or comment non-obvious SQL  

## Takeaway

Structure so a reviewer can open one file and see the SQL for a use case. That’s how you keep Module 7 skills alive in an app.
