require "rails_helper"

RSpec.describe Review, type: :model do
  describe ".where.associated(:product)" do
    it "returns only reviews that have a product assigned" do
      product          = create(:product)
      with_product     = create(:review, product_id: product.id)
      _without_product = create(:review)

      result = Review.where.associated(:product)

      expect(result).to contain_exactly(with_product),
        "Expected Review.where.associated(:product) to return only reviews " \
        "with a product. Make sure `belongs_to :product, optional: true` is " \
        "declared on Review."
    end
  end

  describe ".where.missing(:product)" do
    it "returns only reviews that have no product assigned" do
      product         = create(:product)
      _with_product   = create(:review, product_id: product.id)
      without_product = create(:review)

      result = Review.where.missing(:product)

      expect(result).to contain_exactly(without_product),
        "Expected Review.where.missing(:product) to return only reviews " \
        "without a product. Make sure `belongs_to :product, optional: true` is " \
        "declared on Review."
    end
  end
end
