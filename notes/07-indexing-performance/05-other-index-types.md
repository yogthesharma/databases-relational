# Other index types (awareness)

You won’t build all of these in this lab — know **when** they show up.

| Type | Typical use |
|------|-------------|
| **B-tree** | Default: equality, ranges, sort |
| **Hash** | Plain `=` only; rarely worth it vs B-tree |
| **GIN** | JSONB containment, arrays, full-text (`tsvector`) — Module 9 |
| **GiST** | Ranges, geometry, some FTS / exclusion constraints |
| **BRIN** | Huge append-only tables correlated with physical order (time-series) |

```sql
-- examples only (optional; reset lab afterward if you try)
-- CREATE INDEX ON perf_lab.orders USING hash (status);
-- CREATE INDEX ON perf_lab.orders USING brin (created_at);
```

## Choosing without folklore

1. Start with **B-tree** on selective filters/joins  
2. Add **partial** / **composite** when the query shape is clear  
3. Reach for **GIN/GiST/BRIN** when the data type/access pattern demands it (JSONB `@>`, ranges, huge time-ordered fact tables)

## Takeaway

B-tree first. GIN/GiST/BRIN are specialist tools — remember the names; deep practice comes with JSONB/FTS (Module 9) and ops-scale data.
