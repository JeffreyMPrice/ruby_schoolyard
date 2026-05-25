# Ruby Schoolyard
## ActiveRecord Curriculum — E-Commerce Domain

A progressive, test-driven curriculum for junior developers joining a Ruby on Rails 7.2 project. Each assignment consists of a failing RSpec test suite that the learner must make pass. Assignments are designed to take 10–30 minutes depending on phase.

---

## Structure & Conventions

- **Testing framework:** RSpec
- **Database:** SQLite (Rails 7.2 default; no external dependency). A few late assignments touch features SQLite can't fully enforce (e.g. `FOR UPDATE`, read replicas) — teacher notes flag these where relevant.
- **Domain:** E-commerce store (products, categories, orders, line items, users, reviews)
- **Phases 1–2:** Isolated mini-apps, specs + README hints
- **Phase 3:** Isolated mini-apps; README hints fade out (07–09 keep brief hints, 10+ specs only)
- **Phase 4:** Isolated mini-apps, specs only
- **Phases 5–10:** Single growing app, specs only — starts from a "solved-through-15A" starter repo containing all completed Phase 1–4 work
- **Solutions:** Available in a gated reference repo, one branch per assignment (e.g. `solution/01-building-the-schema`)
- **Anti-pattern assignments** are marked with ⚠️ — these contain intentionally broken or problematic code that the learner must identify, explain, and fix

---

## Phase 1: Foundations
*Isolated apps. Specs + README hints. 10–20 min each.*

| # | Title | Concept | Key Topics |
|---|-------|---------|------------|
| 01 | Building the Schema | Migrations | Column types, `null: false`, `add_index`, rolling back |
| 02 | Keeping Data Clean | Validations | `presence`, `uniqueness`, `numericality`, custom validators, `errors` |
| 03 | Finding Things | Basic querying | `find`, `find_by`, `where`, `order`, `limit`, `pluck`, `pick`, `ids` |

---

## Phase 2: Associations
*Isolated apps. Specs + README hints. 10–20 min each.*

| # | Title | Concept | Key Topics |
|---|-------|---------|------------|
| 04 | Products & Categories | `belongs_to` / `has_many` | Foreign keys, `dependent: :destroy`, `where.associated`, `where.missing` |
| 05 | Orders & Line Items | `has_many :through` | Join models, aggregate data through associations |
| 06 | Tagging Products | `habtm` vs `has_many :through` | When to use each, the `habtm` trap, join tables |
| 06A ⚠️ | The `habtm` Trap | Anti-pattern | Specs demonstrate what breaks when extra data is needed on the join table; learner migrates to `has_many :through` |

---

## Phase 3: Advanced Queries
*Isolated apps. Brief README hints on 07–09, then specs only (10+). 10–20 min each.*

| # | Title | Concept | Key Topics |
|---|-------|---------|------------|
| 07 | Scoping the Catalog | Scopes | Named scopes, chaining, lambda scopes with args, `none` (null relation) |
| 07A ⚠️ | The `default_scope` Disaster | Anti-pattern | Pre-written model with `default_scope` causing subtle bugs; learner writes specs exposing each problem, then refactors to named scopes |
| 08 | Querying Across Tables | `joins` / `includes` / `eager_load` | N+1 problem, `preload` vs `eager_load` vs `includes`, `references`, `strict_loading` |
| 09 | Outer Joins & Missing Records | `left_outer_joins` | Finding products with no orders, `where.missing`, `where.associated` |
| 10 | Overriding & Escaping Scopes | Scope override methods | `unscope`, `reorder`, `rewhere`, `only`, `merge` |
| 11 | Aggregates & Reporting | Calculations | `count`, `sum`, `group`, `having`, `average`, `minimum`, `maximum` |

---

## Phase 4: Callbacks & Transactions
*Isolated apps. Specs only. 10–20 min each.*

| # | Title | Concept | Key Topics |
|---|-------|---------|------------|
| 12 | Lifecycle Hooks | Callbacks | `before_validation`, `after_create`, `before_destroy`, callback order |
| 12A ⚠️ | Callbacks Gone Wrong | Anti-pattern | Model uses `after_save` for emails, inventory updates, and total recalculation; specs expose double-fire and ordering bugs; learner extracts to service objects |
| 13 | Checkout Integrity | Transactions | `ActiveRecord::Base.transaction`, rollback on error, `lock!` |
| 14 | Audit Trail | Callbacks + dirty tracking | `after_save`, `saved_change_to?`, `previous_changes` |
| 15 | Find-or-Create Patterns | `find_or_*` family | `find_or_create_by`, `find_or_initialize_by`, `create_or_find_by` — happy paths and when to reach for each |
| 15A ⚠️ | The Race in `find_or_create_by` | Anti-pattern | Missing unique index causes silent duplicates under concurrency; learner reproduces the race, then adds the unique index and handles the rescue |

---

## Phase 5: Advanced Modeling
*Growing app begins (from solved-through-15A starter repo). Specs only. Some assignments split into parts. 15–25 min each.*

| # | Title | Concept | Key Topics |
|---|-------|---------|------------|
| 16 | Product Variants (Part 1) | Enums | Integer vs string-backed, enum scopes, `!` / `?` helpers |
| 17 | Product Variants (Part 2) | STI | Single table inheritance, subclasses, type column, when STI breaks down |
| 18 | Flexible Discounts | Polymorphic associations | `belongs_to :discountable, polymorphic: true`, querying across types |
| 19 | Product Reviews | Polymorphic associations II | Reusing a polymorphic model (`reviewable`), inverse associations |
| 20 | Referred Customers | Self-referential associations | `belongs_to :referrer`, `has_many :referrals`, recursive queries |
| 21 | Category Trees | Self-referential associations II | Parent/child categories, depth-limited queries |
| 22 | Composite Keys | Composite primary keys | `query_constraints`, `find` with composite keys, Rails 7.1+ config |

---

## Phase 6: Security & Encryption
*Growing app. Specs only. 20–25 min each.*

| # | Title | Concept | Key Topics |
|---|-------|---------|------------|
| 23 | Protecting Customer Data | AR Encryption | `encrypts`, deterministic vs non-deterministic, querying encrypted fields |
| 24 | SQL Injection & Safe Queries | Query security | String interpolation danger, parameterized queries, `sanitize_sql` |
| 24A ⚠️ | Unsafe Queries | Anti-pattern | Working but SQL-injectable `where` clause; learner writes a spec demonstrating the injection, then fixes it |

---

## Phase 7: Advanced SQL Techniques
*Growing app. Specs only. 20–30 min each. Several split into parts.*

| # | Title | Concept | Key Topics |
|---|-------|---------|------------|
| 25 | Raw SQL & When to Use It | `find_by_sql`, `select_all`, `execute` | When AR falls short, `annotate` for query logging, sanitizing inputs |
| 26 | Subqueries in `WHERE` (Part 1) | Correlated subqueries | Subquery in `where`, single-query vs two-query pattern, performance implications |
| 26A ⚠️ | The Two-Query Trap | Anti-pattern | Working solution fires two DB round-trips; learner identifies the race condition risk and rewrites as a single subquery |
| 27 | Subqueries in `SELECT` & `HAVING` (Part 2) | Scalar & aggregate subqueries | Computed columns via subquery, `HAVING` with subquery, `exists?` |
| 28 | Derived Tables with `from` | `from` clause | Using a query as a table, aliasing, combining with AR scopes |
| 29 | CTEs with `.with` | Common Table Expressions | Rails 7.1+ `.with`, named CTEs, chaining CTEs, when to prefer over subqueries |
| 29A ⚠️ | CTE Overuse | Anti-pattern | A trivial query wrapped in an unnecessary CTE; learner recognises when a simple scope is more readable and refactors |
| 30 | Recursive CTEs | Hierarchical queries | `WITH RECURSIVE`, category tree traversal, depth limiting |
| 31 | Window Functions (Part 1) | Ranking & numbering | `RANK()`, `ROW_NUMBER()`, `DENSE_RANK()`, `OVER (PARTITION BY ...)` via `select` |
| 32 | Window Functions (Part 2) | Running aggregates | `SUM() OVER`, `AVG() OVER`, `LAG()` / `LEAD()`, order-of-sales reports |
| 33 | UNIONs & Set Operations | Combining result sets | `UNION`, `UNION ALL`, `INTERSECT`, `EXCEPT`, wrapping in AR |
| 34 | Database Views | Views as AR models | `CREATE VIEW` in migrations, querying a view-backed model, read-only models |
| 35 | Arel: Building Query Objects (Part 1) | Arel basics | `Arel::Table`, `project`, `where`, composing reusable query objects |
| 36 | Arel: Building Query Objects (Part 2) | Arel advanced | Subqueries in Arel, `exists?`, composing with named scopes, `optimizer_hints` |

---

## Phase 8: Concurrency & Locking
*Growing app. Specs only. Up to 30 min each.*

| # | Title | Concept | Key Topics |
|---|-------|---------|------------|
| 37 | Race Conditions in the Cart | Optimistic locking | `lock_version`, `StaleObjectError`, retry patterns |
| 38 | Inventory Reservation | Pessimistic locking | `with_lock`, `lock!`, `FOR UPDATE`, deadlock awareness |
| 39 | Locking Capstone | Combined locking | Given a spec reproducing a race condition, make it safe |

---

## Phase 9: Multi-Tenancy & Multiple Databases
*Growing app. Specs only. Up to 30 min each.*

| # | Title | Concept | Key Topics |
|---|-------|---------|------------|
| 40 ⚠️ | Scoping by Tenant | Multi-tenancy basics / anti-pattern revisit | `default_scope` with tenant (and why it's still a trap), `ActsAsTenant` pattern |
| 41 | Tenant Isolation | Multi-tenancy safety | Preventing cross-tenant queries, `around_action` pattern, testing leakage |
| 42 | Read Replicas | Multiple databases | `connects_to`, `connected_to`, read vs write roles, Rails 7.2 config |
| 43 | Sharding the Catalog | Horizontal sharding | Shard keys, `connected_to(shard:)`, limitations and tradeoffs |

---

## Phase 10: Performance Capstone
*Growing app. Specs only. Up to 30 min each. Deliberately the hardest assignments.*

| # | Title | Concept | Key Topics |
|---|-------|---------|------------|
| 44 | Indexing the Store | Indexes | Composite indexes, partial indexes, `explain`, index bloat |
| 45 | Bulk Operations | Batch processing | `find_each`, `insert_all`, `upsert_all`, `find_in_batches` |
| 46 | Capstone: The Slow Store | Full AR performance | Intentional N+1s, missing indexes, unsafe queries, `strict_loading` — make it all green and fast |

---

## Anti-Pattern Assignments Summary

| Assignment | Anti-Pattern | Why It's Harmful |
|---|---|---|
| 06A | `has_and_belongs_to_many` | Can't add data to the join table; painted into a corner |
| 07A | `default_scope` | Invisible query modification, ordering surprises, leaks into associations |
| 12A | Business logic in callbacks | Double-fire bugs, hidden execution order, difficult to test in isolation |
| 15A | `find_or_create_by` without unique index | Silent race condition in production |
| 24A | String interpolation in `where` | SQL injection vector |
| 26A | Two-query pattern | Race condition risk and unnecessary DB round-trip |
| 29A | CTE overuse | Unnecessary complexity where a simple scope would do |
| 40 | `default_scope` for tenancy | Revisits the anti-pattern in a new, higher-stakes context |

---

## Progression Summary

| Phase | Assignments | Scaffolding | Time per Assignment |
|-------|-------------|-------------|---------------------|
| 1–2: Foundations & Associations | 01–06A | Specs + README hints | 10–20 min |
| 3: Advanced Queries | 07–11 | Hints fading (07–09), then specs only | 10–20 min |
| 4: Callbacks & Transactions | 12–15A | Specs only | 10–20 min |
| 5: Advanced Modeling | 16–22 | Specs only | 15–25 min |
| 6: Security & Encryption | 23–24A | Specs only | 20–25 min |
| 7: Advanced SQL Techniques | 25–36 | Specs only | 20–30 min |
| 8: Concurrency & Locking | 37–39 | Specs only | 20–30 min |
| 9: Multi-Tenancy & Multiple Databases | 40–43 | Specs only | 20–30 min |
| 10: Performance Capstone | 44–46 | Specs only | 20–30 min |

**47 assignments total** (including 8 dedicated anti-pattern assignments).
