# Functions and procedures

## SQL function (lab)

```sql
SELECT feat_lab.article_likes(1);
```

```sql
-- CREATE FUNCTION … LANGUAGE sql STABLE AS $$ SELECT … $$;
```

Prefer **SQL** language for simple wrappers the planner can inline. Use **PL/pgSQL** when you need variables, loops, exception handlers.

## Procedures

`CALL proc()` — can `COMMIT` inside (PG 11+). Most app logic still belongs in the Node service; DB routines for constraints close to data, generated columns, or shared batch jobs.

## When logic belongs in DB vs app

| In DB | In app |
|-------|--------|
| Invariants, derived columns, RLS helpers | Product rules that change weekly |
| One definition for many clients | Orchestration, HTTP, queues |
| Hot path set-based transforms | Complex domain workflows |

## Takeaway

Small SQL functions are fine. Don’t move your whole backend into PL/pgSQL.
