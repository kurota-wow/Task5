class CreateReservations < ActiveRecord::Migration[6.1]
  def change
    create_table :reservations do |t|
      t.date :checkin_date
      t.date :checkout_date
      t.integer :guests
      t.integer :stay_days
      t.integer :total_price

      t.timestamps
    end
  end
end
