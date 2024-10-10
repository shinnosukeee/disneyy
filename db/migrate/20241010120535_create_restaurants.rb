class CreateRestaurants < ActiveRecord::Migration[7.2]
  def change
    create_table :restaurants, id: false do |t|
      t.string :id, primary_key: true  # レストランIDを指定
      t.string :name, null: false

      t.timestamps
    end
  end
end
