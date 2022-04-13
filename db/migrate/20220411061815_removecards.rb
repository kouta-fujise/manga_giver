class Removecards < ActiveRecord::Migration[6.0]
  def change
    remove_column :cards, :user_id, :integer
    remove_column :cards, :customer_id, :varchar
    remove_column :cards, :card_id, :varchar
  end
end
