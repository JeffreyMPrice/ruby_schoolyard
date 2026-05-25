# Assignment 01 — Building the Schema

## Getting started

```bash
bundle install
bundle exec rspec
```

You should see **12 failures**. That's the goal — your job is to write migrations that
make them all pass.

---

## What you're learning

Migrations are how Rails manages your database structure. Instead of writing raw SQL,
you describe your schema in Ruby and Rails translates it — and keeps a history you can
roll forward or backward.

---

## Key concepts

### Column types

Common types you'll use in this assignment:

| Rails type | Use it for |
|------------|------------|
| `string`   | Short text (names, titles) — default limit 255 |
| `text`     | Long text (descriptions, notes) |
| `decimal`  | Exact monetary values — use `precision:` and `scale:` |
| `integer`  | Whole numbers |

### Preventing nulls

Pass `null: false` to a column to enforce a NOT NULL constraint at the database level.
This is different from a model validation — the database will reject the row even if you
bypass the model entirely.

```ruby
t.string :name, null: false
```

### Defaults

Use `default:` to set a value the database will fill in when none is provided.

```ruby
t.integer :stock_count, null: false, default: 0
```

### Adding indexes

Indexes speed up queries that filter or sort on a column. Add them inline or explicitly:

```ruby
# Inline — convenient for simple cases
t.decimal :price, precision: 10, scale: 2, null: false, index: true

# Explicit — more options available, e.g. unique
add_index :categories, :name, unique: true
```

### Rolling back

Every migration should be reversible. Rails can undo a `create_table` automatically.
To verify your migrations are clean in both directions:

```bash
rails db:migrate:redo
```

---

## Worked example

Here's what a complete migration looks like for a **different domain** — a blog. Use this
as a model for your own migrations, not as something to copy directly.

```ruby
# db/migrate/20240101000000_create_authors.rb
class CreateAuthors < ActiveRecord::Migration[7.2]
  def change
    create_table :authors do |t|
      t.string  :name,     null: false
      t.string  :email,    null: false
      t.text    :bio
      t.integer :post_count, null: false, default: 0

      t.timestamps
    end

    add_index :authors, :email, unique: true
  end
end
```

To generate a migration file with the right name and timestamp automatically:

```bash
rails generate migration CreateAuthors
```

Rails creates the file in `db/migrate/` — you then fill in the columns.

---

## Relevant docs

- [Active Record Migrations guide](https://guides.rubyonrails.org/active_record_migrations.html)
- [Column type reference](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/TableDefinition.html)

---

## Your task

The specs in `spec/models/` tell you exactly what schema is required. Read them — each
`it` block is one thing the database must have.

**Workflow:**

```bash
# See all failures
bundle exec rspec

# Write your migration(s) in db/migrate/
rails generate migration CreateProducts
rails generate migration CreateCategories

# Apply them
rails db:migrate

# Run the specs — fix anything still failing
bundle exec rspec
```

**You're done when:** `bundle exec rspec` reports 12 examples, 0 failures.

**Bonus:** run `rails db:migrate:redo` to confirm your migrations roll back cleanly.
