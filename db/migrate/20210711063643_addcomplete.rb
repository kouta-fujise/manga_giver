class Addcomplete < ActiveRecord::Migration[5.2]
  def change
    add_column :gives,:complete,:integer
  end
end
