class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id, null: false   #会員id
      t.string :post_name, null: false  #投稿名
      t.text :explanation, null: false  #説明文章

      t.timestamps
    end
  end
end
