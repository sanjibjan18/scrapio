class AddField < ActiveRecord::Migration
  def self.up
   add_column :upcoming_releases, :thumbnails, :string
  end

  def self.down
  end
end
