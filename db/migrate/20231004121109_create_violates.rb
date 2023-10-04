class CreateViolates < ActiveRecord::Migration[6.1]
  def change
    create_table :violates do |t|
      t.integer :reporter, null: false
      t.integer :reported, null: false
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.boolean :checked, default: false, null: false

      t.timestamps
    end
  end
end
