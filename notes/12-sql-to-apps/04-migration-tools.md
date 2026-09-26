# Migration tools (awareness)

| Tool | Ecosystem |
|------|-----------|
| Prisma Migrate | Node / Prisma |
| Flyway / Liquibase | JVM / polyglot SQL files |
| golang-migrate | Go / SQL files |
| Sqitch | SQL-first, dependency-aware |
| Django / Rails / Alembic | Framework-bundled |

## What good tools share

- Versioned scripts in git  
- Applied once per environment, tracked in a table  
- Expand/contract friendly (additive first)  

Lab resets (`DROP SCHEMA CASCADE`) are learning shortcuts — production uses forward migrations.

## Takeaway

Pick one tool when you build a real app. The skill is **ordered, reviewed, reversible-minded** schema change — not memorizing every CLI.
