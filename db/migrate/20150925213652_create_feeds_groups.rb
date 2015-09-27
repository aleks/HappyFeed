class CreateFeedsGroups < ActiveRecord::Migration
  def change
    create_table :feeds_groups do |t|
      t.integer :group_id
      t.integer :feed_id

      t.timestamps null: false
    end
    add_index :feeds_groups, :group_id
    add_index :feeds_groups, :feed_id
  end
end
