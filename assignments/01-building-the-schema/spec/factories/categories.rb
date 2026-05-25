FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "#{Faker::Commerce.department(num: 1)} #{n}" }
  end
end
