require "rails_helper"

RSpec.describe Category, type: :model do
  describe "validations" do
    it "is invalid without a name" do
      category = build(:category, name: "")
      expect(category).not_to be_valid
    end

    it "is invalid with a duplicate name" do
      create(:category, name: "Electronics")
      duplicate = build(:category, name: "Electronics")
      expect(duplicate).not_to be_valid
    end
  end
end
