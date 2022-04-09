class Createaddress < ActiveRecord::Migration[5.2]
  def change
    add_column :users,:address1,:string
    add_column :users,:address2,:string
    add_column :users,:address3,:string
    add_column :users,:address4,:string
    add_column :users,:address5,:string
    add_column :users,:address6,:string
  end
end
