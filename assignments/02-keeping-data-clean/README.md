# Assignment 02 — Keeping Data Clean

## Getting started

```bash
bundle install
bundle exec rspec
```

You should see **10 failures**. Your job is to add validations to the `Product` and
`Category` models that make them all pass.

The database tables are already created — you don't need to write any migrations.

---

## What you're learning

Model validations are the layer between user input and the database. Where a migration
sets hard constraints at the DB level (`null: false`), validations give you expressive,
human-readable rules that generate helpful error messages for users.

Rails provides several built-in validators and an escape hatch — `validate` — for
anything they can't cover.

---

## Key concepts

### Presence

Rejects blank values (nil, empty string, whitespace-only).

```ruby
validates :name, presence: true
```

### Uniqueness

Rejects records where another row already has the same value.

```ruby
validates :name, uniqueness: true
```

### Numericality

Validates that a value is a number and optionally applies constraints.

```ruby
validates :price, numericality: { greater_than: 0 }
validates :stock_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
```

### Custom validators

When built-in validators aren't enough, write a method and declare it with `validate`.
Call `errors.add` to record a problem.

```ruby
validate :name_must_not_be_generic

private

def name_must_not_be_generic
  return unless name.present?
  if name.downcase == "product"
    errors.add(:name, "must be more specific than 'product'")
  end
end
```

### The errors object

After calling `valid?` (or attempting to save), `errors` holds the validation results.

```ruby
product = Product.new(name: "")
product.valid?               # => false
product.errors[:name]        # => ["can't be blank"]
product.errors.full_messages # => ["Name can't be blank"]
```

---

## Worked example

Here's a fully validated model from a **different domain** — a blog. Use it as a
reference for how validations are structured, not as something to copy.

```ruby
class Post < ApplicationRecord
  validates :title,      presence: true
  validates :title,      uniqueness: true
  validates :view_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validate :slug_format

  private

  def slug_format
    return unless slug.present?
    unless slug.match?(/\A[a-z0-9-]+\z/)
      errors.add(:slug, "may only contain lowercase letters, numbers, and hyphens")
    end
  end
end
```

---

## Relevant docs

- [Active Record Validations guide](https://guides.rubyonrails.org/active_record_validations.html)
- [Validation helpers reference](https://guides.rubyonrails.org/active_record_validations.html#validation-helpers)
- [Custom validation methods](https://guides.rubyonrails.org/active_record_validations.html#validate)

---

## Your task

Add validations to `app/models/product.rb` and `app/models/category.rb` until all specs
pass. Read the spec files — each `it` block tells you exactly what behaviour is required.

**Workflow:**

```bash
# See all failures
bundle exec rspec

# Edit your models
# app/models/product.rb
# app/models/category.rb

# Run again — fix anything still failing
bundle exec rspec
```

**You're done when:** `bundle exec rspec` reports 10 examples, 0 failures.
