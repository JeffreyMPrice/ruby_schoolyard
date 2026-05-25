# Spec Generation Prompt

Use this prompt to generate a failing RSpec test suite for any assignment in the ActiveRecord curriculum. Fill in the bracketed values before sending.

---

## The Prompt

```
You are a senior Ruby on Rails 7.2 engineer creating a failing RSpec test suite for a
junior developer to make pass. The assignment is part of a progressive ActiveRecord
curriculum built around an e-commerce domain (products, categories, orders, line items,
users, reviews).

## Assignment Details

- Assignment number: [e.g. 07]
- Title: [e.g. Scoping the Catalog]
- Phase: [e.g. Phase 3: Advanced Queries]
- Core concept: [e.g. Named scopes, scope chaining, lambda scopes with arguments, the `none` null relation]
- Is this an anti-pattern assignment? [yes / no]
  - If yes, describe the anti-pattern: [e.g. A model has a default_scope that causes
    hidden ordering and filtering bugs. The learner must write specs that expose each
    problem, then refactor to named scopes.]

## Scaffolding Level

[Choose one:]
- FULL HINTS: Include a README.md with a clear explanation of the concept, links to
  relevant Rails docs, and a worked example using a different model/domain.
- HINTS FADING: Include a README.md with a brief concept description and doc links only.
  No worked example.
- NO HINTS: Specs only. No README. The learner must read the specs and figure it out.

## Structural Requirements

1. Produce a Rails 7.2 app structure with:
   - **Database: SQLite** (the `sqlite3` gem). Prefer SQLite-supported syntax. If the assignment touches a feature SQLite cannot fully enforce (e.g. `FOR UPDATE` row locking on assignment 38, real read replicas on 42, true sharding on 43), call that out in the teacher notes — the Rails-side config and code are still real and testable.
   - **Migrations:**
     - Phases 1–4 (isolated mini-app): produce the full schema needed for this assignment via migration file(s).
     - Phase 5+ (growing app): produce ONLY the new migration(s) this assignment introduces. Do NOT regenerate `db/schema.rb` or restate prior migrations — assume the learner is starting from the solved-through-15A starter repo (or the end state of the previous assignment).
   - app/models/ with any model files needed (empty or skeleton — NO implementation of the concept under test)
   - spec/models/ (and/or spec/requests/ if appropriate) with the failing specs
   - Gemfile with rails 7.2, sqlite3, rspec-rails, factory_bot_rails, faker, and database_cleaner-active_record
   - If scaffolding level is FULL HINTS or HINTS FADING: a README.md

2. Model files must contain:
   - The class definition inheriting from ApplicationRecord
   - Any associations, validations, or other declarations that are GIVEN (i.e. not the
     thing being tested) — so the learner focuses only on the concept under test
   - NO implementation of the thing being tested (that's what the learner writes)

3. Specs must:
   - Use RSpec with FactoryBot for test data
   - Be written so that ALL specs fail before the learner writes any code
   - Each spec should test ONE clear behaviour
   - Use descriptive `describe` / `context` / `it` blocks that read as documentation
   - For anti-pattern assignments: include at least one spec that demonstrates the
     harmful behaviour of the anti-pattern BEFORE the fix, and separate specs that
     verify the correct behaviour AFTER the fix
   - Include a spec/rails_helper.rb and spec/spec_helper.rb appropriate for Rails 7.2
   - Use DatabaseCleaner with the transaction strategy

4. Factories:
   - Place in spec/factories/
   - Use Faker for realistic e-commerce data
   - Keep factories minimal — only what the specs need

5. Difficulty calibration:
   - The learner should be able to make all specs pass in [10–20 / 15–25 / 20–30] minutes
   - Do not add extra concepts beyond what is listed in "Core concept" above

## Output Format

Produce each file as a clearly labelled code block with its path as the heading.
For example:

### db/migrate/20240101000001_create_products.rb
```ruby
# migration code here
```

### app/models/product.rb
```ruby
# model skeleton here
```

### spec/models/product_spec.rb
```ruby
# failing specs here
```

Also produce a file `.teacher_notes.md` in the assignment root containing a section
"## What the Learner Needs to Do" — plain English describing exactly what code the learner
must write to make the specs pass, without giving away the implementation. For
anti-pattern assignments, also note which specs demonstrate the broken behaviour vs which
verify the fix. If the assignment touches a SQLite-degenerate feature (see Structural
Requirements #1), call that out here too.
This file is for the teacher/reviewer. Do NOT duplicate its content in the README.
```

---

## Usage Notes

### Choosing the scaffolding level

| Phase | Assignment numbers | Scaffolding level |
|-------|-------------------|-------------------|
| 1–2 | 01–06A | FULL HINTS |
| 3–4 early | 07–09 | HINTS FADING |
| 3–4 late onwards | 10–46 | NO HINTS |

### Customising for anti-pattern assignments

For anti-pattern assignments (06A, 07A, 12A, 15A, 24A, 26A, 29A, 40), add this block to
the prompt after "Is this an anti-pattern assignment?":

```
The model/code file should be PRE-WRITTEN with the anti-pattern already in place.
The spec suite should have two sections:
1. "Demonstrating the problem" — specs that PASS with the broken code, showing the
   harmful behaviour in action (these should become irrelevant after the fix)
2. "After the fix" — specs that FAIL with the broken code and must PASS after the
   learner refactors it

Include a comment at the top of the model file:
# TODO: This code contains an intentional anti-pattern. Read the specs carefully,
# understand why the current implementation is problematic, then refactor it.
```

### Chaining assignments in the growing app (Phase 5 onwards)

From Phase 5 onwards, assignments build on the same Rails app. The Phase 5 starting state
is the "solved-through-15A" starter repo (all completed Phase 1–4 work, schema and specs).
Each new assignment in Phase 5+ adds only new migration(s), model files, and specs on top
of this state. When generating a new assignment, include this context block:

```
## Prior App State

This assignment builds on the growing e-commerce app. The following models, migrations,
and associations are already in place from previous assignments:

[Paste a brief summary of existing models and their key attributes/associations here,
e.g.:]
- Product (name:string, price:decimal, status:integer [enum], category_id:integer)
  - belongs_to :category
  - has_many :line_items
- Category (name:string, parent_id:integer)
- Order (user_id:integer, status:integer [enum], total:decimal)
  - belongs_to :user
  - has_many :line_items
- LineItem (order_id:integer, product_id:integer, quantity:integer, unit_price:decimal)
  - belongs_to :order
  - belongs_to :product
- User (email:string, password_digest:string)
  - has_many :orders

Do not regenerate these. Only produce the new migration(s), model changes, and specs
needed for this assignment.
```

### Time calibration reference

| Phase | Target time | Complexity guidance |
|-------|-------------|---------------------|
| 1–4 | 10–20 min | 4–8 specs, one focused concept |
| 5 | 15–25 min | 6–10 specs, may span two related concepts |
| 6 | 20–25 min | 6–10 specs, security-focused (encryption, injection) |
| 7–10 | 20–30 min | 8–14 specs, integration of multiple AR features |
