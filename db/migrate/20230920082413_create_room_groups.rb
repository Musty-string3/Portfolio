class CreateRoomGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :room_groups do |t|
      t.string :name, null: false
      t.text :group_description, null: false
      t.integer :count, null: false, default: 10
      
      t.timestamps
    end
  end
end
