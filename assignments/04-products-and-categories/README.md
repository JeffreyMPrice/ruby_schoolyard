# Assignment 04 — Products and Categories

## Getting started

```bash
bundle install
bundle exec rspec
```

You should see **5 failures**. Your job is to add association declarations to
`Category`, `Product`, and `Review` that make them all pass.

---

## What you're learning

Rails associations let two models talk to each other through a foreign key in the
database. Once you declare an association in the model file, Rails generates
helper methods automatically — no SQL required.

In this assignment you'll wire up two **one-to-many** relationships: one category
has many products (each product belongs to one category), and one product has
many reviews (each review optionally belongs to one product).

---

## Key concepts

### `belongs_to` — the model that owns the foreign key

The `products` table has a `category_id` column. The model on the *many* side of
the relationship (Product) declares `belongs_to`:

```ruby
class Product < ApplicationRecord
  belongs_to :category
end
```

After this declaration, every `Product` instance gains a `#category` reader that
fetches the associated Category record.

```ruby
product.category        # => #<Category id: 3, name: "Electronics">
product.category_id     # => 3
```

Any `belongs_to` declaration also makes `where.associated` and `where.missing`
available for querying by association presence (see below).

### `has_many` — the model on the one side

The Category model declares `has_many` to get access to its collection of products:

```ruby
class Category < ApplicationRecord
  has_many :products
end
```

After this, every `Category` instance gains a `#products` reader:

```ruby
category.products       # => an ActiveRecord::Relation of Product records
category.products.count # => 12
```

### `dependent: :destroy`

By default, if you delete a category, its products are left in the database with
an orphaned `category_id`. Adding `dependent: :destroy` tells Rails to delete all
associated products when the category is destroyed:

```ruby
class Category < ApplicationRecord
  has_many :products, dependent: :destroy
end
```

Use this when the child records (products) have no meaning without the parent.

### `optional: true`

Rails 5+ requires `belongs_to` associations by default — if you try to save a
record with a nil foreign key, Rails will raise a validation error. When the
foreign key is intentionally nullable (as with `reviews.product_id`), you need
to opt out:

```ruby
class Review < ApplicationRecord
  belongs_to :product, optional: true
end
```

Without `optional: true`, creating a review without a product would fail
validation even though the database allows it.

### `where.associated` and `where.missing`

Once `belongs_to :product, optional: true` is declared on Review, ActiveRecord
can filter reviews by whether they have a product assigned:

```ruby
# Only reviews that have a product
Review.where.associated(:product)

# Only reviews that have no product (product_id is NULL)
Review.where.missing(:product)
```

These methods join against the association and produce clean SQL — no manual
`WHERE product_id IS NULL` needed.

---

## Worked example

Here's how the same pattern looks in a **different domain** — a library app with
`Author` and `Book` records. Use it as a reference for the shape of the code, not
something to copy.

```ruby
# db/migrate/..._create_authors.rb
create_table :authors do |t|
  t.string :name, null: false
  t.timestamps
end

# db/migrate/..._create_books.rb
create_table :books do |t|
  t.string  :title,     null: false
  t.integer :author_id            # nullable — some books have unknown authors
  t.timestamps
end

# app/models/author.rb
class Author < ApplicationRecord
  has_many :books, dependent: :destroy
end

# app/models/book.rb
class Book < ApplicationRecord
  belongs_to :author, optional: true  # author_id is nullable
end
```

With this in place you can:

```ruby
author = Author.find(1)
author.books                        # => all books by this author

book = Book.find(42)
book.author                         # => the author record

# Books with a known author
Book.where.associated(:author)

# Books with no author on record
Book.where.missing(:author)

# Deleting an author destroys all their books too
author.destroy
```

---

## Relevant docs

- [Active Record Associations — Overview](https://guides.rubyonrails.org/association_basics.html)
- [belongs_to](https://guides.rubyonrails.org/association_basics.html#the-belongs-to-association)
- [has_many](https://guides.rubyonrails.org/association_basics.html#the-has-many-association)
- [dependent: :destroy](https://guides.rubyonrails.org/association_basics.html#dependent)
- [where.associated and where.missing](https://guides.rubyonrails.org/active_record_querying.html#querying-with-associations)

---

## Your task

You need to add association declarations to three model files:

**`app/models/product.rb`** — add one line:
- `belongs_to :category`

**`app/models/category.rb`** — add one line with an option:
- `has_many :products, dependent: :destroy`

**`app/models/review.rb`** — add one line:
- `belongs_to :product, optional: true`

That's it. No new methods, no migrations, no SQL.

**Workflow:**

```bash
# See all failures
bundle exec rspec

# Edit the models
# app/models/product.rb
# app/models/category.rb
# app/models/review.rb

# Run again after each change — watch specs go green one group at a time
bundle exec rspec
```

**You're done when:** `bundle exec rspec` reports 5 examples, 0 failures.
