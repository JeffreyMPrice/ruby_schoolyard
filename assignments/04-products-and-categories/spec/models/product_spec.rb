require "rails_helper"

RSpec.describe Product, type: :model do
  describe "associations" do
    describe "#category" do
      it "returns the category this product belongs to" do
        category = create(:category)
        product  = create(:product, category_id: category.id)

        expect(product.category).to eq(category),
          "Expected product.category to return the associated Category. " \
          "Add `belongs_to :category` to Product."
      end
    end
  end
end
