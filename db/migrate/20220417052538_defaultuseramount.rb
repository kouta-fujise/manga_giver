class Defaultuseramount < ActiveRecord::Migration[6.0]
  def change
    change_column_default :users, :total_amount_paid, from: nil, to:0
    change_column :users, :total_books_given, :integer
    change_column_default :users, :total_books_given, from: nil, to:0
  end
end
