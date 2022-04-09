class CreateOffers < ActiveRecord::Migration[5.2]
  def change
    create_table :offers do |t|
      t.bigint :user_id
      t.bigint :book_id
      t.datetime :offered_at
      t.integer :done
      t.datetime :given_at

      t.timestamps
    end
  end
end
