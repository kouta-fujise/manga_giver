class Changeoffer < ActiveRecord::Migration[5.2]
  def change
    rename_column :offers, :book_id, :manga_id
  end
end
