# BCNF and denormalization

## BCNF (Boyce–Codd) — awareness

Stricter than 3NF: every determinant should be a candidate key. You’ll hit it with overlapping candidate keys (rarer in CRUD apps). Know the name; 3NF covers most Node/API schemas.

## Denormalization — when you break the rules on purpose

After you can normalize, sometimes you **copy** data for read speed or simpler queries.

| Pattern | Example | Cost |
|---------|---------|------|
| Cached count | `courses.enrollment_count` | Must update on enroll/unenroll |
| Snapshot | `orders.product_name` at purchase time | History stays correct if product renames |
| Combined read model | JSON/materialized view for a dashboard | Sync complexity |

Rules of thumb:

1. **Normalize first** (source of truth)  
2. Denormalize with a written reason (latency, history, reporting)  
3. Define who updates the copy (trigger, app transaction, job)

## Not denormalization

- `JSONB` for genuinely flexible attributes (Module 5/9)  
- Read replicas (Module 11) — same schema, different servers  

## Node angle

Duplicating `user.name` onto every `posts` row to avoid a join feels fast until renames. Prefer join or a cached field updated in the same transaction as the write.

## Takeaway

BCNF = edge case for now. Denormalize consciously, never by accident. Snapshots for history ≠ cache drift.
