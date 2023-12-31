class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :post, foreign_key: true
      t.references :comment, foreign_key: true
      t.integer :visitor_id, null: false
      t.integer :visited_id, null: false
      t.string :action, null: false
      t.boolean :checked, null: false, default: false

      t.timestamps
    end

    add_index :notifications, :visitor_id
    add_index :notifications, :visited_id
  end
end
