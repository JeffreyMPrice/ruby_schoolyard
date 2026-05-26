require "rails_helper"

RSpec.describe Product, type: :model do
  subject { build(:product) }

  describe "validations" do
    context "presence" do
      it "is invalid without a name and uses a custom error message" do
        product = build(:product, name: nil)
        product.valid?
        expect(product.errors[:name]).to include("is required")
      end
    end

    context "numericality" do
      it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
      it {
        is_expected.to validate_numericality_of(:stock_count)
          .only_integer
          .is_greater_than_or_equal_to(0)
      }
    end

    context "custom: description must differ from name" do
      it "is invalid when description matches the name and adds an error" do
        product = build(:product, name: "Running Shoes", description: "Running Shoes")
        product.valid?
        expect(product.errors[:description]).to include("must differ from the product name")
      end
    end
  end
end
