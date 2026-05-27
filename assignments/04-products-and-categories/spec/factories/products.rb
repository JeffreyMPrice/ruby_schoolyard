FactoryBot.define do
  factory :product do
    name        { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
    price       { Faker::Commerce.price(range: 1.0..500.0) }
    stock_count { Faker::Number.between(from: 0, to: 100) }
    # category_id is nil by default — products start uncategorised.
    # Use `create(:product, category: my_category)` to assign one.
  end
end
