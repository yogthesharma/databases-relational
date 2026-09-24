# Exercise: Relational mental model

Read: `notes/00-setup/01-relational-mental-model.md`

## Tasks

1. In your own words (2–4 sentences): what is a **table**, a **row**, and a **primary key**?
2. Look at the seed (or `\d employees` later). Name one **foreign key** relationship in `employees` and what it means.
3. Map a familiar Node resource to tables:
   - Example domain: a blog with authors and posts.
   - List tables you’d create and which keys link them.
4. True/False: “If I use Prisma, I don’t need to understand SQL joins.” Explain briefly.

## Stretch

Sketch (text is fine) how a `GET /api/employees/:id` route would flow from HTTP → Node → Postgres → JSON.

---

## Solutions

1. Table = named collection of rows with fixed columns. Row = one record. Primary key = unique identifier for a row (often `id`).
2. `manager_id` references `employees(id)` — an employee’s manager is another employee row.
3. Example: `authors(id)`, `posts(id, author_id → authors.id)`. Optional `tags` + `post_tags(post_id, tag_id)` for M:N.
4. False. Prisma generates SQL; joins, N+1, and transactions still require relational understanding when things break or get slow.
