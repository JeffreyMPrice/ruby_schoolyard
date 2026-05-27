require "rails_helper"

RSpec.describe Category, type: :model do
  describe "database schema" do
    describe "column types" do
      it { is_expected.to have_db_column(:name).of_type(:string) }
    end

    describe "null constraints" do
      it { is_expected.to have_db_column(:name).with_options(null: false) }
    end

    describe "indexes" do
      it { is_expected.to have_db_index(:name).unique(true) }
    end
  end
end
