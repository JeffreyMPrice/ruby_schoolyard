require "rails_helper"

RSpec.describe Category, type: :model do
  describe "validations" do
    it "is invalid without a name" do
      category = build(:category, name: "")
      category.valid?
      expect(category.errors[:name]).not_to be_empty
    end

    it "is invalid with a duplicate name" do
      create(:category, name: "Electronics")
      duplicate = build(:category, name: "Electronics")
      duplicate.valid?
      expect(duplicate.errors[:name]).not_to be_empty
    end
  end
end
