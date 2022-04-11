class ChangeDatatype < ActiveRecord::Migration[6.0]
  def change
    change_column_default :users, :name, from: nil, to:"名無しの漫画ファン"
  end
end
