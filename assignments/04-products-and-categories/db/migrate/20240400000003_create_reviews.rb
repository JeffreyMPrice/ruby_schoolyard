class CreateReviews < ActiveRecord::Migration[7.2]
  def change
    create_table :reviews do |t|
      # Intentionally nullable: reviews may exist without a product,
      # which lets us demonstrate where.missing(:product) in the specs.
      t.integer :product_id
      t.text    :body, null: false

      t.timestamps
    end

    add_index :reviews, :product_id
  end
end
