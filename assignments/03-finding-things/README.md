# Assignment 03 — Finding Things

## Getting started

```bash
bundle install
bundle exec rspec
```

You should see **10 failures**. Your job is to implement class methods on `Product`
that make them all pass.

The database table is already created — you don't need to write any migrations.

---

## What you're learning

ActiveRecord gives you a rich query API for fetching records from the database.
Rather than writing raw SQL, you call Ruby methods that build and execute queries
for you.

In this assignment you'll implement class methods on `Product`, each using a
specific ActiveRecord query method internally. The method names are yours to fill
in — read the specs to see exactly what each one should do.

---

## Key concepts

### `find` — fetch by primary key, raise on miss

`find` returns the record with the given id. If no record exists, it raises
`ActiveRecord::RecordNotFound`. Use `find` when a missing record is a bug — for
example, when you're looking up a record by an id from a URL.

```ruby
Product.find(1)      # => #<Product id: 1, ...>
Product.find(9999)   # => raises ActiveRecord::RecordNotFound
```

### `find_by` — fetch by any attribute, return nil on miss

`find_by` returns the first record matching the given attributes, or `nil` if
none match. It never raises. Use `find_by` when "not found" is a valid, expected
outcome.

```ruby
Product.find_by(name: "Widget")   # => #<Product ...> or nil
Product.find_by(name: "Ghost")    # => nil
```

### `where` — filter records by condition

`where` returns all records matching a condition as an `ActiveRecord::Relation`.
Always use the `?` placeholder syntax when filtering on values — it prevents
SQL injection.

```ruby
Product.where("price < ?", 50)      # products under $50
Product.where(stock_count: 0)       # out-of-stock products (hash syntax)
```

### `order` — sort the results

`order` specifies the sort column and direction. It returns a relation, so you
can chain it with other methods.

```ruby
Product.order(price: :asc)           # cheapest first
Product.order(price: :desc)          # most expensive first
Product.order(:name)                 # alphabetical (default: asc)
```

### `limit` — cap the number of results

`limit` returns at most n records. Typically chained with `order` so you get
a meaningful "top n".

```ruby
Product.order(price: :desc).limit(3)   # three most expensive
```

### `pluck` — pull a column without loading full records

`pluck` returns a plain Ruby array of column values — it never instantiates
model objects, which makes it faster when you only need the values.

```ruby
Product.pluck(:name)            # => ["Widget", "Gadget", ...]
Product.pluck(:id, :name)       # => [[1, "Widget"], [2, "Gadget"], ...]
```

### `pick` — a single value from a single row

`pick` is the scalar version of `pluck`. Where `pluck` returns an array of
values, `pick` returns just the first one — without instantiating any model
objects. Useful when you need exactly one value and don't want an array wrapper.

```ruby
Product.order(price: :asc).pick(:price)   # => 9.99  (a decimal, not an array)
Product.pluck(:price).first               # same result, but loads all prices first
```

**Prefer `pick` whenever you need a single value.** `pick` issues a `LIMIT 1`
query and returns immediately — the database does the work. `pluck(:price).first`
fetches every price in the table into a Ruby array and then discards all but the
first. On a table with thousands of rows the difference is significant.

### `ids` — shorthand for all primary keys

`ids` is a shortcut for `pluck(:id)`. Returns an array of integer ids.

```ruby
Product.ids                          # => [1, 2, 3, ...]
Product.where("price < ?", 20).ids   # => ids of affordable products
```

---

## Worked example

Here's how these methods might look in a **different domain** — a library app
with `Book` records. Use it as a reference for the pattern, not something to copy.

```ruby
class Book < ApplicationRecord
  # Fetch by id — raise if missing
  def self.fetch(id)
    find(id)
  end

  # Look up by title — return nil if missing
  def self.search_by_title(title)
    find_by(title: title)
  end

  # Books at or under a given price, cheapest first
  def self.under_budget(max_price)
    where("price <= ?", max_price).order(price: :asc)
  end

  # The n most recently published books
  def self.recent(n)
    order(published_at: :desc).limit(n)
  end

  # All titles as a plain Ruby array
  def self.all_titles
    pluck(:title)
  end
end
```

---

## Relevant docs

- [Active Record Query Interface](https://guides.rubyonrails.org/active_record_querying.html)
- [find and find_by](https://guides.rubyonrails.org/active_record_querying.html#retrieving-a-single-object)
- [where conditions](https://guides.rubyonrails.org/active_record_querying.html#conditions)
- [order and limit](https://guides.rubyonrails.org/active_record_querying.html#ordering)
- [pluck and ids](https://guides.rubyonrails.org/active_record_querying.html#pluck)

---

## Your task

Implement eight class methods on `app/models/product.rb`. The spec file tells
you exactly what each method must be named and what it must return. Use one
ActiveRecord query method per implementation — no manual loops over arrays.

**Workflow:**

```bash
# See all failures
bundle exec rspec

# Edit the model
# app/models/product.rb

# Run again — fix anything still failing
bundle exec rspec
```

**You're done when:** `bundle exec rspec` reports 10 examples, 0 failures.
