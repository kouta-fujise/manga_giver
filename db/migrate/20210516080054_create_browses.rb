class CreateBrowses < ActiveRecord::Migration[5.2]
  def change
    create_table :browses do |t|
      t.bigint :user_id
      t.bigint :book_id
      t.datetime :browsed_at

      t.timestamps
    end
  end
end
