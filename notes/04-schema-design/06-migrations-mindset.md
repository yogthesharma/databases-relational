# Migrations mindset

## Schema changes are product changes

In Node you’ll use Prisma Migrate, Drizzle-kit, Knex, Flyway, etc. The tool isn’t the point — **expand/contract** is.

## Expand / contract (zero-downtime habit)

1. **Expand:** add new column/table (nullable or with default) — old app code still works  
2. **Migrate data** — backfill  
3. **Switch** app reads/writes to the new shape  
4. **Contract:** drop old column/table when nothing uses it  

Never: rename/drop a column in one step while old servers are still running.

## Examples

| Risky one-step | Safer |
|----------------|--------|
| `DROP COLUMN phone` | Stop writing phone → deploy → drop later |
| Rename `name` → `full_name` | Add `full_name`, dual-write, switch reads, drop `name` |
| Change `grade` TEXT → enum | Add new column, backfill, switch, drop old |

## Migrations as code

- Checked into git  
- Applied in order on each environment  
- Rehearsed on a copy of prod-ish data  

Your `design_lab` reset script is a toy migration: tear down + rebuild. Real systems almost never `DROP SCHEMA CASCADE` in production.

## Node angle

Prisma `migrate dev` locally; `migrate deploy` in CI/prod. Same expand/contract rules apply to the SQL it generates — review the SQL.

## Takeaway

Additive first, remove later. Treat migrations as reviewed code. Don’t confuse lab resets with production migrations.
