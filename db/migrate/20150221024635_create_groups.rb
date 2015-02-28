class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :user_id
      t.string :title
      t.boolean :default, default: nil

      t.timestamps null: false
    end
  end
end
