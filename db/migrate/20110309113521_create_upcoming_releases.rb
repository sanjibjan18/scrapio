class CreateUpcomingReleases < ActiveRecord::Migration
  def self.up
    create_table :upcoming_releases do |t|
      t.column :name, :string
      t.column :hypelink, :string
      t.column :release_date, :string
      t.column :thumbnail, :string  
      t.timestamps
    end
  end

  def self.down
    drop_table :upcoming_releases
  end
end
