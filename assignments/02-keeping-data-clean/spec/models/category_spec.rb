require "rails_helper"

RSpec.describe Category, type: :model do
  subject { build(:category) }

  describe "validations" do
    context "presence" do
      it { is_expected.to validate_presence_of(:name) }
    end

    context "uniqueness" do
      it { is_expected.to validate_uniqueness_of(:name) }

      it "adds an error on :name when the name is already taken" do
        create(:category, name: "Electronics")
        duplicate = build(:category, name: "Electronics")
        duplicate.valid?
        expect(duplicate.errors[:name]).to include("has already been taken")
      end
    end
  end
end
