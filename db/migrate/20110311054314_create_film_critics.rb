class CreateFilmCritics < ActiveRecord::Migration
  def self.up
    create_table :film_critics do |t|
      t.column :name, :string
      t.column :organizaton, :string
      t.column :thumbnail_image, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :film_critics
  end
end
