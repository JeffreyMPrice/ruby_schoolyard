require "rails_helper"

RSpec.describe Category, type: :model do
  describe "database schema" do
    context "column types" do
      it { is_expected.to have_db_column(:name).of_type(:string) }
    end

    context "null constraints" do
      it { is_expected.to have_db_column(:name).with_options(null: false) }
    end

    context "indexes" do
      it { is_expected.to have_db_index(:name).unique(true) }
    end
  end
end
