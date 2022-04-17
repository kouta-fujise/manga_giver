class Changegives < ActiveRecord::Migration[6.0]
  def change
    add_column :gives,:volume,:integer
    add_column :gives,:amount,:integer
  end
end
