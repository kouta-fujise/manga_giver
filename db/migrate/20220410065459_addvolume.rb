class Addvolume < ActiveRecord::Migration[6.0]
  def change
    add_column :mangas,:volume,:integer
  end
end
