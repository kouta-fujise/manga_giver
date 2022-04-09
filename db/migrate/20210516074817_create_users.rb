class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password
      t.string :address
      t.integer :total_amount_paid
      t.float :total_books_given
      t.timestamps
    end
  end
end
