FactoryBot.define do
  factory :review do
    body { Faker::Lorem.sentence }
    # product_id is nil by default — reviews start orphaned.
    # Use `create(:review, product: my_product)` to assign one.
  end
end
