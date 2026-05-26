require "rails_helper"

RSpec.describe Category, type: :model do
  describe "validations" do
    it "is invalid without a name and reports the default error" do
      category = build(:category, name: "")
      aggregate_failures do
        expect(category).not_to be_valid
        expect(category.errors[:name]).to include("can't be blank")
      end
    end

    it "is invalid with a duplicate name and reports an error" do
      create(:category, name: "Electronics")
      duplicate = build(:category, name: "Electronics")
      aggregate_failures do
        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:name]).to include("has already been taken")
      end
    end
  end
end
