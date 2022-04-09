class Chengegive < ActiveRecord::Migration[5.2]
  def change
    rename_column :gives, :book_id, :manga_id
  end
end
