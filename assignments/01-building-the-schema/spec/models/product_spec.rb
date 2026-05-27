require "rails_helper"

RSpec.describe Product, type: :model do
  describe "database schema" do
    describe "column types" do
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_column(:description).of_type(:text) }
      it { is_expected.to have_db_column(:price).of_type(:decimal) }
      it { is_expected.to have_db_column(:stock_count).of_type(:integer) }
    end

    describe "null constraints" do
      it { is_expected.to have_db_column(:name).with_options(null: false) }
      it { is_expected.to have_db_column(:price).with_options(null: false) }
      it { is_expected.to have_db_column(:stock_count).with_options(null: false) }
    end

    describe "defaults" do
      it { is_expected.to have_db_column(:stock_count).with_options(default: 0) }
    end

    describe "indexes" do
      it { is_expected.to have_db_index(:price) }
    end
  end
end
