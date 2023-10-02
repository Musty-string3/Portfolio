class CreateRates < ActiveRecord::Migration[6.1]
  def change
    create_table :rates do |t|
      t.references :user, null: false, foreign_key: true
      t.string :star, null: false
      t.text :text

      t.timestamps
    end
  end
end
