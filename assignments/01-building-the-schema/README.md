# Assignment 01 — Building the Schema

## What you're learning

Migrations are how Rails manages your database structure. Instead of writing raw SQL,
you describe your schema in Ruby and Rails translates it — and keeps a history you can
roll forward or backward.

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
# Inline
t.decimal :price, precision: 10, scale: 2, null: false, index: true

# Explicit — more options available, e.g. unique
add_index :categories, :name, unique: true
```

### Rolling back

Every migration should be reversible. Rails can undo a `create_table` automatically.
To test that your migrations are clean in both directions:

```bash
rails db:migrate:redo
```

## Relevant docs

- [Active Record Migrations guide](https://guides.rubyonrails.org/active_record_migrations.html)
- [Column type reference](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/TableDefinition.html)

## Your task

Run the specs — everything will fail because the tables don't exist yet.

```bash
bundle exec rspec
```

Write migrations to make them pass, then run:

```bash
rails db:migrate
bundle exec rspec
```
