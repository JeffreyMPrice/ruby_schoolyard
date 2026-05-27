require "rails_helper"

RSpec.describe Product, type: :model do
  describe "validations" do
    it "is invalid without a name and uses a custom error message" do
      product = build(:product, name: nil)
      product.valid?
      expect(product.errors[:name]).to include("is required")
    end

    describe "numericality" do
      subject { build(:product) }

      it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
      it {
        is_expected.to validate_numericality_of(:stock_count)
          .only_integer
          .is_greater_than_or_equal_to(0)
      }
    end

    it "is invalid when description matches the name and adds an error" do
      product = build(:product, name: "Running Shoes", description: "Running Shoes")
      product.valid?
      expect(product.errors[:description]).to include("must differ from the product name")
    end
  end
end
