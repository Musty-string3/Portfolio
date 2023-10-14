class CreateViolates < ActiveRecord::Migration[6.1]
  def change
    create_table :violates do |t|
      t.integer :reporter_id, null: false
      t.integer :reported_id, null: false
      t.text :text
      t.integer :status, null: false
      t.references :post, null: false, foreign_key: true
      t.boolean :checked, default: false, null: false

      t.timestamps
    end
  end
end
