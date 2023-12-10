class CreateMessageGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :message_groups do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room_group, null: false, foreign_key: true
      t.text :text, null: false

      t.timestamps
    end
  end
end
