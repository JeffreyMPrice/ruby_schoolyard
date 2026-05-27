require "rails_helper"

RSpec.describe Category, type: :model do
  describe "associations" do
    describe "#products" do
      it "returns all products associated with the category" do
        category = create(:category)
        p1 = create(:product, category_id: category.id)
        p2 = create(:product, category_id: category.id)
        create(:product)  # belongs to no category — should not appear

        expect(category.products).to contain_exactly(p1, p2),
          "Expected category.products to return the category's products. " \
          "Add `has_many :products` to Category."
      end
    end

    describe "dependent: :destroy" do
      it "destroys associated products when the category is deleted" do
        category = create(:category)
        p1 = create(:product, category_id: category.id)
        p2 = create(:product, category_id: category.id)

        expect { category.destroy }
          .to change(Product, :count).by(-2),
          "Expected deleting a category to also delete its products. " \
          "Add `dependent: :destroy` to the has_many :products declaration on Category."

        expect(Product.exists?(p1.id)).to be(false)
        expect(Product.exists?(p2.id)).to be(false)
      end
    end
  end
end
