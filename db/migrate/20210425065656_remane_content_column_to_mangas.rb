class RemaneContentColumnToMangas < ActiveRecord::Migration[5.2]
  def change
    rename_column :mangas, :content, :manga_name
  end
end
