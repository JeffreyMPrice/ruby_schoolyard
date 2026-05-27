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

  describe "querying by association presence" do
    describe ".where.associated(:category)" do
      it "returns only products that have a category assigned" do
        category           = create(:category)
        with_category      = create(:product, category_id: category.id)
        _without_category  = create(:product)  # category_id is nil

        result = Product.where.associated(:category)

        expect(result).to contain_exactly(with_category),
          "Expected Product.where.associated(:category) to return only products " \
          "with a category. Make sure `belongs_to :category` is declared on Product."
      end
    end

    describe ".where.missing(:category)" do
      it "returns only products that have no category assigned" do
        category          = create(:category)
        _with_category    = create(:product, category_id: category.id)
        without_category  = create(:product)  # category_id is nil

        result = Product.where.missing(:category)

        expect(result).to contain_exactly(without_category),
          "Expected Product.where.missing(:category) to return only products " \
          "without a category. Make sure `belongs_to :category` is declared on Product."
      end
    end
  end
end
