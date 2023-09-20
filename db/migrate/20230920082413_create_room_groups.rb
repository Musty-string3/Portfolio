class CreateRoomGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :room_groups do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.text :group_description, null: false
      
      t.timestamps
    end
  end
end
