class CreateFeedsUsers < ActiveRecord::Migration
  def change
    create_table :feeds_users do |t|
      t.integer :user_id
      t.integer :feed_id

      t.timestamps null: false
    end
    add_index :feeds_users, :user_id
    add_index :feeds_users, :feed_id
  end
end
