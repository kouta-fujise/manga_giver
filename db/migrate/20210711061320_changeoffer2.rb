class Changeoffer2 < ActiveRecord::Migration[5.2]
  def change
    add_column :offers,:given_by,:string
  end
end
