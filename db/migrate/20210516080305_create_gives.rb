class CreateGives < ActiveRecord::Migration[5.2]
  def change
    create_table :gives do |t|
      t.bigint :user_id
      t.bigint :book_id
      t.integer :price
      t.bigint :target_id
      t.integer :done

      t.timestamps
    end
  end
end
