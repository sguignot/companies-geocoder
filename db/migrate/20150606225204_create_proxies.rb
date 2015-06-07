class CreateProxies < ActiveRecord::Migration
  def change
    create_table :proxies do |t|
      t.string :url
      t.datetime :last_query_at
      t.datetime :daily_quota_hit_at

      t.timestamps null: false
    end
    add_index :proxies, :url, unique: true
    add_index :proxies, :last_query_at
    add_index :proxies, :daily_quota_hit_at
  end
end
