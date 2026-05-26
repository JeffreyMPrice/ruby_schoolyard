require "rails_helper"

RSpec.describe Product, type: :model do
  subject { build(:product) }

  describe "validations" do
    context "presence" do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:price) }
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
      it "is invalid when description is identical to the name" do
        product = build(:product, name: "Running Shoes", description: "Running Shoes")
        expect(product).not_to be_valid
      end

      it "adds an error to :description when it matches the name" do
        product = build(:product, name: "Running Shoes", description: "Running Shoes")
        product.valid?
        expect(product.errors[:description]).to include("must differ from the product name")
      end
    end

    context "error messages" do
      it "reports an error on :name when name is blank" do
        product = build(:product, name: "")
        product.valid?
        expect(product.errors[:name]).not_to be_empty
      end
    end
  end
end
