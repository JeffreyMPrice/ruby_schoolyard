require "rails_helper"

RSpec.describe Product, type: :model do
  describe ".fetch" do
    it "returns the product with the given id" do
      product = create(:product)
      expect(Product.fetch(product.id)).to eq(product)
    end

    it "raises ActiveRecord::RecordNotFound for an unknown id" do
      expect { Product.fetch(0) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe ".search_by_name" do
    it "returns the product with the given name" do
      product = create(:product, name: "Blue Widget")
      expect(Product.search_by_name("Blue Widget")).to eq(product)
    end

    it "returns nil when no product has that name" do
      expect(Product.search_by_name("Ghost Product")).to be_nil
    end
  end

  describe ".affordable" do
    it "returns only products at or below the given price" do
      cheap = create(:product, price: 9.99)
      create(:product, price: 99.99)
      expect(Product.affordable(20.00)).to contain_exactly(cheap)
    end
  end

  describe ".sorted_by_price" do
    it "returns products ordered from cheapest to most expensive" do
      mid    = create(:product, price: 50.00)
      cheap  = create(:product, price: 10.00)
      pricey = create(:product, price: 90.00)
      expect(Product.sorted_by_price).to eq([cheap, mid, pricey])
    end
  end

  describe ".top_priced" do
    it "returns only the n most expensive products" do
      create(:product, price: 10.00)
      silver = create(:product, price: 50.00)
      gold   = create(:product, price: 90.00)
      expect(Product.top_priced(2)).to contain_exactly(silver, gold)
    end
  end

  describe ".all_names" do
    it "returns an array of all product names" do
      create(:product, name: "Gadget")
      create(:product, name: "Widget")
      expect(Product.all_names).to contain_exactly("Gadget", "Widget")
    end
  end

  describe ".all_ids" do
    it "returns an array of all product ids" do
      products = create_list(:product, 3)
      expect(Product.all_ids).to contain_exactly(*products.map(&:id))
    end
  end

  describe ".cheapest_price" do
    it "returns the price of the least expensive product as a single value, not an array" do
      create(:product, price: 9.99)
      create(:product, price: 49.99)
      expect(Product.cheapest_price).to eq(9.99)
    end
  end
end
