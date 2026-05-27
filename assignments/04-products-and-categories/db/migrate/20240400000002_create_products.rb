class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string  :name,        null: false
      t.text    :description
      t.decimal :price,       precision: 10, scale: 2, null: false
      t.integer :stock_count, null: false, default: 0
      # Intentionally nullable: products may exist without a category,
      # which lets us demonstrate where.missing(:category) in the specs.
      t.integer :category_id

      t.timestamps
    end

    add_index :products, :category_id
  end
end
