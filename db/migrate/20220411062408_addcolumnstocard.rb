class Addcolumnstocard < ActiveRecord::Migration[6.0]
  def change
    add_column :cards, :user_id, :integer
    add_column :cards, :customer_id, :string
    add_column :cards, :token_id, :string
  end
end
