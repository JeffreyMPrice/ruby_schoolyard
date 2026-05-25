# Ruby Schoolyard

A progressive, test-driven ActiveRecord curriculum for junior developers joining a Ruby on
Rails 7.2 project. Each assignment is a failing RSpec test suite you make pass.

---

## Prerequisites

- Ruby 3.1+ (check with `ruby -v`)
- Bundler 2+ (check with `bundle -v`)
- Git

No database server needed — every assignment uses SQLite, which is bundled with macOS
and most Linux distributions.

---

## How the curriculum works

There are 47 assignments across 10 phases, starting with migrations and ending with
database performance. See [`activerecord_curriculum.md`](activerecord_curriculum.md) for
the full list.

| Phase | Topic | Scaffolding |
|-------|-------|-------------|
| 1–2 | Foundations & Associations | Specs + README hints |
| 3 | Advanced Queries | Brief hints fading out |
| 4–10 | Queries through Performance | Specs only |

Assignments marked **⚠️** contain intentionally broken code. Your job is to identify the
problem, write specs that expose it, then fix it.

---

## Working through an assignment

Every assignment follows the same loop:

```
1. cd into the assignment directory
2. bundle install
3. bundle exec rspec          ← everything fails
4. read the specs + README
5. write the code
6. rails db:migrate           ← if you wrote migrations
7. bundle exec rspec          ← make it green
```

### Step by step

```bash
# 1. Move into the assignment
cd assignments/01-building-the-schema

# 2. Install gems (only needed once per assignment)
bundle install

# 3. Run the specs — they should all fail
bundle exec rspec

# 4. Read the failing specs and the README, then write your code

# 5. If the assignment involves migrations, run them
rails db:migrate

# 6. Run the specs again until they all pass
bundle exec rspec
```

### Useful commands while you work

| Command | What it does |
|---------|-------------|
| `bundle exec rspec` | Run the full suite |
| `bundle exec rspec spec/models/product_spec.rb` | Run one file |
| `bundle exec rspec spec/models/product_spec.rb:6` | Run one example by line number |
| `rails db:migrate` | Apply pending migrations |
| `rails db:rollback` | Undo the last migration |
| `rails db:migrate:redo` | Roll back then re-apply the last migration |
| `rails db:schema:dump` | Regenerate db/schema.rb from the live database |

---

## Getting unstuck

- Re-read the README inside the assignment — Phases 1–2 include concept explanations and
  a worked example.
- Check the [Rails Guides](https://guides.rubyonrails.org/active_record_basics.html).
- Solutions are in a gated reference repo, one branch per assignment
  (e.g. `solution/01-building-the-schema`). Ask your instructor for access.
