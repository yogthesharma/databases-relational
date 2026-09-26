# Testing database code

## Patterns

| Pattern | Idea |
|---------|------|
| **Fixtures / seeds** | Known rows before each test (like `app_lab`) |
| **Transactional tests** | `BEGIN` → run test → `ROLLBACK` (isolate) |
| **Test DB** | Separate database or schema; never prod |
| **Assert SQL effects** | Query balances / row counts after the use case |

## What to test

- Happy path of money / inventory flows  
- Constraint violations (duplicate unique, check fail)  
- Concurrent cases when it matters (Module 6)  

Don’t assert on ORM internals — assert on **table state**.

## Takeaway

Treat the DB as part of the system under test. Reset or roll back between cases; assert outcomes in SQL.
