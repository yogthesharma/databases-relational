# ORMs vs query builders vs raw SQL

| Approach | Pros | Cons |
|----------|------|------|
| **ORM** (Prisma, Sequelize, …) | Models, migrations, fast CRUD | Easy N+1; opaque SQL; leaky abstractions |
| **Query builder** (Knex, Kysely, …) | Composable; still see SQL shape | You write more; less “magic” |
| **Raw SQL** (`pg`, prepared) | Full control; teachable; EXPLAIN-friendly | Boilerplate; you own safety |

This curriculum prefers **raw parameterized SQL** so you learn what the database actually does. Use an ORM later with eyes open.

## Rule of thumb

- CRUD + simple filters → any layer is fine  
- Reporting, windows, tricky joins, concurrency → write (or inspect) the SQL  

## Takeaway

ORMs are tools, not a substitute for SQL literacy. Prefer inspectable queries for money paths and performance-critical code.
