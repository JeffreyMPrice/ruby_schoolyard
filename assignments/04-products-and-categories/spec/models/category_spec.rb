require "rails_helper"

RSpec.describe Category, type: :model do
  describe "#products" do
    it "returns all products associated with the category" do
      category = create(:category)
      p1 = create(:product, category_id: category.id)
      p2 = create(:product, category_id: category.id)
      _unowned = create(:product)

      expect(category.products).to contain_exactly(p1, p2),
        "Expected category.products to return the category's products. " \
        "Add `has_many :products` to Category."
    end
  end

  describe "#destroy" do
    it "deletes associated products when the category is destroyed" do
      category = create(:category)
      create(:product, category_id: category.id)
      create(:product, category_id: category.id)

      expect { category.destroy }
        .to change(Product, :count).by(-2),
        "Expected deleting a category to also delete its products. " \
        "Add `dependent: :destroy` to the has_many :products declaration on Category."
    end
  end
end
