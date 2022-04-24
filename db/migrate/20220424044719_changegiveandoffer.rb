class Changegiveandoffer < ActiveRecord::Migration[6.0]
  def change
    rename_column :gives, :complete, :sent
    add_column :gives, :received, :integer
    add_column :gives, :offer_id, :integer
    add_column :offers, :give_id, :integer
    add_column :offers, :sent, :integer
    add_column :offers, :received, :integer
  end
end
