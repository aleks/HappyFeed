class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :title
      t.string :feed_url
      t.string :site_url
      t.boolean :is_spark, default: 0
      t.datetime :last_updated_on_time

      t.timestamps null: false
    end
  end
end
