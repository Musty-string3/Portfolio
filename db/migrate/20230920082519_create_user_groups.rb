class CreateUserGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :user_groups do |t|
      t.references :user, null: false, foreign_key: true
      # デプロイ時に失敗したらこっち t.integer :user_id, null: false
      t.references :room_group, null: false, foreign_key: true
      t.boolean :is_leader, null: false, default: false

      t.timestamps
    end
  end
end
