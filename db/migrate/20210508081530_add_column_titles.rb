class AddColumnTitles < ActiveRecord::Migration[5.2]
  def change
    rename_column :mangas, :manga_name, :name
    add_column :mangas, :author, :string
    add_column :mangas, :text, :text
    add_column :mangas, :image, :string
    add_column :mangas, :price, :integer
  end
end
