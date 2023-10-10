class CreateAdminNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_notifications do |t|
      t.integer :visitor_id, null: false
      t.integer :rate_id
      t.integer :violate_id
      t.string :action, null: false
      t.boolean :checked, default: false, null: false


      t.timestamps
    end

    # 検索率の向上
    add_index :admin_notifications, :visitor_id
    add_index :admin_notifications, :rate_id
    add_index :admin_notifications, :violate_id
  end
end
