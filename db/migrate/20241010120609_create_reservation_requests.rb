class CreateReservationRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :reservation_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :restaurant, null: false, foreign_key: true, type: :string
      t.date :date, null: false
      t.integer :party_size, null: false
      t.integer :check_interval, null: false

      t.timestamps
    end
  end
end
