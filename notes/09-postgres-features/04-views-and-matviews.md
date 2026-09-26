# Views and materialized views

## View = stored query

```sql
SELECT * FROM feat_lab.published_articles;
```

Always fresh; no extra storage. Good for stable “API shapes” and security (grant on view, not base table — with care).

## Materialized view = stored result

```sql
SELECT * FROM feat_lab.tag_stats ORDER BY article_count DESC;

REFRESH MATERIALIZED VIEW feat_lab.tag_stats;
-- CONCURRENTLY needs a unique index (lab has one) and no open txn holding locks oddly
```

Stale until refresh. Great for dashboards / heavy aggregates.

## Tradeoffs

| | View | Matview |
|--|------|---------|
| Freshness | Always | Until `REFRESH` |
| Cost | Pay on read | Pay on refresh |
| Indexes | N/A (runs query) | Can index the result |

## Takeaway

Views for encapsulation. Matviews for expensive summaries you can refresh on a schedule.
